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
      {nixpkgs.overlays = overlays;}
      home-manager.darwinModules.home-manager
      ({pkgs, ...}: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.fundon = {
          home.stateVersion = "23.05";
          home.sessionVariables = {
            LANG = "en_US.UTF-8";
            EDITOR = "${vars.editor}";
            PAGER = "less -FirSwX";
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
            pkgs.jql
            pkgs.ouch
            pkgs.onefetch
            pkgs.pastel
            pkgs.procs
            #pkgs.rage
            pkgs.ripgrep
            pkgs.sd
            pkgs.tailspin # CLI name: spin
            pkgs.taplo
            pkgs.typos
            ##pkgs.yazi # Images Preview needs in host
            #pkgs.rustscan

            #pkgs.tree-sitter

            pkgs.rustup
          ];

          # https://github.com/nix-community/home-manager/issues/3854#issuecomment-1610260754
          # home.file.".config/zellij/themes" = {
          #   recursive = true;
          #   source = "/.config/nix/programs/zellij/themes";
          # };

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

              # Nix
              if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
                source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
              end
              set -gxa PATH /etc/profiles/per-user/fundon/bin
              # End Nix
            '';
          };
        };
      })
    ];
  }
