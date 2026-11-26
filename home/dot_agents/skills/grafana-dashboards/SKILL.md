---
name: grafana-dashboards
description: Create, edit or fix Grafana dashboards, panels, variables, PromQL/LogQL panel queries, Mimir/Loki/Prometheus dashboards. Use for any Grafana dashboard JSON or panel work, in any project.
---

# Grafana dashboards

Skill dir: `~/.agents/skills/grafana-dashboards/`
- `scripts/dash-export.sh` — export a dashboard from Grafana into a file
- `examples/` — reference dashboards (normalized)

Target: the SCRATCH Grafana reached through the `grafana` MCP. Never touch production Grafana.
The project repo is the source of truth; finished dashboards are exported into it.

## Workflow (follow in order)

1. **Learn the project.** Find where the repo keeps dashboards (search for `*.json` containing `"panels"`). Read 1–2 of them with `jq` (only `title, uid, tags, templating.list[].name, panels[].type`) to pick up the project's datasource variable, variable names, tags and folder layout. Project conventions beat the defaults below. If the repo has none, use the defaults.
2. **Understand the target.** Existing dashboard: `get_dashboard_summary`, then `get_dashboard_property` with JSONPath for only the parts you need. Never fetch the full dashboard unless asked.
3. **Discover.** List datasources, then metric names, label names and label values. Use only names you actually saw.
4. **Test the query.** Run the PromQL/LogQL through the MCP query tool. It must return data. If empty, fix it before adding a panel.
5. **Change.** Use the patch tool — one panel/variable/row per call. Use `update_dashboard` (full JSON) only to create a new dashboard from the skeleton below.
6. **Verify.** `run_panel_query` on the changed panel. If rendering is available, render it and look at it.
7. **Export.**
   ```
   bash ~/.config/opencode/skills/grafana-dashboards/scripts/dash-export.sh <uid> <path-in-repo>.json
   ```
   Use the folder layout from step 1. Report the path.

## Default conventions (when the project has none)

- Datasources via variable only: `${datasource}` (Prometheus/Mimir), `${loki}` for logs. Never hardcode a uid.
- Variables in this order: `datasource`, `cluster`, `namespace`; `query` type, `refresh: 2`.
- Layout: 24-column grid. Stats `w:6 h:4` in the top row, timeseries `w:12 h:8` two per row, grouped in collapsible rows.
- Always set `fieldConfig.defaults.unit` (`s`, `bytes`, `percentunit`, `reqps`, `short`).
- Every query filters on `cluster="$cluster"` if the label exists; namespace panels also `namespace=~"$namespace"`.
- Titles in sentence case, no units in titles.

## Anti-patterns

- `rate()`/`increase()` on gauges; missing `rate()` on counters (`_total`, `_count`, `_sum`, `_bucket`).
- Fixed `[1m]` ranges; use `[$__rate_interval]`.
- `histogram_quantile` without `sum by (le, ...)`.
- Duplicate panel ids or overlapping `gridPos`.
- Hardcoded datasource uids.

## New-dashboard skeleton

```json
{
  "title": "TITLE",
  "uid": "kebab-case-uid",
  "tags": [],
  "timezone": "browser",
  "schemaVersion": 39,
  "time": { "from": "now-6h", "to": "now" },
  "templating": { "list": [] },
  "panels": []
}
```

## Examples

See `examples/*.json` when unsure about panel structure (timeseries, stat, logs, row with nested panels). Read only the panel you need with `jq`.
