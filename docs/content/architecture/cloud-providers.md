---
title: Cloud provider comparison
description: Candidate European cloud providers and illustrative infrastructure pricing for the proposed stack.
sidebar:
  order: 3
---

## Candidate providers

| Provider | Potential fit                                                                  | Considerations                                                                                                                                     |
| :------- | :----------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| Hetzner  | Price-to-performance, VPS instances, block volumes, and S3-compatible storage. | Kubernetes must be managed on the VPS; the source does not identify Hetzner as a tender winner. Confirm customer-account and billing arrangements. |
| Scaleway | Developer experience, managed Kubernetes, block storage, and object storage.   | Its tender offer is relevant to sovereignty-sensitive customers; verify the specific services and partner terms.                                   |
| OVHcloud | Broad catalog, managed Kubernetes, block storage, and object storage.          | Partnered with Post Telecom on the tender; verify applicable service credentials and direct-billing arrangements.                                  |
| STACKIT  | DACH and enterprise-oriented requirements, managed Kubernetes, and storage.    | Partner requirements and costs may be more suitable for larger integrations.                                                                       |

The initial shortlist for a lean VPS-based stack is Hetzner, Scaleway, and OVHcloud. Customer requirements for jurisdiction, service availability, sovereignty, support, and billing should drive the final choice.

## Illustrative monthly costs

The source strategy estimates the following monthly costs excluding VAT. These are historical planning estimates, not quotes; instance types, included resources, regions, egress, storage pricing, and public IP charges must be checked before use.

Both tiers assume 40 GB block storage, 100 GB object storage, and one public IPv4 address. The starter tier assumes 2 dedicated vCPUs and 8 GB RAM; the growth tier assumes 4 dedicated vCPUs and 16 GB RAM.

| Component         | Hetzner           | Scaleway  | OVHcloud |
| :---------------- | :---------------- | :-------- | :------- |
| Starter compute   | €43.49            | ~€53.65   | ~€42.70  |
| Growth compute    | €86.49            | ~€107.31  | ~€85.32  |
| Block storage     | ~€1.76–€2.29      | ~€3.97    | ~€3.48   |
| Object storage    | €6.49             | ~€1.61    | ~€1.40   |
| Public IPv4       | Included or €0.50 | ~€3.60    | ~€1.97   |
| **Starter total** | **~€52**          | **~€63**  | **~€50** |
| **Growth total**  | **~€95**          | **~€116** | **~€92** |

The source also suggests that shared or burstable instances could lower costs for smaller teams, subject to workload testing. Consult current [Hetzner](https://www.hetzner.com/cloud/general-purpose/), [Scaleway](https://www.scaleway.com/en/pricing/virtual-instances/), and [OVHcloud](https://blog.ovhcloud.com/en/posts/public-cloud-pricing-update-october-2026/) pricing before estimating a deployment.
