## Commit messages
- Concise, imperative mood, one line if possible (e.g. "fix race in socket-LB cleanup")
- Body only if it explains *why*, not what changed
- No filler phrases ("this commit", "various fixes", "minor changes")

## Code comments
- Only comment non-obvious reasoning, tradeoffs, or gotchas
- Never describe what the code visibly does
- Don't restate function/variable names in prose

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
