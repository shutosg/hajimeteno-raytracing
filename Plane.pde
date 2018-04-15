class Plane implements Intersectable {
  Vec normal;
  float distance; // 原点からの距離
  Material material;

  Plane(Vec normal, float distance, Material material) {
    this.normal = normal;
    this.distance = distance;
    this.material = material;
  }

  Plane(Vec p, Vec n, Material material) {
    this.normal = n.normalize();
    this.distance = -p.dot(this.normal);
    this.material = material;
  }

  Intersection intersect(Ray ray) {
    Intersection isect = new Intersection();
    float v = this.normal.dot(ray.dir);
    float t = -(this.normal.dot(ray.origin) + this.distance) / v;
    if(0 < t) {
      isect.t = t;
      isect.point = ray.origin.add(ray.dir.scale(t));
      isect.normal = this.normal;
      isect.material = this.material;
    }
    return isect;
  }
}