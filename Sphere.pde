class Sphere implements Intersectable {
  Vec center;
  float radius;
  Material material;

  Sphere(Vec center, float radius, Material material) {
    this.center = center;
    this.radius = radius;
    this.material = material;
  }

  Intersection intersect(Ray ray) {
    Intersection isect = new Intersection();
    Vec v = ray.origin.sub(this.center);
    float b = ray.dir.dot(v);
    float c = v.dot(v) - sq(this.radius);

    // 交差判定の方程式の判別式
    float d = b * b - c;

    if (d >= 0) { // 交差した場合
      // 交点までの距離を計算する
      float s = sqrt(d);
      float t = -b - s;
      if (t <= 0) { t = -b + s; }
      if (0 < t) {
        isect.t = t;
        isect.point = ray.origin.add(ray.dir.scale(t));
        isect.normal = isect.point.sub(this.center).normalize();
        isect.material = this.material;
      }
    }
    return isect;
  }
}