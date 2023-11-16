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
        editor = pkgs.git-interactive-rebase-tool;
      };
    };
  };
}
