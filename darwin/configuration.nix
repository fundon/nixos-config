{
  config,
  pkgs,
  lib,
  vars,
  ...
}: {
  # Set `LANG`
  # i18n.defaultLocale = "en_US.UTF-8";

  # Set time zone
  # time.timeZone = "Asia/Hong_Kong";

  services = {
    # Auto upgrade daemon
    nix-daemon.enable = true;
  };

  environment = with pkgs; {
    # systemPackages = [fish];
    shells = [bashInteractive fish zsh];
    # loginShell = fish;
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
