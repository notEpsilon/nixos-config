{
  config,
  pkgs,
  inputs,
  ...
}:

{
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
