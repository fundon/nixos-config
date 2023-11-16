{
  description = "fundon's NixOS configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    #extra-platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };

  inputs = {
    # `nixos-23.05` | `nixos-unstable` | `nixos-unstable-small`
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    # `release-23.05` | `main`
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

    #neovim-nightly-overlay = {
    #  url = "github:nix-community/neovim-nightly-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #rust-overlay = {
    #  url = "github:oxalica/rust-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #zig-overlay = {
    #  url = "github:mitchellh/zig-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = inputs @ { nixpkgs, flake-utils, home-manager, darwin, ... }:
    let
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        #  inputs.neovim-nightly-overlay.overlay
        #  inputs.rust-overlay.overlays.default
        #  inputs.zig-overlay.overlays.default
      ];

      vars = {
        editor = "nvim";
        shell = "fish";
        user = "fundon";
      };
    in
    {
      # Darwin Configurations
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager darwin vars overlays;
        }
      );
    };
}
