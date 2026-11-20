{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.direnv-instant.homeModules.direnv-instant
  ];

  home.stateVersion = "26.05";
  xdg = {
    enable = true;
    configFile = {
      "sway".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/sway";
      "foot".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/foot";
      "nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/nvim";
    };
  };
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.packages = with pkgs; [
    fd
    jq
    gh
    fzf
    tree
    watch
    ripgrep
    fastfetch

    clang
    neovim
    valgrind

    cargo
    nodejs
    tree-sitter
  ];

  programs.direnv.enable = true;

  programs.direnv-instant = {
    enable = true;
    settings.mux_delay = 1;
  };

  programs.bat = {
    enable = true;
    config = {
      paging = "never";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Ibrahim Amin";
      user.email = "ibrahimnasr393@gmail.com";
      github.user = "notEpsilon";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    focusEvents = true;
    clock24 = true;
    extraConfig = ''
      set -as terminal-features ",foot*:RGB"
      set -g renumber-windows on

      # open splits/windows in the current pane's directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -T copy-mode-vi v send -X begin-selection
      bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded"
    '';
  };

  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
        exec sway
      fi
    '';
  };

  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

    settings = {
      theme = "dark";
      includeCoAuthoredBy = false;

      extraKnownMarketplaces = {
        ponytail.source = {
          source = "github";
          repo = "DietrichGebert/ponytail";
        };
      };

      enabledPlugins."ponytail@ponytail" = true;
    };
  };

  services.flameshot = {
    enable = true;

    settings = {
      General = {
        useGrimAdapter = true;
        savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
