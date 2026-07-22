{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./develop.nix
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    eza
    fd
    ripgrep
    unzip
    trash-cli
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        ControlMaster = "auto";
        ControlPersist = "10m";
      };
      "github" = {
        Host = "github";
        HostName = "github.com";
        User = "git";
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
        IdentitiesOnly = "yes";
      };
    };
  };

  services.ssh-agent.enable = true;
}
