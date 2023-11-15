{ lib, inputs, nixpkgs, darwin, home-manager, vars, overlays, ... }:

arch:

let
  system = "${arch}-darwin";
in
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs vars; };
  modules = [
    ./configuration.nix
    { nixpkgs.overlays = overlays; }
    home-manager.darwinModules.home-manager
    ({ pkgs, ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.fundon = {
        home.stateVersion = "23.05";
        home.sessionVariables = {
          LANG = "en_US.UTF-8";
          LC_CTYPE = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          EDITOR = "${vars.editor}";
          PAGER = "less -FirSwX";
        };
        home.packages = [
          pkgs.git
          pkgs.wget
          pkgs.file
          pkgs.gnupg
          pkgs.htop
          pkgs.xz

          pkgs.clang_16
          pkgs.mold
          pkgs.gnumake
          pkgs.openssl
          pkgs.pkg-config
          pkgs.libiconv
          pkgs.zlib

          pkgs.ast-grep
          pkgs.bat
          pkgs.bandwhich
          pkgs.bun
          pkgs.delta
          pkgs.erdtree
          pkgs.eza
          pkgs.fd
          pkgs.gping
          pkgs.git-interactive-rebase-tool
          pkgs.grex
          pkgs.hexyl
          pkgs.hyperfine
          pkgs.hurl
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
          pkgs.xh
          pkgs.yazi # Images Preview needs in host
          pkgs.rustscan
          pkgs.nixpkgs-fmt

          pkgs.tree-sitter
          pkgs.neovim

          pkgs.rustup
        ];

        programs.home-manager.enable = true;

        programs.fzf = {
          enable = true;
        };

	programs.zellij = {
          enable = true;
	};

        programs.atuin = {
          enable = true;
        };

        programs.zoxide = {
          enable = true;
        };

        programs.starship = {
          enable = true;
          settings = {
            add_newline = false;
            command_timeout = 1000;
            character = {
              success_symbol = "[λ](bold green)";
              error_symbol = "[λ](bold red)";
              vicmd_symbol = "[V](bold green)";
            };
            package = {
              disabled = true;
            };
            cmake = {
              symbol = "∆ ";
            };
          };
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
