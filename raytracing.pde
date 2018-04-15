Scene scene = new Scene(); // シーン
Vec eye = new Vec(0, 0, 7); // 視点
Vec lookAt = new Vec(0, 0, 0); // 注視点
float eyeRotZ = 0;

void setup() {
  size(256, 256);
  initScene();
}

int y = 0;

void draw() {
  for (int x = 0; x < width; x ++) {
    color c = calcPixelColor(x, y);
    set(x, y, c);
  }

  y ++;
  if (height <= y) {
    noLoop();
    // save("test.png");
  }
}

// シーン構築
void initScene() {
  // 球
  scene.addIntersectable(new Sphere(
    // 位置、半径、材質
    new Vec(-2, 0, 0), 0.8, new Material(new Spectrum(0.9, 0.1, 0.5), 0.5)
  ));
  scene.addIntersectable(new Sphere(
    new Vec(0, 0, 0),  0.8, new Material(new Spectrum(0.1, 0.9, 0.5), 0.2, 0.8, 2.8)
  ));
  scene.addIntersectable(new CheckedObj(
    new Sphere(new Vec(2, 0, 0),  0.8, new Material(new Spectrum(0.1, 0.5, 0.9))),
    0.25,
    new Material(new Spectrum(0.1, 0.5, 0.9), 0.8)
  ));

  // チェック柄の床
  scene.addIntersectable(new CheckedObj(
    new Plane(
      new Vec(0, -0.8, 0), // 位置
      new Vec(0, 1, 0), // 向き
      new Material(new Spectrum(0.8)) // 材質
    ),
    1,
    new Material(new Spectrum(0.2), 0.8)
  ));
  // scene.addIntersectable(new CheckedObj(
  //   new Plane(
  //     new Vec(0, 0, -3), // 位置
  //     new Vec(0, -0.1, .9), // 向き
  //     new Material(new Spectrum(0.2, 0.2, 0.8)) // 材質
  //   ),
  //   0.5,
  //   new Material(new Spectrum(0.8, 0.2, 0.2), 0.8)
  // ));

  // 点光源
  scene.addLight(new Light(
    new Vec(100, 100, 100), // 位置
    new Spectrum(800000) // パワー（光源色）
  ));
  scene.addLight(new Light(
    new Vec(-3, 1, 3), // 位置
    new Spectrum(400) // パワー（光源色）
  ));
}

// 一次レイを計算
Ray calcPrimaryRay(int x, int y) {
  float imagePlane = height;

  float dx =   x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;

  return new Ray(
    eye, // 始点
    new Vec(dx, dy, dz).normalize() // 方向
  );
}

// ピクセルの色を計算
color calcPixelColor(int x, int y) {
  Ray ray = calcPrimaryRay(x, y);
  Spectrum l = scene.trace(ray, 0);
  return l.toColor();
}
