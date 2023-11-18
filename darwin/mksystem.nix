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
            # https://github.com/NixOS/nix/issues/2982
            NIX_PATH = "$HOME/.nix-defexpr/channels";

            EDITOR = "${vars.editor}";
            PAGER = "less -FirSwX";

            GOPROXY = "https://goproxy.io,direct";

            RUSTUP_DIST_SERVER = "https://rsproxy.cn";
            RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";

            ELECTRON_MIRROR = "https://npmmirror.com/mirrors/electron/";
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

            pkgs.alejandra # nix formatter or pkgs.nixpkgs-fmt
            pkgs.ast-grep
            pkgs.bun
            pkgs.git-interactive-rebase-tool # git's sequence editor
            pkgs.hexyl
            pkgs.hyperfine
            pkgs.jless
            pkgs.jql
            pkgs.ouch
            pkgs.onefetch
            pkgs.pastel
            pkgs.procs
            pkgs.rage
            pkgs.tailspin # CLI name: spin
            pkgs.taplo
            pkgs.typos

            ## I/O Devices
            pkgs.tio

            ## Network
            pkgs.bandwhich
            pkgs.gping
            pkgs.rustscan
            pkgs.hurl

            ## Filesystem
            pkgs.erdtree
            pkgs.ripgrep
            pkgs.grex
            pkgs.yazi # Images Preview needs in host

            ## Search
            pkgs.fd # fzf's default command
            pkgs.sd

            pkgs.tree-sitter

            ## Programmings
            pkgs.nodejs_20 # Node LTS
            pkgs.rustup # Rust
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

              if isatty
                  set -x GPG_TTY (tty)
              end

              set -gx PNPM_HOME $HOME/.local/share/pnpm
              set -gxp PATH $HOME/.npm-global/bin
              set -gxp PATH $HOME/.cargo/bin
              set -gxp PATH $HOME/.bin
            '';
          };
        };
      })
    ];
  }
