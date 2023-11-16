{
  programs.git = {
    enable = true;

    userName = "Fangdun Tsai";
    userEmail = "cfddream@gmail.com";
    signing = "AA9908114E81F4B5";

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
    };
  };
}
