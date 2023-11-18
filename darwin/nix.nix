{
  lib,
  pkgs,
  ...
}: {
  # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    configureBuildUsers = true;

    # Flakes settings
    package = pkgs.nix;
    # registry.nixpkgs.flake = nixpkgs;

    settings = {
      # Automate `nix store --optimise`
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;

      # Binary caches
      substituters = [
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        # todo
        # https://garnix.io
        # https://cachix.org
      ];
      trusted-public-keys = [
        # todo
        # garnix's key
        # cachix's key
      ];

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") ["aarch64-darwin" "x86_64-darwin"];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };
}
