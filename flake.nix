{
  description = "fundon's NixOS configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    # substituters = [ ];
    #extra-platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };

  inputs = {
    # `nixos-23.11` | `nixos-unstable` | `nixos-unstable-small`
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    # `release-23.11` | `main`
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix = {
    #   url = "github:mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    ## Hardware
    # nixos-hardware.url = "github:nixos/nixos-hardware";

    ## macOS - Darwin
    #nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Windows - WSL
    #wsl = {
    #  url = "github:nix-community/NixOS-WSL";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # neovim-nightly-overlay = {
    #  url = "github:nix-community/neovim-nightly-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    home-manager,
    darwin,
    ...
  }: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = with inputs; [
      # neovim-nightly-overlay.overlay
      # rust-overlay.overlays.default
      zig-overlay.overlays.default
    ];

    user = "fundon";
    vars = {
      inherit user;
      editor = "nvim";
      shell = "fish";
      email = "${user}@pindash.io";
      key = "C4E964E8E5E3A7BF";
      fullName = "Fangdun Tsai";
    };
  in
    {
      # Darwin Configurations
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            home-manager
            darwin
            vars
            overlays
            ;
        }
      );
    }
    // flake-utils.lib.eachDefaultSystem (system: rec {
      # packages = {
      #   pkgs = nixpkgs.legacyPackages.${system};
      # };
      #
      # checks = packages;

      devShells.default = with nixpkgs.legacyPackages.${system};
        mkShellNoCC {
          packages = [cowsay];
        };
    });
}
