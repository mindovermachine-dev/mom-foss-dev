---
title: Decision register
description: The shared source of truth for what has been decided about the platform, and what is still open.
sidebar:
  order: 1
---

This register holds every decision about the cluster and the workloads on it, and every open question that blocks a decision. Long reasoning lives in linked research documents, not here.

## How the register works

- Each area has one table of open questions and one table of decisions.
- Identifiers have the form `<area>-q<n>` for a question and `<area>-d<n>` for a decision, for example `idn-q1` and `idn-d1`. They are numbered per area and never reused.
- A decision is written in the present tense, with the alternatives that were considered and a short rationale.
- A decision has the status **Proposed** or **Accepted**. Only an Accepted decision is in force.
- An answered question becomes a decision, and the question row keeps a pointer to that decision.
- Changes go through issue → branch → pull request. Changing a decision's status to Accepted in a merged pull request is what makes it official.
- A decision is never deleted. To reverse one, change its wording and rationale. The Git history keeps the earlier versions.

| Area            | Prefix | Covers                                                                    |
| :-------------- | :----- | :------------------------------------------------------------------------ |
| Identity        | `idn`  | Identity provider, accounts, single sign-on, secrets                      |
| Platform        | `plt`  | Cloud providers, Kubernetes, shared platform services such as databases   |
| Network         | `net`  | Ingress, DNS, TLS certificates                                            |
| Data and backup | `dr`   | Backups, restores, recovery objectives                                    |
| Engineering     | `eng`  | Repositories, provisioning, images, ways of working such as this register |
| Operations      | `ops`  | Deployment, upgrades, and changes to running systems                      |

## Identity

### Open questions

| ID       | Question                                                                                                                                                                                                 |
| :------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `idn-q1` | Does the identity provider run inside the customer cluster, or outside it, so that administrators can still log in when the cluster is down? Affects `idn-d1` and the break-glass access to the cluster. |
| `idn-q2` | Which tool manages secrets in a GitOps workflow: SOPS with Flux, External Secrets, or Sealed Secrets?                                                                                                    |

### Decisions

| ID       | Decision                                                                                           | Alternatives                                         | Rationale                                                                                                                                                                                             | Status   |
| :------- | :------------------------------------------------------------------------------------------------- | :--------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------- |
| `idn-d1` | authentik is the identity provider, and Forgejo and Synapse sign in through it with OpenID Connect | Keycloak; Forgejo as the OAuth2 provider for Synapse | authentik maintains an official Helm chart and needs only PostgreSQL. See the [authentik research](https://github.com/mindovermachine-dev/mom-foss-dev/blob/main/src/authentik/authentik-research.md) | Proposed |

## Platform

### Open questions

| ID       | Question                                                                                                                                             |
| :------- | :--------------------------------------------------------------------------------------------------------------------------------------------------- |
| `plt-q1` | Which cloud providers do we offer to customers: Hetzner, Scaleway, OVHcloud, or a combination?                                                       |
| `plt-q2` | Is Kubernetes managed by the provider, or self-run on virtual servers? Hetzner offers no managed Kubernetes, so this depends on `plt-q1`.            |
| `plt-q3` | Do authentik, Forgejo, and Synapse share one PostgreSQL cluster, or does each have its own? Sharing saves memory, but one failure affects all three. |

### Decisions

| ID       | Decision                                                                       | Alternatives                                                               | Rationale                                                                                                                                                              | Status   |
| :------- | :----------------------------------------------------------------------------- | :------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------- |
| `plt-d1` | The first test deployment runs on Hetzner Cloud in Helsinki                    | Scaleway; OVHcloud                                                         | Lowest cost for a throwaway environment. It does not settle `plt-q1`. See [`src/opentofu`](https://github.com/mindovermachine-dev/mom-foss-dev/tree/main/src/opentofu) | Proposed |
| `plt-d2` | The CloudNativePG operator provides PostgreSQL, as a shared platform component | The provider's managed PostgreSQL; the bundled database in each Helm chart | It works the same on every provider, is declarative, and handles failover and backups. The bundled database in the authentik chart is for testing only                 | Proposed |

## Network

### Open questions

| ID       | Question                                                      |
| :------- | :------------------------------------------------------------ |
| `net-q1` | Which ingress or Gateway API controller does the cluster use? |
| `net-q2` | Are DNS records managed by hand, or by external-dns?          |

### Decisions

| ID       | Decision                                                       | Alternatives                                                        | Rationale                                                                  | Status   |
| :------- | :------------------------------------------------------------- | :------------------------------------------------------------------ | :------------------------------------------------------------------------- | :------- |
| `net-d1` | cert-manager issues public TLS certificates from Let's Encrypt | Certificates issued by the provider or bought and installed by hand | The common Kubernetes approach, with automatic renewal and no licence cost | Proposed |

## Data and backup

### Open questions

| ID      | Question                                                                                                     |
| :------ | :----------------------------------------------------------------------------------------------------------- |
| `dr-q1` | What are the recovery point and recovery time objectives in the basic service, and where are backups stored? |

### Decisions

| ID  | Decision | Alternatives | Rationale | Status |
| :-- | :------- | :----------- | :-------- | :----- |

## Engineering

### Open questions

| ID       | Question                                                                                                     |
| :------- | :----------------------------------------------------------------------------------------------------------- |
| `eng-q1` | Are container images pulled from upstream registries, such as `ghcr.io`, or mirrored in a European registry? |

### Decisions

| ID       | Decision                                               | Alternatives                                             | Rationale                                                                                                                                                                                                                 | Status   |
| :------- | :----------------------------------------------------- | :------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------- |
| `eng-d1` | Decisions and open questions are kept in this register | One Architecture Decision Record (ADR) file per decision | One shared source of truth. Decided in [discussion #11](https://github.com/mindovermachine-dev/mom-foss-dev/discussions/11) and implemented in [issue #13](https://github.com/mindovermachine-dev/mom-foss-dev/issues/13) | Accepted |
| `eng-d2` | OpenTofu provisions the infrastructure                 | Terraform; the provider's own tools                      | An open-source, provider-neutral tool. Already used for the test deployment (`plt-d1`)                                                                                                                                    | Proposed |

## Operations

### Open questions

| ID  | Question |
| :-- | :------- |

### Decisions

| ID       | Decision                                     | Alternatives                                   | Rationale                                                                                                 | Status   |
| :------- | :------------------------------------------- | :--------------------------------------------- | :-------------------------------------------------------------------------------------------------------- | :------- |
| `ops-d1` | Flux deploys the workloads from Git (GitOps) | Argo CD; `helm upgrade` run by hand or from CI | Proposed in [Deployment and operations](../../delivery/deployment/). Flux is already in the dev container | Proposed |
