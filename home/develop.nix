{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    tree-sitter
    lua5_1
    lazygit
    stylua
    shfmt
    python3
    nodejs
    pnpm
    sqlite
  ];
}
