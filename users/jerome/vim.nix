{ inputs }:

self: super:

{
  # My vim config
  customVim = with self; {
    vim-fzf = vimUtils.buildVimPlugin {
      name = "vim-fzf";
      src = inputs.vim-fzf;
    };

    vim-cue = vimUtils.buildVimPlugin {
      name = "vim-cue";
      src = inputs.vim-cue;
    };

    vim-misc = vimUtils.buildVimPlugin {
      name = "vim-misc";
      src = inputs.vim-misc;
    };

    vim-pgsql = vimUtils.buildVimPlugin {
      name = "vim-pgsql";
      src = inputs.vim-pgsql;
    };

    vim-zig = vimUtils.buildVimPlugin {
      name = "zig.vim";
      src = inputs.vim-zig;
    };

    dracula = vimUtils.buildVimPlugin {
      name = "dracula";
      src = inputs.vim-dracula;
    };

    AfterColors = vimUtils.buildVimPlugin {
      name = "AfterColors";
      src = pkgs.fetchFromGitHub {
        owner = "vim-scripts";
        repo = "AfterColors.vim";
        rev = "9936c26afbc35e6f92275e3f314a735b54ba1aaf";
        sha256 = "0j76g83zlxyikc41gn1gaj7pszr37m7xzl8i9wkfk6ylhcmjp2xi";
      };
    };

    vim-nord = vimUtils.buildVimPlugin {
      name = "vim-nord";
      src = inputs.vim-nord;
    };

    nvim-harpoon = vimUtils.buildVimPlugin {
      name = "nvim-harpoon";
      src = inputs.nvim-harpoon;
    };

    nvim-comment = vimUtils.buildVimPlugin {
      name = "nvim-comment";
      src = inputs.nvim-comment;
      buildPhase = ":";
    };

    nvim-conform = vimUtils.buildVimPlugin {
      name = "nvim-conform";
      src = inputs.nvim-conform;
    };

    nvim-dressing = vimUtils.buildVimPlugin {
      name = "nvim-dressing";
      src = inputs.nvim-dressing;
    };

    nvim-gitsigns = vimUtils.buildVimPlugin {
      name = "nvim-gitsigns";
      src = inputs.nvim-gitsigns;
    };

    nvim-lualine = vimUtils.buildVimPlugin {
      name = "nvim-lualine";
      src = inputs.nvim-lualine;
    };

    nvim-nui = vimUtils.buildVimPlugin {
      name = "nvim-nui";
      src = inputs.nvim-nui;
    };

    nvim-treesitter = vimUtils.buildVimPlugin {
      name = "nvim-treesitter";
      src = inputs.nvim-treesitter;
    };

    nvim-lspconfig = vimUtils.buildVimPlugin {
      name = "nvim-lspconfig";
      src = inputs.nvim-lspconfig;

      # We have to do this because the build phase runs tests which require
      # git and I don't know how to get git into here.
      buildPhase = ":";
    };

    nvim-web-devicons = vimUtils.buildVimPlugin {
      name = "nvim-web-devicons";
      src = inputs.nvim-web-devicons;
    };
  };
}
