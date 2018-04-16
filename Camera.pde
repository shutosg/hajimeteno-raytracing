class Camera {
  Vec eye;    // カメラ座標
  Vec origin; // 画面左上端方向のベクトル
  Vec xAxis;  // カメラ右方向
  Vec yAxis;  // カメラ上方向

  void lookAt(Vec eye, Vec target, Vec up, float fov, int width, int height) {
    this.eye = eye;
    float imagePlane = (width * 0.5) / tan(fov * 0.5);
    Vec v = target.sub(eye).normalize();
    xAxis = v.cross(up).normalize();
    yAxis = v.cross(xAxis);
    Vec centerDir = v.scale(imagePlane);
    origin = centerDir.sub(xAxis.scale(0.5 * width)).sub(yAxis.scale(0.5 * height));
  }

  Ray getRay(float x, float y) {
    Vec p = origin.add(xAxis.scale(x)).add(yAxis.scale(y));
    Vec dir = p.normalize();
    return new Ray(eye, dir);
  }
}