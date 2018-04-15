class CheckedObj implements Intersectable {
  Intersectable obj;  // 物体の形状と材質1
  float gridWidth;    // グリッド幅
  Material material2; // 材質2

  CheckedObj(Intersectable obj, float gridWidth, Material material2) {
    this.obj = obj;
    this.gridWidth = gridWidth;
    this.material2 = material2;
  }

  Intersection intersect(Ray ray) {
    Intersection isect = obj.intersect(ray);
    if(isect.hit()) {
      Vec p = isect.point;
      int i = (
        round(p.x / this.gridWidth) + 
        round(p.y / this.gridWidth) + 
        round(p.z / this.gridWidth)
      );
      if(i % 2 == 0) {
        isect.material = this.material2;
      }
    }
    return isect;
  }
}