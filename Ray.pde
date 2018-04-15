class Ray {
  final float EPSILON = 0.001;
  Vec origin; // 射出点
  Vec dir;    // 正規化済みの方向ベクトル

  Ray(Vec origin, Vec dir) {
    this.origin = origin;
    this.dir = dir;
  }
  
  Ray(Vec origin, Vec dir, boolean isAdvanceRay) {
    this.origin = origin;
    this.dir = dir;
    if(isAdvanceRay) {
      // 交点がめり込む誤差回避のために予め少しだけ進めておく
      this.origin = origin.add(this.dir.scale(EPSILON));
    }
  }
}