---
title: Identity and access
description: Identity provider options and role-based single sign-on for Forgejo and Synapse.
sidebar:
  order: 2
---

## Recommended approach

Use a dedicated identity provider, such as Keycloak or Authentik, to authenticate users to Forgejo and Synapse through OpenID Connect (OIDC). This keeps identity separate from either application and provides a place to manage users, groups, and connections to existing corporate identity systems such as Microsoft Entra ID or Google Workspace.

OIDC login does not by itself guarantee that provider groups map to Forgejo teams or Matrix room permissions. Verify the capabilities and configuration of each application and integration before promising centralized role-based authorization.

## Alternatives

Forgejo can act as an OAuth2 provider for Synapse, potentially reducing the number of components. The source strategy notes limitations in its claims and group mapping, so evaluate this option against the customer's authorization needs.

Matrix is a communication protocol rather than a general-purpose identity provider for Forgejo. A dedicated provider is the proposed default when shared identity and access management are required.
