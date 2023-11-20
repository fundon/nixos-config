# https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
{
  pkgs,
  vars,
  ...
}: {
  programs.git = {
    enable = true;

    userName = vars.fullName;
    userEmail = vars.email;
    signing = {
      key = vars.key;
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = true;
      };
    };

    aliases = {
      graph = "log --graph --pretty=custom";

      # List the latest 20 commits
      l = "log -n 20 --graph --abbrev-commit --pretty=custom";

      # List contributors
      lc = "shortlog --email --summary --numbered";
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      log = {
        date = "iso";
      };
      sequence = {
        editor = "${pkgs.git-interactive-rebase-tool}/bin/git-interactive-rebase-tool";
      };
      pretty = {
        custom = "%C(magenta)%h%C(red)%d %C(yellow)%ar %C(green)%s %C(yellow)(%an)";
        #                     │        │            │            │             └─ author name
        #                     │        │            │            └─ message
        #                     │        │            └─ date (relative)
        #                     │        └─ decorations (branch, heads or tags)
        #                     └─ hash (abbreviated)
      };
    };
  };
}
