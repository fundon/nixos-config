{ lib, inputs, nixpkgs, darwin, home-manager, vars, overlays, ... }:

let
  mySystem = import ./mksystem.nix {
    inherit lib inputs nixpkgs darwin home-manager vars overlays;
  };
in
{
  # Intel
  r2d2 = mySystem "x86_64";

  # M1
  c3po = mySystem "aarch64";
}
