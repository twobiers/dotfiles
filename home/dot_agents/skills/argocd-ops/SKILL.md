---
name: argocd-ops
description: Operate ArgoCD via CLI/API for a multi-cluster fleet - app sync/rollback, ApplicationSet patterns, diagnosing OutOfSync/Degraded health, and RBAC/project setup. Use when managing ArgoCD Applications or ApplicationSets, or troubleshooting sync/health state.
license: MIT
compatibility: opencode
---

# ArgoCD Operations

## Core commands
- `argocd app get <app>` — check sync/health status before any action.
- `argocd app diff <app>` — see exact drift between Git and live state before syncing.
- `argocd app sync <app> --dry-run` — validate a sync before applying.
- `argocd app rollback <app> <revision-id>` — fastest mitigation path during an incident; prefer this over a forward-fix under pressure.

## Diagnosing health states
- `OutOfSync`: live state differs from Git. Check `argocd app diff` first — don't blind-sync without understanding what changed.
- `Degraded`: a resource's health check failed. Check the specific resource (`kubectl describe`) — ArgoCD surfaces the health check result but not always the underlying cause.
- `Progressing` stuck: usually a readiness/liveness probe issue, a PodDisruptionBudget blocking a rollout, or an admission webhook (Kyverno) rejecting the resource silently — check Kyverno PolicyReports before assuming it's just slow.
- `Unknown`: often an RBAC issue (ArgoCD's service account lacks permission on that resource type) or a CRD not yet registered.

## ApplicationSets for fleet-wide patterns
- Use `cluster` generator to template one Application definition across all clusters in the fleet, keyed by cluster labels/metadata.
- Use `matrix` generator to combine cluster selection with per-environment value overlays (e.g., cluster × overlay).
- Test generator output with `argocd appset generate <file>` before applying — this renders the resulting Applications without creating them.

## RBAC / Projects
- Scope AppProjects tightly: restrict `sourceRepos`, `destinations` (cluster+namespace), and `clusterResourceWhitelist` per team/tenant rather than using the `default` project for everything.
- Sync windows (`syncWindows` in AppProject) to gate automated sync during risky periods (e.g., business hours for customer-facing namespaces).

## Safe rollout patterns
- Prefer `syncPolicy.automated` with `selfHeal: true` only once a workload has proven stable manually — don't default every new Application to full automation.
- Use `PreSync`/`PostSync` hooks for migrations or validation steps that must run before/after the main sync, not as a substitute for proper health checks.
