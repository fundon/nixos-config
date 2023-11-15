{ lib, inputs, nixpkgs, darwin, home-manager, vars, overlays, ... }:

let
  mkSystem = import ./mksystem.nix {
    inherit lib inputs nixpkgs darwin home-manager vars overlays;
  };
in
{
  # Intel
  r2d2 = mkSystem "x86_64";

  # M1
  c3po = mkSystem "aarch64";
}
