class Camera {
  Vec eye;    // カメラ座標
  Vec origin; // 画面左上端方向のベクトル
  Vec xAxis;  // カメラ右方向
  Vec yAxis;  // カメラ上方向
  float lensRadius; // レンズ半径
  Vec imagePlane;

  void lookAt(Vec eye, Vec target, Vec up, float fov, int width, int height) {
    this.eye = eye;
    float imagePlane = (width * 0.5) / tan(fov * 0.5);
    Vec v = target.sub(eye).normalize();
    xAxis = v.cross(up).normalize();
    yAxis = v.cross(xAxis);
    Vec centerDir = v.scale(imagePlane);
    origin = centerDir.sub(xAxis.scale(0.5 * width)).sub(yAxis.scale(0.5 * height));
  }
  // 焦点距離を元にimagePlaneを決定する
  void lookAt(Vec eye, Vec target, Vec up, float fov, float focalDistance, float lensRadius, float aspect) {
    this.eye = eye;
    float halfWidth = focalDistance * tan(fov * 0.5);
    imagePlane = new Vec(halfWidth * 2, halfWidth * 2 / aspect, 0.0);
    this.lensRadius = lensRadius;
    Vec v = target.sub(eye).normalize();
    xAxis = v.cross(up).normalize();
    yAxis = v.cross(xAxis);
    Vec centerDir = v.scale(focalDistance);
    origin = centerDir.sub(xAxis.scale(halfWidth)).sub(yAxis.scale(halfWidth / aspect));
  }

  Ray getRay(float x, float y) {
    Vec viewPoint = origin.add(xAxis.scale(x / width * imagePlane.x)).add(yAxis.scale(y / width * imagePlane.y));
    Vec offset = new Vec(0);
    // lensRadiusが0以上なら被写界深度を考慮
    if(lensRadius > 0.0) {
      Vec rand = getRandomPointInDisk().scale(lensRadius);
      offset = offset.add(xAxis.scale(rand.x)).add(yAxis.scale(rand.y));
    }
    Vec dir = viewPoint.sub(offset).normalize();
    return new Ray(eye.add(offset), dir);
  }

  Vec getRandomPointInDisk() {
    Vec p = new Vec(1.0, 1.0, 0.0);
    while(true) {
      p.x = random(-1.0, 1.0);
      p.y = random(-1.0, 1.0);
      if(p.dot(p) < 1) { break; }
    }
    return p;
  }
}