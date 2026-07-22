{ pkgs, pkgs-unstable, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries =
    with pkgs;
    (map lib.getLib [
      glib
      dbus
      libdrm
      pango
      nss
      nspr
      atk
      at-spi2-atk
      at-spi2-core
      cups
      gdk-pixbuf
      expat
      alsa-lib
      mesa
      gtk3
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
      libgbm
      libxkbcommon
      zlib
    ])
    ++ [ stdenv.cc.cc.lib ];

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
