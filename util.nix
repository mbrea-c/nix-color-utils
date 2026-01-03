{ lib, ... }:
{

  # Converts a float in [0,1] range to integer in [0,255] range
  floatToByte = float: builtins.floor (float * 255 + 0.5);
  # Converts an integer in [0,255] range to float in [0,1] range
  byteToFloat = byte: byte / 255.;
  byteToHex =
    dec:
    let
      dHigh = dec / 16;
      dLow = lib.mod dec 16;
      intToHex = [
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "a"
        "b"
        "c"
        "d"
        "e"
        "f"
      ];
    in
    "${builtins.elemAt intToHex dHigh}${builtins.elemAt intToHex dLow}";

  listMax = list: builtins.foldl' (a: b: if a > b then a else b) (builtins.elemAt list 0) list;
  listMin = list: builtins.foldl' (a: b: if a < b then a else b) (builtins.elemAt list 0) list;
}
