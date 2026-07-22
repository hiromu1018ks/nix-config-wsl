# AGENTS.md

Flake-based NixOS-WSL configuration with home-manager (as a NixOS module).
See `README.md` for the directory layout and rebuild commands.

## Source of truth

- The **flake** (`flake.nix`) drives everything. `configuration.nix.channel.bak`
  is a legacy channel-based backup and is NOT evaluated — do not edit it.
- `stateVersion = "26.05"` (in `hosts/wsl/default.nix`, `hosts/wsl/home.nix`)
  is a pin, never bump it.

## Rebuild (the only verification step)

```bash
sudo nixos-rebuild test --flake .#nixos    # apply now, reverts on reboot (use this to verify changes)
sudo nixos-rebuild switch --flake .#nixos  # apply persistently
```

- The configuration name is **`nixos`**, not `wsl` (despite the host living in
  `hosts/wsl/`). `.#wsl` will fail.
- There is no test suite, lint, formatter, or CI. A clean `test` build is the
  success signal.
- For a non-applying pre-flight: `sudo nixos-rebuild build --flake .#nixos`.

## Where to make changes

| You want to add... | Edit |
| --- | --- |
| A flake input | `flake.nix` `inputs`, then thread it via `specialArgs`/`extraSpecialArgs` |
| System packages / NixOS settings | `modules/common.nix` |
| User packages, programs, services | `home/common.nix` (import per-domain files like `home/zsh.nix` here) |
| Per-host system overrides | `hosts/wsl/default.nix` |
| Per-host home overrides | `hosts/wsl/home.nix` |

## Two nixpkgs instances (critical)

`nixpkgs-unstable` intentionally does **not** `follows` `nixpkgs` so it can
track the latest release independently. It is passed to modules as
`pkgs-unstable` (via `specialArgs` in `flake.nix`). Packages that should track
latest (e.g. `opencode`) belong in `pkgs-unstable`, not `pkgs`.

## Overlay placement (critical)

`home-manager.useGlobalPkgs = true`. Overlays therefore go in
**`hosts/wsl/default.nix`** (alongside the `home-manager.*` block), NOT in
`home/common.nix` — a `nixpkgs.overlays` in home config is silently ignored
here.

## Home-manager specifics

- Runs as a NixOS module, not standalone. `inputs` is exposed to home config
  via `extraSpecialArgs`, so home files can reference flake inputs directly.
- New shared home settings go in `home/common.nix`; `hosts/wsl/home.nix` only
  sets identity (`username`, `homeDirectory`, `stateVersion`) and imports it.
- Per-domain home configuration (e.g. `programs.zsh`) can live in its own file
  (e.g. `home/zsh.nix`) and be imported from `home/common.nix`.

## Conventions

- Default user is `nixos`. This is a WSL system (`wsl.enable = true`).
- When editing a `.nix` file, match existing formatting (no formatter is
  configured). Keep function argument lists sorted `{ config, inputs, pkgs, ... }`
  style as seen in the files.
