{ config, pkgs, lib, vars, ... }:

{
  nix = {
    package = pkgs.nix;
    # Garbage Collection
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    configureBuildUsers = true;

    settings = {
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
      ];

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "aarch64-darwin" "x86_64-darwin" ];

      # Recommended when using `direnv` etc.
      keep-derivations = true;
      keep-outputs = true;
    };
  };

  services = {
    # Auto-Upgrade Daemon
    nix-daemon.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  environment = {
    systemPackages = [
      pkgs.fish
    ];

    shells = [ pkgs.bashInteractive pkgs.zsh pkgs.fish ];
    loginShell = pkgs.fish;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
    '';
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

  # MacOS User
  # https://github.com/nix-community/home-manager/issues/4026
  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.${vars.shell};
  };
}
