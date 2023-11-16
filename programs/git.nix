{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Fangdun Tsai";
    userEmail = "cfddream@gmail.com";
    signing = {
      key = "AA9908114E81F4B5";
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = true;
      };
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
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
      aliases = {
        graph = "log --graph --pretty=custom";

        # List the latest 20 commits
        l = "log -n 20 --graph --abbrev-commit --pretty=custom";

        # List contributors
        lc = "shortlog --email --summary --numbered";
      };
    };
  };
}
