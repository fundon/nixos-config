{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 1000;
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
        vicmd_symbol = "[V](bold green)";
      };
      package = {
        disabled = true;
      };
      cmake = {
        symbol = "∆ ";
      };
    };
  };
}
