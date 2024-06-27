args@{ lib, ... }:
let util = (import ./util.nix) { inherit lib; };
in {
  inherit (util) listMax listMin mapColors fromBase16;
  hsv = (import ./hsv.nix) args;
  rgb = (import ./hsv.nix) args;
}
