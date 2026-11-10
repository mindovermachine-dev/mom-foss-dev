---
title: Deployment and operations
description: Proposed Helm, OpenTofu, and GitOps workflow for provisioning and operating customer instances.
sidebar:
  order: 1
---

## Upstream charts

Use pinned, actively maintained upstream charts where practical, and evaluate their maintenance and compatibility before adoption:

- **Identity:** Bitnami Keycloak, Codecentric KeycloakX, or the official Authentik chart. Measure memory consumption on the proposed starter instance.
- **Forgejo:** The official Forgejo Helm chart, with external PostgreSQL, OIDC, and supported object-storage configuration.
- **Synapse:** A maintained community Synapse chart, with PostgreSQL, Matrix delegation, and a suitable media storage integration.
- **PostgreSQL:** CloudNativePG or a PostgreSQL chart. A shared PostgreSQL instance with separate application databases can reduce overhead, but creates a shared failure domain.

## Umbrella chart

The proposed `sovereign-mom-foss-stack` Helm umbrella chart would pin the selected dependencies instead of forking their manifests. A customer-specific `values.yaml` file would configure domains, storage, and other deployment settings.

The chart and supporting automation should configure OIDC trust, Kubernetes secrets, ingress and TLS for the Git, chat, and identity services, Matrix federation delegation, and scheduled backups. Validate which parts can be automated reliably with the selected application and chart versions.

## Infrastructure provisioning

OpenTofu provisions the infrastructure before application deployment:

1. Create networking, public addresses, and firewall rules, including a restricted administrative access path.
2. Provision persistent block storage, application and backup buckets, and scoped storage credentials.
3. Create the VPS and bootstrap Kubernetes and the provider's CSI driver.
4. Install or bootstrap the chosen GitOps controller.

Keep customer configuration and state isolated. Protect OpenTofu state and outputs because they may contain credentials, including `kubeconfig` and object storage secrets. Use an appropriately secured state backend and secret-management process rather than assuming a `terraform.tfvars` file is the state.

## GitOps and lifecycle

Flux CD or Argo CD can reconcile each customer cluster from a dedicated branch or directory in a private repository. Pinned chart updates can then be reviewed, rolled out, and monitored across customers. Automated reconciliation does not remove the need for rollout controls, health monitoring, or recovery procedures.

The proposed lifecycle is:

1. The customer signs a contract and establishes customer-owned cloud billing.
2. OpenTofu provisions the server, storage, networking, Kubernetes, CSI driver, and GitOps controller.
3. GitOps deploys the applications, TLS, and identity configuration.
4. The customer receives an administrator login after verification.

The source suggests provisioning in minutes; actual timings depend on providers, DNS, certificates, application readiness, and validation, and should not be treated as a service commitment.
