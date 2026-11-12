# Authentik Helm chart research

Findings from November 2026 on whether authentik maintains a Helm chart, and what input it needs.

## Official chart

- authentik maintains an official chart: `authentik/authentik` from `https://charts.goauthentik.io` ([source](https://github.com/goauthentik/helm)).
- The current version is 2026.8.5. The chart version matches the authentik release.
- It deploys a **server** (ports 9000/9443, metrics on 9300) and a **worker**, with 1 replica each by default.
- It has an optional bundled PostgreSQL (a Bitnami subchart, off by default) that the authentik docs mark as for testing only.

## Required input

| Value                                                      | Notes                                                                                                 |
| :--------------------------------------------------------- | :---------------------------------------------------------------------------------------------------- |
| `authentik.secret_key`                                     | Signs cookies and user IDs. Must never change after the first install.                                |
| `authentik.postgresql.host`, `.name`, `.user`, `.password` | External PostgreSQL 14–18. A TLS connection must use TLS 1.3 or the Extended Master Secret extension. |
| `server.ingress.*` or `server.route.main`                  | Hostname, ingress class, and TLS. The Gateway API route needs a Gateway created separately.           |

These values can be supplied from an existing Kubernetes secret via `authentik.existingSecret.secretName`.

## Optional input to consider

- **Email:** `authentik.email.*`, needed for password recovery and alerts.
- **File storage:** `/data` is not mounted by default. Add a volume, or set `AUTHENTIK_STORAGE__BACKEND=s3` to use S3-compatible object storage.
- **Unattended first boot:** set `AUTHENTIK_BOOTSTRAP_PASSWORD_HASH`, `AUTHENTIK_BOOTSTRAP_TOKEN`, and `AUTHENTIK_BOOTSTRAP_EMAIL` on the worker. They are read on first startup only.
- **Blueprints:** `blueprints.configMaps` and `blueprints.secrets` hold declarative YAML configuration. They could set up the Forgejo and Synapse OIDC providers.
- **Error reporting:** `authentik.error_reporting.enabled` sends data to sentry.io. Keep it off for a sovereignty offering.

## Implications

- The stated minimum is 2 CPU cores and 2 GB RAM. Measure actual use on the starter instance.
- Use an external PostgreSQL such as CloudNativePG, and include authentik's extra connections when sizing a shared database.
- The future of Bitnami charts is uncertain after Bitnami's catalog changes ([goauthentik/helm#319](https://github.com/goauthentik/helm/issues/319)). This is another reason to avoid the bundled database.

## Dependencies

authentik relies on the following services outside its own chart. This research only identifies them and suggests a solution for each. Their design and implementation are separate tasks, ideally as shared platform components rather than part of the authentik deployment.

| Dependency       | What authentik needs                                                                      | Suggested solution                                                                      |
| :--------------- | :---------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------- |
| PostgreSQL       | An external database, version 14–18. The bundled database is for testing only.            | The [CloudNativePG](https://cloudnative-pg.io/) operator                                |
| Secrets          | The secret key, database credentials, and optionally SMTP, S3, and bootstrap credentials. | A GitOps-safe secrets tool, such as SOPS with Flux, External Secrets, or Sealed Secrets |
| TLS certificates | A certificate for the public hostname, and the database CA if the database uses TLS.      | cert-manager with Let's Encrypt                                                         |
| Ingress and DNS  | An ingress controller or Gateway, and a DNS record for the hostname.                      | The cluster's ingress or Gateway controller; DNS records by hand or with external-dns   |
| File storage     | Persistent storage for `/data` (icons, branding, reports).                                | A persistent volume (requires a StorageClass) or an S3 bucket                           |
| SMTP             | An outgoing mail server for password recovery and notifications.                          | The customer's mail service or a European mail relay                                    |
| Container images | Images are pulled from `ghcr.io/goauthentik`, which is hosted on GitHub, a US company.    | A mirror in a European registry, if sovereignty requires it                             |

authentik does not need Redis, which was removed in release 2025.10. Outposts are only needed for LDAP, RADIUS, or forward-auth proxying, not for OIDC login to Forgejo and Synapse.

## Sources

- [Kubernetes installation](https://docs.goauthentik.io/install-config/install/kubernetes/)
- [Configuration reference](https://docs.goauthentik.io/install-config/configuration/)
- [Automated install](https://docs.goauthentik.io/install-config/automated-install/)
- [Release 2025.10](https://docs.goauthentik.io/releases/2025.10/)
