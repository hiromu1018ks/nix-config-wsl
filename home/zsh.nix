{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";

    history = {
      path = "${config.home.homeDirectory}/.zhistory";
      save = 1000;
      size = 999;
      share = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Enable Powerlevel10k instant prompt.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
      # Powerlevel10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Keybinds
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # FZF theme
      fg="#CBE0F0"
      bg="#011628"
      bg_highlight="#143652"
      purple="#B388FF"
      blue="#06BCE4"
      cyan="#2CF9ED"

      export FZF_DEFAULT_OPTS="--color=fg:''${fg},bg:''${bg},hl:''${purple},fg+:''${fg},bg+:''${bg_highlight},hl+:''${purple},info:''${blue},prompt:''${cyan},pointer:''${cyan},marker:''${cyan},spinner:''${cyan},header:''${cyan}"

      # Use fd instead of fzf for search
      export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
      export FZF_CTRL_T_COMMAND="''${FZF_DEFAULT_COMMAND}"
      export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

      _fzf_compgen_path() {
        fd --hidden --exclude .git . "$1"
      }

      _fzf_compgen_dir() {
        fd --type=d --hidden --exclude .git . "$1"
      }

      show_file_or_dir_preview="if [ -d {} ]; then ${pkgs.eza}/bin/eza --tree --color=always {} | head -200; else ${pkgs.bat}/bin/bat -n --color=always --line-range :500 {}; fi"

      export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
      export FZF_ALT_C_OPTS="--preview '${pkgs.eza}/bin/eza --tree --color=always {} | head -200'"

      _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
          cd)           fzf --preview '${pkgs.eza}/bin/eza --tree --color=always {} | head -200' "$@" ;;
          export|unset) fzf --preview "eval 'echo \''${}'"         "$@" ;;
          ssh)          fzf --preview 'dig {}'                   "$@" ;;
          *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
        esac
      }

      # Bat theme
      export BAT_THEME=tokyonight_night
    ''
    ];

    shellAliases = {
      reload-zsh = "source ~/.zshrc";
      edit-zsh = "nvim ~/.zshrc";
      clear = "clear -x";
      cl = "clear -x";
      cat = "bat";
      grep = "rg";
      ls = "eza --icons always --classify always";
      la = "eza --icons always --classify always --all";
      ll = "eza --icons always --long --all --git";
      tree = "eza --icons always --classify always --tree";
      cd = "z";
      python = "python3";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.zsh";
      }
    ];

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight_night";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}
