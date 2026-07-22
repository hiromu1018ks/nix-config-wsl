{ pkgs, pkgs-unstable, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    nss
    nspr
    atk
    cups
    dbus
    expat
    alsa-lib
    mesa
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
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
