final int SAMPLE_NUM = 400;
final Spectrum SKY_COLOR = new Spectrum(0.7);
Scene scene = new Scene(); // シーン
Camera camera = new Camera();

void setup() {
  size(256, 256);
  initScene();
  initCamera();
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
    new Vec(-2.25, 0, 0), 1, new Material(new Spectrum(0.9, 0.1, 0.5))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(0, 0, 0),  1, new Material(new Spectrum(0.1, 0.9, 0.5))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(2.25, 0, 0),  1, new Material(new Spectrum(0.1, 0.5, 0.9))
  ));

  // 無限平面
  scene.addIntersectable(new CheckedObj(
    new Plane(
      new Vec(0, -1, 0), // 位置
      new Vec(0, 1, 0), // 向き
      new Material(new Spectrum(0.8)) // 材質
    ),
    2,
    new Material(new Spectrum(0.2))
  ));
}

void initCamera() {
  camera.lookAt(
    new Vec(4.0, 1.5, 6.0),  // 視点
    new Vec(0.0),            // 注視点
    new Vec(0.0, 1.0, 0.0),  // 上方向
    radians(60.0),           // 視野角
    width,
    height
  );
}

// 一次レイを計算
Ray getPrimaryRay(int x, int y) {
  return camera.getRay(
    x + random(-0.5, 0.5),
    y + random(-0.5, 0.5)
  );
}

// ピクセルの色を計算
color calcPixelColor(int x, int y) {
  Spectrum sum = BLACK;

  for(int i = 0; i < SAMPLE_NUM; i++) {
    Ray ray = getPrimaryRay(x, y);
    sum = sum.add(scene.trace(ray, 0));
  }
  return sum.scale(1.0 / SAMPLE_NUM).toColor();
}
