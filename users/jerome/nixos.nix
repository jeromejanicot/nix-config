{ pkgs, inputs, ... }:

{
    environment.pathsToLink = [ "/share/zsh" ];

    environment.localBinInPath = true;

    programs.zsh.enable = true;

    users.users.jerome = {
        isNormalUser = true;
        home = "/home/jerome";
        extraGroups = [ "docker" "wheel" ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$6t5KYf97LYgnJkOf0hN8q.$jG5i8zhcq9G1cm0anRCJhEavRQQbx7mQbO8ez4DMhs1";
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSV8cXtCMsghA054k6TkRqVdMpq3eSsqQ47ghlIggqa hey@jeromejanicot.com"
        ];
    };


    nixpkgs.overlays = import ../../lib/overlays.nix ++ [
        (import ./vim.nix { inherit inputs; })
    ];
}
