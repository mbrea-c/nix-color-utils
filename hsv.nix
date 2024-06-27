args@{ lib, ... }: let 
  rgb = (import ./rgb.nix) args;
  util = (import ./util.nix) args;
  HSVToRGB = hsv: 
    let 
      i = builtins.floor(hsv.h * 6);
      f = hsv.h * 6 - i;
      p = hsv.v * (1 - hsv.s);
      q = hsv.v * (1 - f * hsv.s);
      t = hsv.v * (1 - (1 - f) * hsv.s);
      i' = lib.mod i 6; # Since we don't have a modulo operator

      rgb = if i' == 0 then
          { r = hsv.v; g = t; b = p; }
        else if i' == 1 then
          { r = q; g = hsv.v; b = p; }
        else if i' == 2 then
          { r = p; g = hsv.v; b = t; }
        else if i' == 3 then
          { r = p; g = q; b = hsv.v; }
        else if i' == 4 then
          { r = t; g = p; b = hsv.v; }
        else
          { r = hsv.v; g = p; b = q; };
    in {
      r = builtins.floor(rgb.r * 255 + 0.5);
      g = builtins.floor(rgb.g * 255 + 0.5);
      b = builtins.floor(rgb.b * 255 + 0.5);
    };
in rec {
  to = color:
    let
      c = rgb.to color;
      r = c.r / 255.;
      g = c.g / 255.;
      b = c.b / 255.;
      max = util.listMax [ r g b ];
      min = util.listMin [ r g b ];
      d = max - min;
      v = max;
      s = if max > 0 then d / max else 0;
      h = (if max == 0 then 0 else
        if max == min then
          0
        else if max == r then
          (g - b) / d + (if g < b then 6 else 0)
        else if max == g then
          (b - r) / d + 2 
        else
          (r - g) / d + 4) 
        / 6;
    in { inherit h s v; };

  from = hsv: rgb.from (HSVToRGB hsv);

  darken = ratio: color:
    let
      hsv = to color;
      ratio' = 1. - ratio;
    in from {
      h = hsv.h;
      s = hsv.s;
      v = hsv.v * ratio';
    };
  lighten = ratio: color: 
    let
      hsv = to color;
      ratio' = 1. - ratio;
    in from {
        h = hsv.h;
        s = hsv.s;
        v = 1. - ratio' * (1. - hsv.v);
    };
  desaturate = ratio: color:
    let
      hsv = to color;
      ratio' = 1. - ratio;
    in from {
      h = hsv.h;
      s = hsv.s * ratio';
      v = hsv.v;
    };
  saturate = ratio: color:
    let
      hsv = to color;
      ratio' = 1. - ratio;
    in from {
      h = hsv.h;
      s = 1. - ratio' * (1. - hsv.s);
      v = hsv.v;
    };

  # TODO: Fix when mixing around the boundary
  mix = ratio: left: right:
    let
      leftHsv = to left;
      rightHsv = to right;
      maxHue = util.listMax [leftHsv.h rightHsv.h];
      minHue = util.listMin [leftHsv.h rightHsv.h];
      newHue = leftHsv.h * (1. - ratio) + rightHsv.h * ratio;
      newHue' = if 360. + minHue - maxHue < maxHue - minHue then
        if leftHsv.h == minHue then
          (360. + leftHsv.h) * (1. - ratio) + rightHsv.h * ratio
        else 
          leftHsv.h * (1. - ratio) + (360. + rightHsv.h) * ratio
        else newHue;
    in from {
      h = newHue';
      s = leftHsv.s * (1. - ratio) + rightHsv.s * ratio;
      v = leftHsv.v * (1. - ratio) + rightHsv.v * ratio;
    };

  isDark = { palette, ... }: (to palette.base00).v < 0.5;

  highlight = colorscheme: ratio: color:
    if isDark colorscheme then lighten ratio color else darken ratio color;
}
