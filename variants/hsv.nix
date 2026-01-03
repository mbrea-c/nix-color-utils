args@{ ... }:
let
  util = (import ../util.nix) args;
in
{
  darken =
    ratio:
    {
      h,
      s,
      v,
    }:
    let
      ratio' = 1.0 - ratio;
    in
    {
      h = h;
      s = s;
      v = v * ratio';
    };
  lighten =
    ratio:
    {
      h,
      s,
      v,
    }:
    let
      ratio' = 1.0 - ratio;
    in
    {
      h = h;
      s = s;
      v = 1.0 - ratio' * (1.0 - v);
    };
  desaturate =
    ratio:
    {
      h,
      s,
      v,
    }:
    let
      ratio' = 1.0 - ratio;
    in
    {
      h = h;
      s = s * ratio';
      v = v;
    };
  saturate =
    ratio:
    {
      h,
      s,
      v,
    }:
    let
      ratio' = 1.0 - ratio;
    in
    {
      h = h;
      s = 1.0 - ratio' * (1.0 - s);
      v = v;
    };

  # TODO: Fix when mixing around the boundary
  mix =
    ratio: left: right:
    let
      maxHue = util.listMax [
        left.h
        right.h
      ];
      minHue = util.listMin [
        left.h
        right.h
      ];
      newHue = left.h * (1.0 - ratio) + right.h * ratio;
      newHue' =
        if 360.0 + minHue - maxHue < maxHue - minHue then
          if left.h == minHue then
            (360.0 + left.h) * (1.0 - ratio) + right.h * ratio
          else
            left.h * (1.0 - ratio) + (360.0 + right.h) * ratio
        else
          newHue;
    in
    {
      h = newHue';
      s = left.s * (1.0 - ratio) + right.s * ratio;
      v = left.v * (1.0 - ratio) + right.v * ratio;
    };

  # highlight = colorscheme: ratio: color:
  #   if isDark colorscheme then lighten ratio color else darken ratio color;

  /*
    *
    Will produce a color with value of color a, but hue and saturation of color
    b.
  */
  matchValue = a: b: {
    h = b.h;
    s = b.s;
    v = a.v;
  };
}
