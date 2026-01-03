args@{ ... }:
let
  util = (import ./util.nix) args;
in
rec {
  inherit (util)
    listMax
    listMin
    ;
  hsv = (import ./hsv.nix) args;
  rgb = (import ./hsv.nix) args;
  color = (import ./color.nix) args;

  fromBase16 =
    { palette, ... }:
    rec {
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
  paletteFromNixColorsColorscheme =
    colorscheme:
    builtins.mapAttrs (_: hexrgbValue: color.makeHexrgb hexrgbValue) (fromBase16 colorscheme);
  compileNeovimColors = builtins.mapAttrs (
    _: highlights:
    builtins.mapAttrs (
      key: color: if key == "fg" || key == "bg" || key == "sp" then compileNeovimColor color else color
    ) highlights
  );
  compileNeovimColor = color: if color == builtins.null then builtins.null else color.hexstring color;

  compileGtkCss =
    { palette, ... }:
    ''
      @define-color foreground ${color.hexstring palette.foreground};
      @define-color background ${color.hexstring palette.background};

      @define-color color0  ${color.hexstring palette.color0};
      @define-color color1  ${color.hexstring palette.color1};
      @define-color color2  ${color.hexstring palette.color2};
      @define-color color3  ${color.hexstring palette.color3};
      @define-color color4  ${color.hexstring palette.color4};
      @define-color color5  ${color.hexstring palette.color5};
      @define-color color6  ${color.hexstring palette.color6};
      @define-color color7  ${color.hexstring palette.color7};
      @define-color color8  ${color.hexstring palette.color8};
      @define-color color9  ${color.hexstring palette.color9};
      @define-color color10 ${color.hexstring palette.color10};
      @define-color color11 ${color.hexstring palette.color11};
      @define-color color12 ${color.hexstring palette.color12};
      @define-color color13 ${color.hexstring palette.color13};
      @define-color color14 ${color.hexstring palette.color14};
      @define-color color15 ${color.hexstring palette.color15};
    '';
}
