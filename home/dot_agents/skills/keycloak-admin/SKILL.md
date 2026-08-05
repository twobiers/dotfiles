---
name: keycloak-admin
description: Administer Keycloak realms, clients, and OIDC/OAuth2 flows via the Admin REST API and kcadm CLI - multi-tenant realm design, client scope/role mapping, and token lifecycle troubleshooting. Use for realm/client configuration or diagnosing auth flow issues.
license: MIT
compatibility: opencode
---

# Keycloak Administration

## Admin REST API auth (do this first)
```
TOKEN=$(curl -s -X POST "$KC_URL/realms/master/protocol/openid-connect/token" \
  -d "client_id=admin-cli" -d "username=$ADMIN_USER" -d "password=$ADMIN_PASS" \
  -d "grant_type=password" | jq -r .access_token)
```
All subsequent calls: `curl -H "Authorization: Bearer $TOKEN" ...`. Token expires fast (default 60s for admin-cli) — refresh before long scripted sequences, don't assume one token lasts the whole session.

## Multi-tenant realm design (B2B pattern)
- One realm per tenant gives full isolation (separate user pools, separate IdP configs, separate themes) but doesn't scale past a few dozen tenants administratively.
- One shared realm with per-tenant client + custom user attribute (organization ID) scales better but requires enforcing tenant isolation in your own authorization logic (Keycloak won't do it for you) — the org ID must be embedded in the token as a claim (via a protocol mapper) and checked downstream.
- Decide this once per system, don't mix patterns across tenants in the same deployment.

## Client / scope / role mapping
- Confidential clients (server-side apps) use client secret or private_key_jwt; public clients (SPAs, mobile) must use PKCE — never configure a public client without `pkce.code.challenge.method: S256`.
- Client scopes control what claims land in the token — map roles/attributes to a dedicated client scope rather than bloating the default scope for every client.
- Use `kcadm.sh get clients/{id}/roles` and `get users/{id}/role-mappings` to verify actual effective roles when a token's claims don't match expectations — role mapping bugs are often composite-role misconfigurations, not the obvious client.

## Token lifecycle troubleshooting
- Decode the token (`jwt` cli locally or `jq` on the base64 payload) before assuming a code problem — check `exp`, `aud`, `iss`, and the actual claims present.
- `invalid_grant` on refresh: check refresh token reuse detection (Keycloak revokes the whole session on reuse if `revokeRefreshToken` is enabled) — a common cause when a client retries a failed refresh.
- Redirect URI mismatches: Keycloak validates exact match (or wildcard patterns if configured) — trailing slashes and http vs https mismatches are the most common cause of `invalid_redirect_uri`.

## kubectl OIDC integration
For `kubectl` OIDC auth against Keycloak: the client needs `Direct Access Grants` enabled if using the resource-owner password flow, or configure `kubelogin`/`oidc-login` for a proper browser-based auth-code+PKCE flow — don't use direct grants for interactive human users, reserve it for service accounts only if unavoidable.
