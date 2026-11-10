---
title: Platform architecture
description: Proposed single-customer Kubernetes deployment, storage layout, networking, and backup approach.
sidebar:
  order: 1
---

## Deployment model

Each customer has an isolated Kubernetes cluster hosting Forgejo, Synapse, an identity provider, and PostgreSQL. The initial proposal is a single VPS running k3s or Talos Linux, with customer data separated from the boot disk. A single node is not highly available; recovery depends on backups and replacement infrastructure.

The proposed starter size is 2 dedicated vCPUs, 8 GB RAM, and a 40–80 GB boot disk. A growth tier uses 4 vCPUs and 16 GB RAM. These are starting assumptions, not capacity guarantees: validate them with realistic workloads, especially Matrix federation and identity provider memory use. Instance resizing may require downtime.

## Storage

- **Boot disk:** The operating system, Kubernetes runtime, and deployment tooling. Keep customer state outside it.
- **Persistent block storage:** PostgreSQL data and Forgejo Git repositories need filesystem semantics, including locking. The initial proposal is 40 GB, notionally divided into 15 GB for PostgreSQL and 25 GB for repositories. The actual volume layout, performance, expansion, and Kubernetes CSI support depend on the provider.
- **Application object storage:** An S3-compatible bucket for Synapse media and Forgejo LFS, packages, or attachments, where supported and configured by the chosen application versions.
- **Backup object storage:** A separate bucket for encrypted database dumps and repository backups, potentially in another EU location.

Do not mount S3 through a filesystem adapter as the active storage for Forgejo Git repositories. Git's filesystem and locking requirements are better served by block storage. Synapse S3 media storage requires an appropriate supported media storage provider or other integration; confirm the integration before deployment.

## Backup and recovery

The proposed nightly job creates a consistent PostgreSQL dump and incremental repository backup, encrypts them, and uploads them to the backup bucket. Restic or Borg are candidate tools. Object storage versioning or replication can help protect media, but neither substitutes for a tested backup and recovery plan.

Define retention, restore procedures, recovery objectives, credentials, and off-site protection with each customer. Restores are proposed as an additional service, while responsibility for testing recovery must be agreed explicitly.

## Networking

The baseline uses a static public IPv4 address, IPv6 where available, HTTPS ingress on ports `80` and `443`, and automated TLS certificates. Matrix federation can use port `443` with a correctly configured `.well-known/matrix/server` delegation; port `8448` is an alternative. Restrict administrative access and configure provider firewalls to match the deployment.
