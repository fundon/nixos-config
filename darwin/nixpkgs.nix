{overlays ? []}: {
  nixpkgs = {
    overlays = overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
