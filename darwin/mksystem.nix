{
  lib,
  inputs,
  nixpkgs,
  darwin,
  home-manager,
  vars,
  overlays,
  ...
}: arch: let
  system = "${arch}-darwin";
in
  darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {inherit inputs vars;};
    modules = [
      ./configuration.nix
      ./nix.nix
      (import ./nixpkgs.nix {inherit overlays;})
      home-manager.darwinModules.home-manager
      ({pkgs, ...}: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.fundon = {
          home.stateVersion = "23.05";
          home.sessionVariables = {
            EDITOR = "${vars.editor}";
            PAGER = "less -FirSwX";
            # https://github.com/NixOS/nix/issues/2982
            NIX_PATH = "$HOME/.nix-defexpr/channels";
          };
          home.packages = [
            pkgs.wget
            pkgs.file
            pkgs.gnupg
            pkgs.htop
            pkgs.xz

            #pkgs.gcc12
            pkgs.clang_16

            pkgs.mold
            pkgs.gnumake
            pkgs.openssl
            pkgs.pkg-config
            pkgs.libiconv
            pkgs.zlib

            pkgs.tio # serial device I/O tool

            pkgs.alejandra # nix formatter or pkgs.nixpkgs-fmt
            pkgs.ast-grep
            pkgs.bandwhich
            pkgs.bun
            pkgs.erdtree
            pkgs.fd # fzf's default command
            pkgs.gping
            pkgs.git-interactive-rebase-tool # git's sequence editor
            pkgs.grex
            pkgs.hexyl
            pkgs.hyperfine
            pkgs.hurl
            pkgs.jless
            pkgs.jql
            pkgs.ouch
            pkgs.onefetch
            pkgs.pastel
            pkgs.procs
            pkgs.rage
            pkgs.ripgrep
            pkgs.sd
            pkgs.tailspin # CLI name: spin
            pkgs.taplo
            pkgs.typos
            pkgs.yazi # Images Preview needs in host
            pkgs.rustscan

            pkgs.tree-sitter

            pkgs.nodejs_20 # LTS

            pkgs.rustup
          ];

          programs.home-manager.enable = true;

          imports = [
            ../programs/bat
            ../programs/eza.nix
            ../programs/git.nix
            ../programs/fzf.nix

            ../programs/zellij

            ../programs/starship.nix
          ];

          programs.neovim = {
            enable = true;
          };

          programs.atuin = {
            enable = true;
          };

          programs.zoxide = {
            enable = true;
          };

          programs.fish = {
            enable = true;
            shellInit = ''
              set fish_greeting
            '';
          };
        };
      })
    ];
  }
