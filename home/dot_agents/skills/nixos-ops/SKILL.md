---
name: nixos-ops
description: Procedural reference for flake input management, nixos-rebuild workflows, rollback, and build-failure/garbage-collection debugging on a NixOS workstation. Use for the exact command/flag to run, not for module design judgment (see nixos-specialist agent for that).
license: MIT
compatibility: opencode
---

# NixOS Operations

## Exploration / discovery
- `nix flake show` — list all outputs (packages, nixosConfigurations, devShells, etc.) a flake exposes, without building anything. First command to run on an unfamiliar flake or after adding a new output.
- `nix flake show --json | jq` — same, machine-readable, useful when scripting against outputs or when the tree is too large to read directly.
- `nix search nixpkgs <term>` — find a package by name/description in nixpkgs; add `--json` for scripting. Slow on first run (builds a search index), fast after.
- `nix eval .#<attr>` — evaluate a specific output's value directly (e.g., `nix eval .#nixosConfigurations.<host>.config.networking.hostName`) without building — fastest way to check what a config actually resolves to.
- `nixos-option <option.path>` — show the current value, default, and defining files for a specific NixOS option on the *built* system; useful when several modules could plausibly be setting something and you need to know which one won and from where.
- `nix repl` then `:lf .` (load flake) followed by tab-completion on `nixosConfigurations.<host>.config.<TAB>` — interactively browse the full option tree when you don't know the exact path yet; better than grepping modules blind.
- `home-manager news` / `man home-configuration.nix` — check for breaking changes or browse the full Home Manager option reference when exploring what's configurable there specifically (separate option tree from NixOS itself).

## Flake inputs
- `nix flake update` — update all inputs to their latest allowed revision per `flake.lock`'s constraints.
- `nix flake lock --update-input <input-name>` — update a single input without touching the others; prefer this for isolating what changed when something breaks after an update.
- `nix flake metadata` — inspect current locked revisions of all inputs without changing anything.
- `nix flake check` — evaluate the flake's outputs (including NixOS configurations) for errors before attempting a rebuild; catches most syntax/type errors cheaply.

## Rebuild workflow
- `nixos-rebuild build --flake .#<host>` — build only, no activation. Always run this first when a change is nontrivial; catches build failures without touching the running system.
- `nixos-rebuild switch --flake .#<host>` — build and activate immediately. Use once `build` succeeded and the change is understood.
- `nixos-rebuild boot --flake .#<host>` — build and set as the default boot entry, but don't activate now. Use for changes that might break the current session (display/GPU drivers, dock config) — reboot to test, with the previous generation still one boot-menu entry away if it fails.
- `nixos-rebuild test --flake .#<host>` — activate without adding a boot entry; reverts on next reboot regardless of outcome. Good for experimenting with something you don't want to commit to persisting.
- `--show-trace` appended to any of the above — always add this when an evaluation error's default message is too shallow to locate the failing module.

## Rollback
- `nixos-rebuild switch --rollback` — activate the previous generation immediately, without rebuilding.
- If the system won't boot at all: select the previous generation from the bootloader menu directly (GRUB/systemd-boot) — this works even if the current generation is broken enough that `nixos-rebuild` itself can't run.
- `nix profile history --profile /nix/var/nix/profiles/system` (or `sudo nix-env --list-generations -p /nix/var/nix/profiles/system`) — list system generations with dates, to identify which one to roll back to when it's not just "the previous one."

## Build failure debugging
- `nix log <drv-or-out-path>` — full build log for a specific derivation; needed when the top-level error just says a dependency failed to build.
- `nix why-depends <package-a> <package-b>` — trace why A depends on B; useful for closure-size bloat or an unexpected transitive dependency pulling in something that fails to build.
- `nix build .#<attr> --dry-run` — resolve what would be built/fetched without doing it; catches missing/renamed attributes fast when refactoring flake outputs.
- `nix repl` with `:lf .` (load flake) — interactively poke at flake outputs and module option values when a `flake check`/build error is too opaque to reason about statically.

## Garbage collection and generations
- `nix-collect-garbage -d` — delete all unreferenced store paths from old generations. Be aware this only clears generations that aren't referenced by the current bootloader entries — a broken current generation you might want to roll back to won't be collected, but stale *older* ones will be gone.
- `sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old` — prune old system generations explicitly before GC, if you want fine control over what's kept versus a blanket `-d`.
- Always confirm `nixos-rebuild switch` succeeded and the new generation is stable *before* running collect-garbage — GC after a bad switch removes your fallback.

## Hardware-specific rebuilds (dock/GPU changes)
- Prefer `boot` over `switch` for anything touching display/GPU/dock modules — a `switch` that breaks graphics can leave you without a way to fix it interactively, whereas `boot` lets you test via reboot with a known-good fallback one menu entry away.
