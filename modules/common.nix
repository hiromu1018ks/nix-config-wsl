{ pkgs, pkgs-unstable, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # WSLg で Electron 等のGUIアプリの日本語が文字化けするため CJK フォントを導入
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans CJK JP"
      "Noto Sans"
    ];
    serif = [
      "Noto Serif CJK JP"
      "Noto Serif"
    ];
    monospace = [ "Noto Sans Mono CJK JP" ];
  };

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
      libGL
      vulkan-loader
    ])
    ++ [
      stdenv.cc.cc.lib
      mesa.drivers
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
