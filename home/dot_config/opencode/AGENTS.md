## Commit messages
- Concise, imperative mood, one line if possible (e.g. "fix race in socket-LB cleanup")
- Body only if it explains *why*, not what changed
- No filler phrases ("this commit", "various fixes", "minor changes")

## Code comments

Default to no comment. Prefer better names, smaller functions or types.

Only comment to explain:

- **why** something non-obvious is done (constraint, trade-off, workaround + issue link)
- **what breaks** if the obvious change is made
- the **contract** of exported/public APIs

Never:

- restate what the code does
- describe your changes or history ("added", "fixed", "now uses"); that goes in the commit message
- leave commented-out code or untracked TODOs

When changing code, fix or delete any comment it makes wrong. Don't touch comments in unrelated code.

## Scope discipline
- Don't refactor, rename, or reformat code outside the requested change
- Don't touch unrelated files "while you're in there"
- If a fix requires touching more than the stated scope, stop and ask first

## Verification before claiming done
- Never say "this should work" — run it or say you didn't
- If a test fails, don't weaken/delete the test to make it pass — fix the code or flag it

## Dependencies & tools
- Don't add new dependencies without asking
- Don't silently downgrade/upgrade package versions to resolve conflicts — surface the conflict
- Prefer existing project patterns/libs over introducing new ones for the same purpose

## Destructive actions
- Never force-push, rebase shared branches, or delete files/branches without explicit confirmation
- Never run migrations, `kubectl delete`, `kubectl apply`, `kubectl patch`, `terraform apply`, or similar against real clusters without confirmation — always dry-run first when available

## Honesty about uncertainty
- If unsure whether an API/config/flag exists, say so or check docs — don't guess and present it as fact
- Flag assumptions explicitly rather than silently picking one

## Diffs & output
- Show diffs for review before applying multi-file changes
- Don't regenerate/rewrite an entire file when a targeted patch works


## Waiting for state changes
Avoid using a bare `sleep N` to wait. Block on the actual condition, always with an explicit timeout.

| Waiting for                          | Use                                                                                                                 |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| Pod/Deployment ready                 | `kubectl rollout status deploy/x --timeout=120s` / `kubectl wait --for=condition=Ready pod -l app=x --timeout=120s` |
| Arbitrary field                      | `kubectl wait --for=jsonpath='{.status.phase}'=Bound pvc/x --timeout=60s`                                           |
| Deletion                             | `kubectl wait --for=delete pod/x --timeout=60s`                                                                     |
| Job                                  | `kubectl wait --for=condition=complete job/x --timeout=300s` (on timeout also check `condition=failed`)             |
| CRs (Certificate, ExternalSecret, …) | `kubectl wait --for=condition=Ready certificate/x --timeout=120s`                                                   |
| ArgoCD app                           | `argocd app wait x --sync --health --timeout 300`                                                                   |
| HTTP endpoint                        | `curl -sf --retry 30 --retry-delay 2 --retry-all-errors --retry-connrefused URL`                                    |
| Log line                             | `timeout 120 kubectl logs -f pod/x \| grep -m1 'pattern'`                                                           |
| File appears                         | `inotifywait -e create,moved_to --timeout 60 DIR`                                                                   |
| Process exit                         | `wait $PID` or `tail --pid=$PID -f /dev/null`                                                                       |
| Containers                           | `docker compose up --wait`, `docker wait`                                                                           |

If no event or wait primitive exists, use a bounded poll:
`timeout 60 bash -c 'until <check>; do sleep 1; done'`

Never use `kubectl get -w` or any unbounded `-f` follow without `timeout` (they never return).
On timeout: diagnose (`kubectl describe`, `kubectl get events --sort-by=.lastTimestamp`, logs). Do not retry with a longer sleep.
