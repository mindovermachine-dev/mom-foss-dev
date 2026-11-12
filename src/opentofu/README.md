# OpenTofu

Infrastructure configuration belongs here. The local backend stores state in
`tmp/opentofu`, outside this directory and ignored by Git.

The initial throwaway deployment creates one Ubuntu 24.04 `cpx02` server in
Helsinki, registers the SSH agent's public key, and attaches the existing
`157.180.32.185` Primary IP. It does not create a volume or application bucket.
The current Hetzner price for `cpx02` in Helsinki is about EUR 4.99 per month;
check Hetzner's pricing before applying.

From the repository root, prepare the local state directory and initialize with:

```sh
mkdir -p tmp/opentofu
export TF_DATA_DIR="$PWD/tmp/opentofu/tofu-data"
tofu -chdir=src/opentofu init
```

Load the Hetzner token into the environment, and pass the SSH public key from the
forwarded agent. Restrict SSH to the public IP of the machine you will connect
from; the example discovers this container's outbound IPv4, which may differ
from your SSH client's address:

```sh
export HCLOUD_TOKEN="$(yq -r '.hetzner.token' tmp/keys.yml)"
export TF_VAR_ssh_public_key="$(ssh-add -L | head -n 1)"
export TF_VAR_ssh_allowed_cidr="$(curl -4 -fsS https://api.ipify.org)/32"
tofu -chdir=src/opentofu plan
```

Review the plan before applying it. `tofu apply` creates billable resources;
`tofu destroy` removes the server, firewall, and registered key, but keeps the
pre-existing Primary IP. Verify the resulting resources in Hetzner Console.

Local state can contain secrets: back it up securely and do not commit it. The
`tmp` directory may be lost when the workspace or dev container is recreated.
The state can later be migrated to a remote backend. Unset the token when done:

```sh
unset HCLOUD_TOKEN TF_VAR_ssh_public_key TF_VAR_ssh_allowed_cidr
```
