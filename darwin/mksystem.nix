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
  rustChannel = "nightly"; # stable | beta | nightly
in
  darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {inherit inputs vars;};
    modules = [
      ./configuration.nix
      ./nix.nix
      (import ./nixpkgs.nix {inherit overlays;})
      home-manager.darwinModules.home-manager
      ({pkgs, ...} @ args: let
        isDarwin = pkgs.stdenv.isDarwin;
        isx86_64 = pkgs.stdenv.hostPlatform.isx86_64;
        SDKROOT = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk";
      in {
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

            PNPM_HOME = "$HOME/.local/share/pnpm";
            ELECTRON_MIRROR = "https://npmmirror.com/mirrors/electron/";

            # `xcrun --show-sdk-path`
            inherit SDKROOT;
            # CC = "clang";
            # CXX = "clang++";
            # CFLAGS = "-Wno-undef-prefix";
            CPATH = "${SDKROOT}/usr/include";

            LIBRARY_PATH = lib.makeLibraryPath [
              pkgs.libiconv
              pkgs.openssl
            ];

            # LLVM_CONFIG_PATH = "${pkgs.llvm}/bin/llvm-config";
            # LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib];
            # LDFLAGS="-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib";
            # NIX_LDFLAGS = ''${lib.concatStringsSep " " [
            #     "-F${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation"
            #     "-F${pkgs.darwin.apple_sdk.frameworks.CoreServices}/Library/Frameworks -framework CoreServices"
            #     "-F${pkgs.darwin.apple_sdk.frameworks.Security}/Library/Frameworks -framework Security"
            #   ]}'';
          };
          home.packages = [
            pkgs.wget
            pkgs.file
            pkgs.gnupg
            pkgs.htop
            pkgs.xz

            #pkgs.gcc12
            # pkgs.clang_16
            # pkgs.llvm_16.dev
            # pkgs.llvm_16 # without llvm-config

            pkgs.mold
            pkgs.gnumake
            pkgs.openssl
            pkgs.pkg-config
            pkgs.libiconv
            pkgs.zlib
            pkgs.ninja

            pkgs.alejandra # nix formatter or pkgs.nixpkgs-fmt
            pkgs.bun
            pkgs.hexyl
            pkgs.hyperfine
            pkgs.ouch
            pkgs.onefetch
            pkgs.pastel
            pkgs.procs
            pkgs.rage
            pkgs.tailspin # CLI name: spin
            pkgs.taplo
            pkgs.typos

            ## Git
            pkgs.gh
            pkgs.git-interactive-rebase-tool # git's sequence editor
            pkgs.git-cliff

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
            # pkgs.ast-grep
            pkgs.fd # fzf's default command
            pkgs.sd

            ## JSON/YAML
            pkgs.jless
            pkgs.jql

            ## Editor
            pkgs.neovim
            pkgs.tree-sitter

            ## Programmings

            ### Shell
            pkgs.shfmt

            ### Lua
            # pkgs.lua-language-server
            pkgs.stylua

            ### Node LTS
            pkgs.nodejs_20
            (pkgs.yarn.override {
              nodejs = pkgs.nodejs_20;
            })

            ### Rust
            # pkgs.rustup
            pkgs.sccache

            ### Overlays
            # pkgs.neovim-nightly
            # rust-bin.nightly.latest.default
            (pkgs.rust-bin.${rustChannel}.latest.default.override {
              targets =
                ["wasm32-unknown-unknown"]
                ++ [
                  (
                    lib.concatStringsSep "-" [
                      "${arch}"
                      (
                        if isDarwin
                        then "apple-darwin"
                        else "unknown-linux-gnu"
                      )
                    ]
                  )
                ];
              # https://rust-lang.github.io/rustup-components-history/x86_64-apple-darwin.html
              # https://rust-lang.github.io/rustup-components-history/aarch64-apple-darwin.html
              extensions =
                ["rust-analyzer" "rust-src" "rust-std"]
                ++ lib.optionals (isx86_64 && rustChannel == "nightly") ["rustc-codegen-cranelift"];
            })
            pkgs.zigpkgs.master
          ];
          # ++ lib.optionals isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
          #   # AppKit
          #   Foundation
          #   CoreFoundation
          #   CoreServices
          #   # IOKit
          #   # Security
          #   # System
          # ]);

          programs.home-manager.enable = true;

          imports = [
            ../programs/bat
            ../programs/eza.nix
            (import ../programs/git.nix (args // vars))
            ../programs/fzf.nix

            ../programs/zellij

            ../programs/starship.nix
          ];

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

              set -gxp PATH $HOME/.npm-global/bin
              set -gxp PATH $HOME/.cargo/bin
              set -gxp PATH $HOME/.bin
            '';
            shellAbbrs = {
              cargo-login = "cargo login --registry crates-io";
              cargo-publish = "cargo publish --registry crates-io";
            };
          };
        };
      })
    ];
  }
