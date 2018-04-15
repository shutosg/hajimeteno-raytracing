// 交差情報
class Intersection {
  float t = NO_HIT; // レイからの交点距離
  Vec point;
  Vec normal;
  Material material;

  Intersection() {}

  boolean hit() { return this.t != NO_HIT; }
}

final float NO_HIT = Float.POSITIVE_INFINITY;