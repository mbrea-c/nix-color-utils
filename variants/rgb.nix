{ ... }:
{
  mix = ratio: left: right: {
    r = (1.0 - ratio) * left.r + ratio * right.r;
    g = (1.0 - ratio) * left.g + ratio * right.g;
    b = (1.0 - ratio) * left.b + ratio * right.b;
  };
}
