args@{ lib, nix-colors, ... }:
let
  util = (import ./util.nix) args;
  hsv = (import ./variants/hsv.nix) args;
  rgb = (import ./variants/hsv.nix) args;
in
rec {
  # Constructors

  makeHsv = makeVariant "hsv";
  makeRgb = makeVariant "rgb";
  makeHexrgb = makeVariant "hexrgb";

  makeVariant = variant: value: { inherit variant value; };

  # Destructors
  extractValue = { value, ... }: value;

  # Other operations

  isDark = { palette, ... }: (ensureHsv palette.base00).value.v < 0.5;
  hsvMix =
    ratio: left: right:
    makeHsv (hsv.mix ratio ((ensureHsv |> extractValue) left) ((ensureHsv |> extractValue) right));
  hsvDarken = ratio: hsvOperation (hsv.darken ratio);
  hsvLighten = ratio: hsvOperation (hsv.lighten ratio);
  hsvDesaturate = ratio: hsvOperation (hsv.desaturate ratio);
  hsvSaturate = ratio: hsvOperation (hsv.saturate ratio);
  hsvMatchValue =
    a: b: makeHsv (hsv.matchValue ((ensureHsv |> extractValue) a) ((ensureHsv |> extractValue) b));

  hsvOperation = operation: ensureHsv |> extractValue |> operation |> makeHsv;

  rgbMix =
    ratio: left: right:
    makeRgb (rgb.mix ratio ((ensureRgb |> extractValue) left) ((ensureRgb |> extractValue) right));

  # Convenience methods
  hexstring = "#${ensureHexrgb |> extractValue}";

  # Conversion methods

  ensureHsv =
    color:
    if color.variant == "hsv" then
      color
    else
      (
        if color.variant == "rgb" then
          makeHsv (rgbToHsv color.value)
        else if color.variant == "hexrgb" then
          makeHsv (hexrgbToHsv color.value)
        else
          throw "invalid color variant: ${color.variant}"
      );
  ensureRgb =
    color:
    if color.variant == "rgb" then
      color
    else
      (
        if color.variant == "hsv" then
          makeRgb (hsvToRgb color.value)
        else if color.variant == "hexrgb" then
          makeRgb (hexrgbToRgb color.value)
        else
          throw "invalid color variant: ${color.variant}"
      );
  ensureHexrgb =
    color:
    if color.variant == "hexrgb" then
      color
    else
      (
        if color.variant == "hsv" then
          makeHexrgb (hsvToHexrgb color.value)
        else if color.variant == "rgb" then
          makeHexrgb (rgbToHexrgb color.value)
        else
          throw "invalid color variant: ${color.variant}"
      );

  rgbToHsv =
    {
      r,
      g,
      b,
    }:
    let
      max = util.listMax [
        r
        g
        b
      ];
      min = util.listMin [
        r
        g
        b
      ];
      d = max - min;
      v = max;
      s = if max > 0 then d / max else 0;
      h =
        (
          if max == 0 then
            0
          else if max == min then
            0
          else if max == r then
            (g - b) / d + (if g < b then 6 else 0)
          else if max == g then
            (b - r) / d + 2
          else
            (r - g) / d + 4
        )
        / 6;
    in
    {
      inherit h s v;
    };

  hsvToRgb =
    hsvValue:
    let
      i = builtins.floor (hsvValue.h * 6);
      f = hsvValue.h * 6 - i;
      p = hsvValue.v * (1 - hsvValue.s);
      q = hsvValue.v * (1 - f * hsvValue.s);
      t = hsvValue.v * (1 - (1 - f) * hsvValue.s);
      i' = lib.mod i 6; # Since we don't have a modulo operator
    in
    if i' == 0 then
      {
        r = hsvValue.v;
        g = t;
        b = p;
      }
    else if i' == 1 then
      {
        r = q;
        g = hsvValue.v;
        b = p;
      }
    else if i' == 2 then
      {
        r = p;
        g = hsvValue.v;
        b = t;
      }
    else if i' == 3 then
      {
        r = p;
        g = q;
        b = hsvValue.v;
      }
    else if i' == 4 then
      {
        r = t;
        g = p;
        b = hsvValue.v;
      }
    else
      {
        r = hsvValue.v;
        g = p;
        b = q;
      };
  hexrgbToRgb =
    hexrgbValue:
    let
      rgb = nix-colors.lib.conversions.hexToRGB hexrgbValue;
      r = util.byteToFloat (builtins.elemAt rgb 0);
      g = util.byteToFloat (builtins.elemAt rgb 1);
      b = util.byteToFloat (builtins.elemAt rgb 2);
    in
    {
      inherit r g b;
    };
  hexrgbToHsv = hexrgbToRgb |> rgbToHsv;

  rgbToHexrgb =
    rgbValue:
    let
      r = util.decToHex (util.floatToByte rgbValue.r);
      g = util.decToHex (util.floatToByte rgbValue.g);
      b = util.decToHex (util.floatToByte rgbValue.b);
    in
    "${r}${g}${b}";
  hsvToHexrgb = hsvToRgb |> rgbToHexrgb;
}
