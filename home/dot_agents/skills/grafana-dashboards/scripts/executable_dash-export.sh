#!/usr/bin/env bash
# dash-export.sh <uid> <repo-path>
# Pull a dashboard from the scratch Grafana and write it normalized into the repo.
set -euo pipefail

uid="${1:?usage: dash-export.sh <uid> <path>}"
out="${2:?usage: dash-export.sh <uid> <path>}"
: "${GRAFANA_URL:?}" "${GRAFANA_SERVICE_ACCOUNT_TOKEN:?}"

mkdir -p "$(dirname "$out")"

curl -fsS -H "Authorization: Bearer ${GRAFANA_SERVICE_ACCOUNT_TOKEN}" \
  "${GRAFANA_URL%/}/api/dashboards/uid/${uid}" \
| jq -S '
    .dashboard
    | del(.id, .version, .iteration)
  ' > "$out.tmp"

# minimal sanity checks
jq -e '.uid and .title and (.panels | type == "array")' "$out.tmp" >/dev/null
# includes panels nested in collapsed rows
dups=$(jq '[.panels[] | ., (.panels[]? // empty) | .id] | length - (unique | length)' "$out.tmp")
[ "$dups" -eq 0 ] || { echo "duplicate panel ids" >&2; exit 1; }

mv "$out.tmp" "$out"
echo "exported $uid -> $out"
