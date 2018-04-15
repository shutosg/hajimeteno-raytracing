class Vec {
  // メンバ変数
  float x, y, z;

  // コンストラクタ
  Vec(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vec(float v) {
    this.x = v;
    this.y = v;
    this.z = v;
  }

  // ベクトル同士の加算
  Vec add(Vec v) {
    return new Vec(this.x + v.x, this.y + v.y, this.z + v.z);
  }

  // ベクトル同士の減算
  Vec sub(Vec v) {
    return new Vec(this.x - v.x, this.y - v.y, this.z - v.z);
  }

  // ベクトルの定数倍
  Vec scale(float s) {
    return new Vec(this.x * s, this.y * s, this.z * s);
  }

  // 逆向きのベクトルを返す
  Vec neg() {
    return new Vec(-this.x, -this.y, -this.z);
  }

  // ベクトルの長さを返す
  float len() {
    return sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  }

  // 正規化（単位ベクトル化）したベクトルを返す
  Vec normalize() {
    return scale(1.0 / len());
  }

  // 内積
  float dot(Vec v) {
    return this.x * v.x + this.y * v.y + this.z * v.z;
  }

  // 外積
  Vec cross(Vec v) {
    return new Vec(this.y * v.z - v.y * this.z,
                   this.z * v.x - v.z * this.x,
                   this.x * v.y - v.x * this.y);
  }

  // ベクトルを文字列として返す
  String toString() {
    return "Vec(" + this.x + ", " + this.y + ", " + this.z + ")";
  }

  // 法線を元に反射ベクトルを計算して返す
  Vec reflect(Vec n) {
    return this.sub(n.scale(2 * this.dot(n)));
  }

  // 法線と2つの媒質の屈折率の比を元に屈折ベクトルを計算して返す
  // 参考: http://t-pot.com/program/96_RayTraceReflect/index.html
  Vec refract(Vec n, float eta) {
    float dot = this.dot(n);
    float d = 1.0 - sq(eta) * (1.0 - sq(dot));
    if(d > 0) {
      Vec a = this.sub(n.scale(dot)).scale(eta);
      Vec b = n.scale(sqrt(d));
      return a.sub(b);
    }
    // 全反射
    return this.reflect(n);
  }

  // ランダムな反射単位ベクトルを求める
  Vec randomHemisphere() {
    Vec dir = new Vec(0);
    while(true) {
      dir.x = random(-1.0, 1.0);
      dir.y = random(-1.0, 1.0);
      dir.z = random(-1.0, 1.0);
      if(dir.len() < 1.0) { break; }
    }
    dir = dir.normalize();

    // 法線方向と同じ方向に揃える
    if(dir.dot(this) < 0) { dir = dir.neg(); }

    return dir;
  }
}