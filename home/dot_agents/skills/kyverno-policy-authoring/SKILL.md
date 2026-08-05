---
name: kyverno-policy-authoring
description: Author, test, and safely roll out Kyverno ClusterPolicies - validate/mutate/generate rule ordering, audit-to-enforce migration, exception handling, and PolicyReport triage. Use when writing a new policy or debugging why a resource was blocked/mutated unexpectedly.
license: MIT
compatibility: opencode
---

# Kyverno Policy Authoring

## Rule type and evaluation order
Kyverno evaluates rules within a policy in this order regardless of declaration order: **mutate → validate → generate**. When a resource seems to violate a policy that should have mutated it first, check whether the mutation actually applied before validation ran — a common source of "why did this get blocked" confusion.

## Audit-to-enforce rollout (do this every time, never enforce cold)
1. Deploy the policy with `validationFailureAction: Audit`.
2. Let it run against real traffic for a representative period; check `kubectl get polr -A` (PolicyReports) for what *would* have been blocked.
3. Review every would-be violation — false positives usually mean the policy match/exclude selectors are too broad.
4. Only then flip to `validationFailureAction: Enforce`, ideally per-namespace first via policy exceptions before fleet-wide.

## Common policy patterns
- **Validate**: `pattern` for structural checks (required fields, disallowed values); `deny.conditions` for more complex boolean logic across multiple fields.
- **Mutate**: `patchStrategicMerge` for straightforward field injection (labels, resource defaults); `patchesJson6902` when you need precise array manipulation.
- **Generate**: for auto-provisioning per-namespace resources (default NetworkPolicy, ResourceQuota) — remember `generate` rules only fire on the trigger resource's create/update, not retroactively on existing resources unless a background scan is configured.

## Exceptions
- Use `PolicyException` resources (Kyverno 1.11+) scoped to specific namespaces/resources rather than editing the ClusterPolicy's `exclude` block for one-off cases — exceptions are auditable and reversible independently of the policy itself.
- Every exception should have a reason and an owner in an annotation — an exception with no documented justification is technical debt.

## Debugging "why was my resource blocked/mutated"
1. `kubectl get polr,cpolr -A` — check PolicyReports/ClusterPolicyReports for the specific resource.
2. `kubectl describe <resource>` — admission webhook rejection messages usually name the specific policy/rule.
3. Check for rule ordering surprises: a validate rule can reject a resource *before* a mutate rule from a different policy would have fixed it, since ordering is per-policy, not global.
4. For generate rules not firing on existing resources: trigger a background scan (`polr-controller` reconcile) rather than assuming the rule is broken.
