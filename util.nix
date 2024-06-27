{ lib, ... }: {
  fromBase16 = { palette, ... }: rec {
    color0 = palette.base00;
    color1 = palette.base08;
    color2 = palette.base0B;
    color3 = palette.base0A;
    color4 = palette.base0D;
    color5 = palette.base0E;
    color6 = palette.base0C;
    color7 = palette.base05;
    color8 = palette.base03;
    color9 = palette.base08;
    color10 = palette.base0B;
    color11 = palette.base0A;
    color12 = palette.base0D;
    color13 = palette.base0E;
    color14 = palette.base0C;
    color15 = palette.base07;
    foreground = color7;
    background = color0;
    black = color0;
    red = color1;
    green = color2;
    yellow = color3;
    blue = color4;
    magenta = color5;
    cyan = color6;
    white = color7;
    brightBlack = color8;
  };

  listMax = list:
    lib.foldl (a: b: if a > b then a else b) (builtins.elemAt list 0) list;
  listMin = list:
    lib.foldl (a: b: if a < b then a else b) (builtins.elemAt list 0) list;

  mapColors = lib.attrsets.mapAttrs (_: hl:
    lib.attrsets.mapAttrs (key: value:
      if key == "fg" || key == "bg" || key == "sp" then
        "#${toString value}"
      else
        value) hl);
}
