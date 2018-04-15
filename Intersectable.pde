interface Intersectable {
  // レイとの交点情報を返す
  Intersection intersect(Ray ray);
}