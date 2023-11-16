{
  config,
  pkgs,
  lib,
  vars,
  ...
}: {
  # Set time zone
  time.timeZone = "Asia/Hong_Kong";

  services = {
    # Auto upgrade daemon
    nix-daemon.enable = true;
  };

  environment = with pkgs; {
    shells = [bashInteractive fish zsh];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # MacOS User
  # https://github.com/nix-community/home-manager/issues/4026
  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.${vars.shell};
  };
}
