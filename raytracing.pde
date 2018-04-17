import java.util.Date;
final int SAMPLE_NUM = 1000;
final int DOF_NUM = 8;
final Spectrum SKY_COLOR = new Spectrum(0.0, 0.02, 0.25);
Scene scene = new Scene(); // シーン
Camera camera = new Camera();

int startTime;

void setup() {
  size(640, 360);
  initScene();
  initCamera();
  startTime = millis();
}

int y = 0;

void draw() {
  for (int x = 0; x < width; x ++) {
    color c = calcPixelColor(x, y);
    set(x, y, c);
  }
  y ++;
  int elapsedSec = (millis() - startTime) / 1000;
  float progress = ((float)y * width) / (width * height);
  int remainingSec = (int)(elapsedSec / progress * (1 - progress));
  println(String.format("%.4f %% Remaining: %dh %dm %ds", progress * 100, remainingSec / 3600, remainingSec / 60, remainingSec % 60));
  if (height <= y) {
    noLoop();
    Date c = new Date();
    save(String.format("render_%tY%tm%td%tH%tM.png", c, c, c, c, c));
  }
}

// シーン構築
void initScene() {
  // 球
  scene.addIntersectable(new Sphere(
    // 位置、半径、材質
    new Vec(-5, 0, -5), 1, new Material(new Spectrum(0.9, 0.1, 0.5))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(0, 0, 0),  1, new Material(new Spectrum(0.1, 0.5, 0.9), 0.2, 0.8, 1.5)
  ));
  scene.addIntersectable(new Sphere(
    new Vec(2.25, 0, 2.0),  1, new Material(new Spectrum(0.1, 0.9, 0.5), 0.8)
  ));
  scene.addIntersectable(new Sphere(
    new Vec(2.5, 0, -15),  1, new Material(new Spectrum(0.1, 0.1, 0.1), 0.8)
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

  // 光源
  scene.addIntersectable(new Sphere(
    new Vec(0.0, 4.0, 0.0), 1, new Material(new Spectrum(0), new Spectrum(0.5, 3, 2))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(-1.5, -0.9, 0.0), 0.2, new Material(new Spectrum(0), new Spectrum(30, 20, 10))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(2.0, -0.9,-3.5), 0.2, new Material(new Spectrum(0), new Spectrum(30, 20, 10))
  ));
  scene.addIntersectable(new Sphere(
    new Vec(0.5, -0.95, 0.5), 0.1, new Material(new Spectrum(0), new Spectrum(30, 20, 10))
  ));
  for(int i = 0; i < 30; i++) {
    scene.addIntersectable(new Sphere(
      new Vec(random(-3.0, 3.0), random(-0.9, 2.0), random(2.0, -15.0)), random(0.001, 0.1), new Material(new Spectrum(0), new Spectrum(30, 20, 10).scale(random(0.1, 1.5)))
    ));
  }
}

void initCamera() {
  camera.lookAt(
    new Vec(0.5, 2.0, 6.0),  // 視点
    new Vec(0.0,-1.5, 0.0),  // 注視点
    new Vec(0.0, 1.0, 0.0),  // 上方向
    radians(60.0),           // 視野角
    6.0,                     // 焦点距離
    0.1,                     // レンズ半径
    width / height           // アスペクト比
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
  Spectrum dofsum = BLACK;
  for(int j = 0; j < DOF_NUM; j++) {
    Spectrum sum = BLACK;
    for(int i = 0; i < SAMPLE_NUM; i++) {
      Ray ray = getPrimaryRay(x, y);
      sum = sum.add(scene.trace(ray, 0));
    }
    dofsum = dofsum.add(sum.scale(1.0 / SAMPLE_NUM));
    if(camera.lensRadius == 0) {
      dofsum = dofsum.scale(DOF_NUM);
      break;
    }
  }
  return dofsum.scale(1.0 / DOF_NUM).toColor();
}
