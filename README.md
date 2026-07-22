# NixOS-WSL configuration

Flake-based NixOS-WSL configuration managed with home-manager.

## Structure

```
/etc/nixos/
├── flake.nix              # Top-level flake (inputs + nixosConfigurations)
├── hosts/
│   └── wsl/
│       ├── default.nix    # WSL host system config
│       └── home.nix       # Home Manager config for this host's user
├── modules/
│   └── common.nix         # Shared NixOS system settings
└── home/
    ├── common.nix         # Shared Home Manager settings
    └── zsh.nix            # Zsh configuration (prompt, plugins, aliases)
```

## Rebuild

```bash
sudo nixos-rebuild test --flake .#nixos    # apply temporarily (rollback on reboot)
sudo nixos-rebuild switch --flake .#nixos  # apply persistently
```

## Notes

- `home-manager` runs as a NixOS module with `useGlobalPkgs = true`; overlays
  must be defined in `hosts/wsl/default.nix` (next to the `home-manager.*`
  block), NOT in `home/common.nix`.
- Flake inputs all follow `nixpkgs` so there is a single nixpkgs instance,
  except `nixpkgs-unstable` which is kept separate so `opencode` can track
  the latest release (passed to modules as `pkgs-unstable`).
