final int SAMPLE_NUM = 2000;
final Spectrum SKY_COLOR = new Spectrum(0.7);
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
    new Vec(-2.25, 0, 0), 1, new Material(new Spectrum(0.9, 0.1, 0.5))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(0, 0, 0),  1, new Material(new Spectrum(0.1, 0.9, 0.5))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(2.25, 0, 0),  1, new Material(new Spectrum(0.1, 0.5, 0.9))
  ));

  // 無限平面
  scene.addIntersectable(new Plane(
      new Vec(0, -1, 0), // 位置
      new Vec(0, 1, 0), // 向き
      new Material(new Spectrum(0.9)) // 材質
    )
  );
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
  Spectrum sum = BLACK;

  for(int i = 0; i < SAMPLE_NUM; i++) {
    Ray ray = calcPrimaryRay(x, y);
    sum = sum.add(scene.trace(ray, 0));
  }
  return sum.scale(1.0 / SAMPLE_NUM).toColor();
}
