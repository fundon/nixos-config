# https://github.com/nix-community/home-manager/blob/master/modules/programs/bat.nix
{pkgs, ...}: {
  programs.bat = {
    enable = true;
    theme = "rose-pine-dawn";
    themes = {
      rose-pine-dawn = {
        src = "${builtins.toString ./themes/rose-pine-dawn.sublime-color-scheme}";
      };
    };
  };
}
