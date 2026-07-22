{ pkgs, pkgs-unstable, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages =
    with pkgs; [
      vim
      wget
      curl
      git
    ]
    ++ (with pkgs-unstable; [
      opencode
    ]);
}
