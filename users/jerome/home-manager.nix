{ inputs, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (
    pkgs.writeShellScriptBin "manpager" (
      if isDarwin then
        ''
          sh -c 'col -bx | bat -l man -p'
        ''
      else
        ''
          cat "$1" | col -bx | bat --language man --style plain
        ''
    )
  );
in
{
  home.stateVersion = "24.05";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages =
    [
      # Terminal
      pkgs.kitty
      pkgs.asciinema
      pkgs.bat
      pkgs.eza
      pkgs.fd
      pkgs.gh
      pkgs.htop
      pkgs.jq
      pkgs.ripgrep
      pkgs.tree
      pkgs.watch

      pkgs._1password
      pkgs.pinentry-tty

      # VCS
      pkgs.jujutsu

      # Languages
      pkgs.gopls

      pkgs.zigpkgs."0.13.0"

      pkgs.bun
      pkgs.pnpm

      # Language servers
      pkgs.nodePackages_latest.typescript-language-server
      pkgs.pyright
      pkgs.nixd

      # Formatter
      pkgs.nixfmt-rfc-style
      pkgs.black
      pkgs.isort
      pkgs.prettierd
      pkgs.rustfmt
    ]
    ++ (lib.optionals isDarwin [
      pkgs.cachix
      pkgs.tailscale
    ])
    ++ (lib.optionals (isLinux) [
      pkgs.bitwarden-cli
      pkgs.firefox
      pkgs.rofi
      pkgs.valgrind
      pkgs.zathura
    ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  home.file =
    {
      ".gdbinit".source = ./gdbinit;
      ".inputrc".source = ./inputrc;
    }
    // (
      if isDarwin then
        {
          "Library/Application Support/jj/config.toml".source = ./jujutsu.toml;
        }
      else
        { }
    );

  xdg.configFile =
    {
      "i3/config".text = builtins.readFile ./i3;
      "rofi/config.rasi".text = builtins.readFile ./rofi;
    }
    // (
      if isDarwin then
        {
          "rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;
        }
      else
        { }
    )
    // (
      if isLinux then
        {
          "jj/config.toml".source = ./jujutsu.toml;
        }
      else
        { }
    );

  programs.fzf = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zshrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [ "defer:2" ];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = [ "defer:2" ];
        }
        {
          name = "marlonrichert/zsh-autocomplete";
          tags = [ "defer:2" ];
        }
        {
          name = "jeffreytse/zsh-vi-mode";
          tags = [ "defer:2" ];
        }
      ];
    };
  };

  programs.direnv = {
    enable = true;

    config = {
      whitelist = {
        prefix = [ ];

        exact = [ "$HOME/.envrc" ];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Jerome Janicot";
    userEmail = "hey@jeromejanicot.com";
    signing = {
      key = "9D7D94E947E47AF0";
      signByDefault = true;
    };

    aliases = {
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "jeromejanicot";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "code/go";
  };

  programs.jujutsu = {
    enable = true;

    # I don't use "settings" because the path is wrong on macOS at
    # the time of writing this.
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "l";
    secureSocket = false;
    mouse = true;

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      set -g @dracula-show-battery false
      set -g @dracula-show-network false
      set -g @dracula-show-weather false

      bind -n C-k send-keys "clear"\; send-keys "Enter"

      run-shell ${inputs.tmux-pain-control}/pain_control.tmux
      run-shell ${inputs.tmux-dracula}/dracula.tmux
    '';
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.i3status = {
    enable = isLinux;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    withPython3 = true;

    plugins = with pkgs; [
      customVim.fzf
      customVim.vim-fzf
      customVim.nvim-harpoon
      customVim.vim-cue
      customVim.vim-misc
      customVim.vim-pgsql
      customVim.vim-zig
      customVim.AfterColors
      customVim.dracula
      customVim.nvim-comment
      customVim.nvim-conform
      customVim.nvim-dressing
      customVim.nvim-gitsigns
      customVim.nvim-lualine
      customVim.nvim-plenary
      customVim.nvim-lspconfig
      customVim.nvim-nui
      customVim.nvim-treesitter

      vimPlugins.vim-eunuch
      vimPlugins.vim-markdown
      vimPlugins.vim-nix
      vimPlugins.typescript-vim
      customVim.nvim-web-devicons
    ];

    extraConfig = (import ./vim-config.nix) { inherit inputs; };
  };

  programs.gpg.enable = !isDarwin;

  services.gpg-agent = {
    enable = isLinux;

    extraConfig = ''
      pinentry-program /etc/profiles/per-user/jerome/bin/pinentry
    '';

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
