# Development help and guidelines

Get going with tooling:

- [Mind Over Machine devcontainers in VS Code internal guide](https://github.com/orgs/mindovermachine-dev/discussions/5)

## GH token smartness

At least if you use before the devcontainer start and if you use [direnv](https://direnv.net/).

Can be used with `.envrc.private` if you have already authenticated your GH cli on local machine.

Start vs code from the terminal with direnv, it will have access to your GH token when starting.

(Does not work when you're already in the devcontainer)

```
direnv allow
direnv exec . code .
```

## Starting local k8s cluster

The devcontainer has tooling for minikube. You can completely with defaults, or tweak resources and minikube settings.

```sh
minikube start
```

Tweaking minikube (eg. driver to start containers) using configuration the minikube environment variables way, so you can persist for this specific project:

```sh
cp ./dev/minikube/cluster.env.example ./dev/minikube/cluster.env
# Edit the cluster.env file to tweak minikube settings as needed
source ./dev/minikube/cluster.env

minikube start
minikube kubectl get nodes
```

Minikube config can also be persisted globally, check official [minikube config](https://minikube.sigs.k8s.io/docs/handbook/config/) docs.

Kill minikube again: `minikube delete`
