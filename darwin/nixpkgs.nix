{overlays ? []}: let
  rustup_dist_server = builtins.getEnv "RUSTUP_DIST_SERVER";
in {
  nixpkgs = {
    overlays =
      overlays
      ++ [
        # https://github.com/oxalica/rust-overlay/pull/140
        (final: prev: {
          rust-bin =
            prev.rust-bin
            // {
              distRoot = "${
                if builtins.hasContext rustup_dist_server
                then rustup_dist_server
                else "https://rsproxy.cn"
              }/dist";
            };
        })
      ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
