---
name: golang-how-to
description: "Golang skills orchestrator — always active on any Golang coding, review, debug, or setup task. Reads the task context and loads the most relevant Go skills together: debugging a panic loads golang-troubleshooting + golang-safety; auditing security loads golang-security + golang-safety; refactoring loads golang-refactoring + golang-naming + golang-code-style. Also: disambiguates competing skills when two seem to overlap (safety vs security, naming vs code-style), and configures CLAUDE.md or AGENTS.md to force-trigger skills in a project (/golang-how-to configure)."
user-invocable: true
license: MIT
compatibility: Designed for Claude Code, opencode, or similar AI coding agents. Requires git.
metadata:
  author: samber
  version: "1.3.0"
---

**Persona:** You are a Go skills orchestrator. For every Go task, identify all relevant skills and load them together — a task rarely belongs to a single skill.

**Dependencies:** `gopls` — `go install golang.org/x/tools/gopls@latest`; wire it up via your agent's LSP integration or a gopls MCP server (see [Code navigation with gopls](#code-navigation-with-gopls)).

**Modes:**

- **Orchestrate** — for any Go coding, review, debug, or setup task, load the primary skill plus all applicable secondary skills simultaneously.
- **Disambiguate** — when two skills seem to overlap, show the boundary table. See [disambiguation.md](references/disambiguation.md).
- **Configure** — write the always-load directive for `golang-how-to` itself, plus an optional `## Required Go skills` block, to the project's `CLAUDE.md` or `AGENTS.md`. Follow [project-config.md](references/project-config.md).

## Skill loading

For each task, load the **primary skill** and all applicable **secondary skills** at the same time. Do not wait — load them together at the start.

| Intent | Primary | Also load |
| --- | --- | --- |
| Design an API, choose a pattern | `golang-design-patterns` | `golang-naming` |
| Name a type, function, or package | `golang-naming` | `golang-code-style` |
| Handle errors idiomatically | `golang-error-handling` | `golang-safety` (nil-heavy code) |
| Choose or optimize a data structure | `golang-data-structures` | `golang-safety` |
| Write or review tests | `golang-testing` | — |
| Debug a panic or unexpected behavior | `golang-troubleshooting` | `golang-safety` |
| Audit or write security-sensitive code | `golang-security` | `golang-safety` |
| Review formatting and style | `golang-code-style` | `golang-naming` |
| Refactor or restructure existing code | `golang-refactoring` | `golang-naming`, `golang-code-style` |
| Write godoc / README / CHANGELOG | `golang-documentation` | `golang-naming` |
| Adopt new Go language features / upgrade Go version | `golang-modernize` | — |

This table only covers the Go skills currently installed in this skill set (`~/.agents/skills/golang-*`). If you install more skills from the wider [cc-skills-golang](https://github.com/samber/cc-skills-golang) pack, add rows for them here.

## Code navigation with gopls

`gopls` gives semantic code intelligence for Go — go-to-definition, find references, diagnostics, package API, symbol search, refactoring. Reach it through whichever of these your agent supports: its own MCP server, a built-in LSP integration, or its CLI directly.

`gopls` only reasons about code that is present and resolvable in the local build: your workspace plus every dependency exactly as pinned in `go.sum` (including `replace` directives). For facts that aren't tied to your local build — version history, licenses, ecosystem-wide importers, a package you haven't added yet — use a pkg.go.dev lookup tool (e.g. `godig`, if installed) or a general documentation-fetching tool (e.g. Context7).

## Picking a lookup tool: gopls vs a pkg.go.dev tool vs govulncheck

Three tools can answer "is this dependency OK to use," and they don't overlap as much as they look:

- **`gopls`** answers questions about **your specific build**: your code plus every dependency exactly as pinned in `go.sum`, including `replace` directives pointing at forks or local paths. Its vulnerability-check operation (where available) runs a single, on-demand reachability check against the workspace as it stands right now.
- **A pkg.go.dev lookup tool** (e.g. `godig`, if installed) answers questions about the **published ecosystem**: any Go package or module, whether or not it's in your `go.mod` yet — versions, exported symbols, examples, importers, and known vulnerabilities in isolation, regardless of whether your build actually reaches the vulnerable code path.
- **`govulncheck`** (the standalone CLI) is the whole-tree audit: it walks the entire module's call graph to confirm which known vulnerabilities are actually reachable, and is the tool of record for CI gates and periodic security sweeps — see the `golang-security` skill for the remediation workflow.

Pick by task:

| Task | Tool |
| --- | --- |
| Find where a symbol is defined in your own repo, or its call sites | `gopls` |
| Jump into a dependency's exact resolved source (incl. forks/`replace`d versions) | `gopls` |
| Get compiler diagnostics right after an edit | `gopls` |
| Rename, extract, inline, or otherwise refactor local code | `gopls` |
| Check whether your current build can reach a known vulnerability, mid-edit | `gopls` (if it exposes a vulncheck operation) |
| Whole-tree vulnerability audit across the module (CI, periodic sweep) | `govulncheck ./...` |
| List versions, symbols, examples, importers, or license of a published package | a pkg.go.dev lookup tool, if installed |
| Docs for a non-Go library, or a Go module not indexed on pkg.go.dev | a general documentation-fetching tool (e.g. Context7) |

## Categories at a glance

| Category | Skills |
| --- | --- |
| Code Quality | `golang-code-style` `golang-documentation` `golang-error-handling` `golang-naming` `golang-safety` `golang-security` |
| Architecture & Design | `golang-data-structures` `golang-design-patterns` `golang-modernize` `golang-refactoring` |
| QA | `golang-testing` `golang-troubleshooting` |

The wider [cc-skills-golang](https://github.com/samber/cc-skills-golang) pack this skill set was drawn from also covers concurrency, context, structs/interfaces, database, gRPC/GraphQL, DI, CLI frameworks, performance/benchmarking, observability, CI, and several samber/\* library skills — none of those are installed in this skill set. [by-category.md](references/by-category.md) and [disambiguation.md](references/disambiguation.md) still describe that full catalog if you want to install more; treat any skill name in those two files that isn't in the table above as "not currently installed."

## Competing skills — boundary lines

- **Errors**: `golang-error-handling` (idioms, wrapping, logging) vs `golang-safety` (preventing panics, nil-safety)
- **Style**: `golang-code-style` (control flow, clarity) vs `golang-naming` (identifiers) vs `golang-documentation` (comments, docs)
- **Gap — correctness vs threat**: `golang-safety` (internal bugs) vs `golang-security` (external threats)
- **Gap — process vs target rules**: `golang-refactoring` (the safe, staged, at-scale _process_ of changing existing code — planning, ordering, gopls-driven mechanics, staged PRs) vs `golang-naming`/`golang-code-style`/`golang-design-patterns`/`golang-modernize` (what the resulting code should look like) — load `golang-refactoring` alongside whichever of these owns the target shape

## Configure mode

Write an always-load directive for `golang-how-to` itself to a project's `CLAUDE.md` or `AGENTS.md`, and optionally force-trigger specific secondary skills too. Running `/golang-how-to configure` writes the always-load directive if missing, and additionally lets the user confirm a `## Required Go skills` block for skills that must always apply beyond routing. Follow [project-config.md](references/project-config.md).

---

This skill is not exhaustive. Refer to individual skill files and the official Go documentation for detailed guidance.

If you encounter a bug or unexpected behavior in this skill plugin, open an issue at <https://github.com/samber/cc-skills-golang/issues>.
