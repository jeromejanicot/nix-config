{
    description = "NixOS systems and tools for the Agency";

    inputs = {

        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        neovim-nightly-overlay = {
            url = "github:nix-community/neovim-nightly-overlay";

            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        # Other packages
        zig.url = "github:mitchellh/zig-overlay";

        # Non-flakes
        nvim-plenary.url = "github:nvim-lua/plenary.nvim";
        nvim-plenary.flake = false;
        nvim-harpoon.url = "github:ThePrimeagen/harpoon/harpoon2";
        nvim-harpoon.flake = false;
        nvim-conform.url = "github:stevearc/conform.nvim/v7.1.0";
        nvim-conform.flake = false;
        nvim-dressing.url = "github:stevearc/dressing.nvim";
        nvim-dressing.flake = false;
        nvim-gitsigns.url = "github:lewis6991/gitsigns.nvim/v0.9.0";
        nvim-gitsigns.flake = false;
        nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
        nvim-lspconfig.flake = false;
        nvim-lualine.url ="github:nvim-lualine/lualine.nvim";
        nvim-lualine.flake = false;
        nvim-nui.url = "github:MunifTanjim/nui.nvim";
        nvim-nui.flake = false;
        nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter/v0.9.2";
        nvim-treesitter.flake = false;
        nvim-treesitter-textobjects.url = "github:nvim-treesitter/nvim-treesitter-textobjects";
        nvim-treesitter-textobjects.flake = false;
        nvim-web-devicons.url = "github:nvim-tree/nvim-web-devicons";
        nvim-web-devicons.flake = false;
        nvim-comment.url = "github:numToStr/Comment.nvim";
        nvim-comment.flake = false;
        vim-fzf.url = "github:junegunn/fzf.vim";
        vim-fzf.flake = false;
        vim-cue.url = "github:jjo/vim-cue";
        vim-cue.flake = false;
        vim-pgsql.url = "github:lifepillar/pgsql.vim";
        vim-pgsql.flake = false;
        vim-zig.url = "github:ziglang/zig.vim";
        vim-zig.flake = false;
        vim-misc.url = "github:mitchellh/vim-misc";
        vim-misc.flake = false;
        vim-nord.url = "github:nordtheme/vim";
        vim-nord.flake = false;
        dracula.url = "github:dracula/vim";
        dracula.flake = false;

        tmux-pain-control.url = "github:tmux-plugins/tmux-pain-control";
        tmux-pain-control.flake = false;
        tmux-dracula.url = "github:dracula/tmux";
        tmux-dracula.flake = false;


    };

    outputs = {self, nixpkgs, home-manager, darwin, ...}@inputs: let

        overlays = [
            inputs.zig.overlays.default
        ];

        mkSystem = import ./lib/mksystem.nix {
            inherit overlays nixpkgs inputs;
        };
    in {
        nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
            system = "aarch64-linux";
            user   = "jerome";
        };

        nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
            system = "aarch64-linux";
            user = "jerome";
        };

        nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
            system = "x86_64-linux";
            user   = "jerome";
        };

        darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
            system = "aarch64-darwin";
            user   = "jerome";
            darwin = true;
        };
    };
}
