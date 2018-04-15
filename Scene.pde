class Scene {
  final int MAX_TRACE_DEPTH = 64;
  final float VACUUM_REFRACTIVE_INDEX = 1.0; // 真空の屈折率
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lightList = new ArrayList<Light>();

  Scene() {}

  //==========================================================
  // オブジェクトの追加
  void addIntersectable(Intersectable obj) {
    this.objList.add(obj);
  }

  //==========================================================
  // ライトの追加
  void addLight(Light light) {
    this.lightList.add(light);
  }

  //==========================================================
  // レイを打って色を求める
  Spectrum trace(Ray ray, int traceDepth) {
    if(traceDepth > MAX_TRACE_DEPTH) { return BLACK; }

    // 交点
    Intersection isect = findNearestIntersection(ray);
    // 何もヒットしてないなら終わり
    if(!isect.hit()) { return BLACK; }

    Material m = isect.material;
    Spectrum col = BLACK; // 最終的な計算結果

    // 鏡面反射
    float ks = m.reflective;
    if(ks > 0) {
      Vec r = ray.dir.reflect(isect.normal);
      Spectrum c = trace(new Ray(isect.point, r, true), traceDepth + 1);   // 反射レイを飛ばした結果の色
      col = col.add(c.scale(ks).mul(m.diffuse)); // 鏡面反射成分色を足す
    }
    // 屈折
    float kt = m.refractive;
    if(kt > 0) {
      Vec r = (isect.normal.dot(ray.dir) < 0) ? 
        ray.dir.refract(isect.normal, VACUUM_REFRACTIVE_INDEX / m.refractiveIndex) : 
        ray.dir.refract(isect.normal.neg(), m.refractiveIndex / VACUUM_REFRACTIVE_INDEX);
      Spectrum c = trace(new Ray(isect.point, r, true), traceDepth + 1);
      col = col.add(c.scale(kt).mul(m.diffuse));
    }
    // 拡散反射
    float kd = 1.0 - ks - kt;
    if(kd > 0) {
      Spectrum c = this.lighting(isect.point, isect.normal, isect.material);
      col = col.add(c.scale(kd));
    }

    return col;
  }

  //==========================================================
  // 最も近いobjとのIntersectionを返す
  Intersection findNearestIntersection(Ray ray) {
    Intersection isect = new Intersection();
    for(int i = 0; i < this.objList.size(); i++) {
      Intersectable obj = this.objList.get(i);
      Intersection tmpIsect = obj.intersect(ray);
      if(tmpIsect.t < isect.t) { isect = tmpIsect; }
    }
    return isect;
  }

  //==========================================================
  // 複数のライトを考慮して特定の座標の色を返す
  Spectrum lighting(Vec p, Vec n, Material m) {
    Spectrum L = BLACK;
    for(int i = 0; i < this.lightList.size(); i++) {
      Light light = this.lightList.get(i);
      Spectrum col = diffuseLighting(p, n, m.diffuse, light.pos, light.power);
      L = L.add(col);
    }
    return L;
  }

  //==========================================================
  // 拡散反射ライティング
  // p: 交点, n: 交点の法線
  Spectrum diffuseLighting(Vec p, Vec n, Spectrum diffuseColor, Vec lightPos, Spectrum lightPower) {
    // 交点から光源へのベクトル
    Vec v = lightPos.sub(p);
    Vec l = v.normalize();
    float dot = n.dot(l);
    // 面が光源を向いてる
    if(dot > 0 && visible(p, lightPos)) {
      float r = v.len();
      float factor = dot / (4 * PI * r * r);
      return lightPower.scale(factor).mul(diffuseColor);
    }
    // 面が光源を向いてない
    return BLACK;
  }

  //==========================================================
  // pointからtargetが見える(遮蔽物が無い)か調べる
  boolean visible(Vec point, Vec target) {
    Vec v = target.sub(point);
    Vec l = v.normalize();
    Ray shadowRay = new Ray(point, l, true);
    for(int i = 0; i < objList.size(); i++) {
      // 一つでも遮蔽物があったらfalseを返す
      if(this.objList.get(i).intersect(shadowRay).t < v.len()) { return false; }
    }
    return true;
  }
}