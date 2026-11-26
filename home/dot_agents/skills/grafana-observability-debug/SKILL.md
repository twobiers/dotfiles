---
name: observability-debug
description: Debug incidents, errors, latency, crashes, restarts, OOMs, network or DNS problems using Prometheus/Mimir metrics and Loki logs via the grafana MCP. Use when asked why something is broken, slow, flapping or alerting.
---

# Debugging with metrics and logs

Read-only. Never change dashboards, alerts or cluster state while debugging.

## Golden rules

- **Aggregate before you read.** Counts, rates and topk first; raw log lines last, and only a few.
- **Small windows.** Start with the incident window ±15m. Widen only to compare against a baseline.
- **Only use names you have seen.** Discover metric names, label names and label values before querying with them.
- **Every claim needs a query.** Each finding cites the exact query and the time range that showed it.
- **Change one thing per query.** If a query returns nothing, change one part (label, range, metric) and retry. Do not rewrite it from scratch.

## Workflow

1. **Scope.** Write down: what is broken (service/pod/node), since when, and the symptom (errors, latency, restarts, no data). If the time is unknown, find it in step 3.
2. **Discover.** List datasources. For the affected component, list matching metric names and the label values for `cluster`, `namespace`, `pod`/`job`/`instance`.
3. **Find the onset.** Use a range query on the key signal for the last 24h with a coarse step (5m) and find when it changed. From now on, use that onset ±15m.
4. **Check the signals** (stop when one clearly explains the symptom):
   - Requests: rate, error ratio and latency (p50/p99) of the affected service.
   - Saturation: CPU throttling, memory against the limit, OOMKills, restarts, disk, file descriptors.
   - Kubernetes: pod phase, container restarts, reasons for the last termination, node conditions, recent rollouts (changes to `kube_deployment_status_observed_generation`).
   - Dependencies: the same checks for whatever the service calls (DB, DNS, upstream API).
5. **Logs, aggregated first.**
   - Volume: `sum by (level) (count_over_time({…}[1m]))` to see if errors spike at the onset.
   - Patterns: `topk(10, sum by (msg) (count_over_time({…} | json | level="error" [$range])))`, or `pattern`/`logfmt` when it isn't JSON.
   - Only then fetch raw lines: limit 20–50, filtered to the onset window and error level.
6. **Correlate.** Line up the times: deployment, then first errors, then saturation or restarts. Check whether the cause comes before the effect. If a trace tool is available and logs carry a `trace_id`, check one slow or failed trace.
7. **Hypothesis loop.** State one hypothesis, run the query that would disprove it, and record the result. Use at most 3 hypotheses before reporting what you have.

## Recipes

PromQL:
```
# error ratio
sum(rate(http_requests_total{job="$job",code=~"5.."}[$__rate_interval])) / sum(rate(http_requests_total{job="$job"}[$__rate_interval]))
# p99 latency
histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket{job="$job"}[5m])))
# restarts in window
increase(kube_pod_container_status_restarts_total{namespace="$ns"}[1h]) > 0
# last termination reason (OOMKilled etc.)
kube_pod_container_status_last_terminated_reason{namespace="$ns"} == 1
# memory vs limit
sum by (pod) (container_memory_working_set_bytes{namespace="$ns",container!=""}) / sum by (pod) (kube_pod_container_resource_limits{namespace="$ns",resource="memory"})
# CPU throttling ratio
sum by (pod) (rate(container_cpu_cfs_throttled_periods_total{namespace="$ns"}[5m])) / sum by (pod) (rate(container_cpu_cfs_periods_total{namespace="$ns"}[5m]))
# target down
up{job="$job"} == 0
# what changed: compare to a day earlier
<expr> / (<expr> offset 1d)
```

LogQL:
```
# error volume per pod
sum by (pod) (count_over_time({namespace="$ns"} |~ "(?i)error|panic|fatal" [1m]))
# top error messages (JSON logs)
topk(10, sum by (msg) (count_over_time({namespace="$ns"} | json | level=~"error|fatal" [15m])))
# top error messages (unstructured)
topk(10, sum by (pattern) (count_over_time({namespace="$ns"} |~ "(?i)error" | pattern "<_> <pattern>" [15m])))
# k8s events, if collected
{job=~".*events.*"} |= "$pod"
```

## Anti-patterns

- Fetching thousands of raw log lines to "look around". Count them first.
- `rate()` on gauges, or reading raw counters as if they were rates.
- Querying 7d at a 15s step. Use a coarse step for long ranges.
- Concluding from a single datapoint, or a correlation where the "cause" comes after the effect.
- Blaming a component without checking that the same signal looks normal in a baseline window.

## Report format

```
Symptom:    <what, where, since when>
Root cause: <one sentence> (confidence: high/medium/low)
Evidence:
  1. <finding> — `<query>` @ <time range>
  2. ...
Ruled out:  <hypothesis> — `<query>` showed <result>
Next steps: <concrete checks or fixes; no changes made>
```
If the cause is unclear, say so and list what data is missing.
