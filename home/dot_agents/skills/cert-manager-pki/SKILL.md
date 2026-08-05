---
name: cert-manager-pki
description: Diagnose and configure cert-manager Issuers/ClusterIssuers, Certificate resources, and renewal/revocation flows across a multi-cluster fleet. Use when a certificate isn't issuing, isn't renewing, or when setting up a new Issuer.
license: MIT
compatibility: opencode
---

# cert-manager PKI Operations

## Diagnosing a stuck Certificate
1. `kubectl describe certificate <name>` — check `status.conditions`, specifically the `Ready` condition's reason/message first.
2. `kubectl get certificaterequest -A | grep <name>` — a Certificate resource that's stuck usually has an underlying CertificateRequest that's failing; describe that next.
3. `kubectl get order,challenge -A` (ACME issuers only) — for Let's Encrypt-style issuers, check Order/Challenge resources for DNS-01 or HTTP-01 validation failures.
4. Common root causes: Issuer/ClusterIssuer misconfigured (wrong DNS provider credentials for DNS-01), rate limits hit (Let's Encrypt has strict per-domain limits), or a webhook/admission policy (Kyverno) blocking the Certificate resource itself.

## Issuer types and when to use which
- `ClusterIssuer` for fleet-wide CAs (internal PKI, wildcard certs shared across namespaces) — scope to specific namespaces via RBAC if not every namespace should be able to request from it.
- `Issuer` (namespaced) for tenant-specific or environment-specific trust chains where cross-namespace issuance shouldn't be possible.
- ACME (Let's Encrypt) for public-facing TLS; internal CA (Vault/OpenBao PKI backend, or cert-manager's `ca` issuer type) for internal service-to-service TLS — don't route internal mTLS through a public ACME issuer.

## Renewal
- Default renewal at 2/3 of certificate lifetime remaining — verify this hasn't been overridden to something too aggressive/lenient for your rate limits.
- Renewal failures silently stack: a Certificate that fails to renew doesn't page by default — pair this with an LGTM alert on `certmanager_certificate_expiration_timestamp_seconds` approaching zero, don't rely on noticing manually.

## Multi-cluster considerations
- Each cluster needs its own cert-manager instance and Issuer configuration unless using a shared external CA (e.g., OpenBao PKI secrets engine) — don't assume a ClusterIssuer name is fleet-wide, it's cluster-scoped by definition.
- For OpenBao-backed Issuers: verify the OpenBao PKI role's allowed domains/TTL match what's being requested, and check OpenBao's own audit log if issuance silently fails with no clear cert-manager-side error.
