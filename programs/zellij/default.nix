{...}: {
  programs.zellij = {
    enable = true;
    settings = {
      theme = "rose-pine-dawn";
      themes.rose-pine-dawn = {
        bg = "#faf4ed";
        fg = "#575279";
        red = "#b4637a";
        green = "#286983";
        blue = "#56949f";
        yellow = "#ea9d34";
        magenta = "#907aa9";
        orange = "#fe640b";
        cyan = "#d7827e";
        black = "#f2e9e1";
        white = "#575279";
      };
    };
  };
}
