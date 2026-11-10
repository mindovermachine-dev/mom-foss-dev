---
title: Managed FOSS development stack
description: The proposed customer offering, operating model, and service scope for a sovereign development platform.
sidebar:
  order: 1
---

This internal strategy proposes a transparent, commercial open-source development platform for European small and medium-sized businesses and public-sector suppliers. It can also serve as the basis for an internal workshop. The goal is to provide development infrastructure with greater digital sovereignty without hyperscaler complexity.

## The offering

Each customer receives an isolated environment rather than a shared multitenant service. The proposed stack combines Forgejo for Git hosting, Synapse for Matrix messaging, and a shared identity provider in a Kubernetes cluster. PostgreSQL, persistent block storage, and S3-compatible object storage support the applications.

The customer owns and pays for the cloud account directly at retail rates. MoM sells the operating service separately, with an initial pricing idea of approximately 5,000 DKK per month per instance. Both the architecture and price are proposals to validate, not committed service terms.

## Basic service scope

The proposed basic service includes:

1. Setting up the infrastructure.
2. Maintaining the Helm charts.
3. Providing security updates.
4. Running periodic backups.

Restores, bridges, plugin development, customization, and consulting are additional services. The contract should specify the backup schedule, retention, recovery expectations, and responsibilities, including how restore testing is handled.

## Customer ownership

Direct billing helps customers retain control of their cloud account, credentials, and backups. It also avoids infrastructure credit and currency risk for MoM. The trade-off is that infrastructure revenue and provider partner support may be limited at the initially modest scale.
