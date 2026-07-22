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
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
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
