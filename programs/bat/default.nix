# https://github.com/nix-community/home-manager/blob/master/modules/programs/bat.nix
{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      theme = "Solarized (light)";
    };
    themes = {
      rose-pine = {
        src = "${builtins.toString ./themes}";
        file = "rose-pine.tmTheme";
      };
    };
  };
}
