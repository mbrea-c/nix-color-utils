{ lib, nix-colors, ... }:
let
  decToHex = dec:
    let
      dHigh = dec / 16;
      dLow = lib.mod dec 16;
      intToHex =
        [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];
    in "${builtins.elemAt intToHex dHigh}${builtins.elemAt intToHex dLow}";
in rec {
  # converts default nix-colors color (hex string such as "23F1AA") to the form
  # { r = 12; g = 255; b = 58 }.
  to = color:
    let
      rgb = nix-colors.lib.conversions.hexToRGB color;
      r = builtins.elemAt rgb 0;
      g = builtins.elemAt rgb 1;
      b = builtins.elemAt rgb 2;
    in { inherit r g b; };

  from = rgb:
    let
      r = decToHex rgb.r;
      g = decToHex rgb.g;
      b = decToHex rgb.b;
    in "${r}${g}${b}";

  mix = ratio: left: right:
    let
      leftRgb = to left;
      rightRgb = to right;
    in from {
      r = builtins.floor ((1. - ratio) * leftRgb.r + ratio * rightRgb.r);
      g = builtins.floor ((1. - ratio) * leftRgb.g + ratio * rightRgb.g);
      b = builtins.floor ((1. - ratio) * leftRgb.b + ratio * rightRgb.b);
    };
}
