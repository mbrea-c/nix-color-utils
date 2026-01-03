{ ... }:
{
  mix = ratio: left: right: {
    r = builtins.floor ((1.0 - ratio) * left.r + ratio * right.r);
    g = builtins.floor ((1.0 - ratio) * left.g + ratio * right.g);
    b = builtins.floor ((1.0 - ratio) * left.b + ratio * right.b);
  };
}
