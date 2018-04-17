import java.util.Date;
final int SAMPLE_NUM = 4000;
final Spectrum SKY_COLOR = new Spectrum(0.0, 0.02, 0.25);
Scene scene = new Scene(); // シーン
Camera camera = new Camera();

Timer timer = new Timer();
Spectrum[][] pixelBuffer;
int sampleCount = 0;

void setup() {
  size(1920, 1080);
  pixelBuffer = new Spectrum[width][height];
  for(int i = 0; i < width; i++) {
    for(int j = 0; j < height; j++) { pixelBuffer[i][j] = BLACK; }
  }
  initScene();
  initCamera();
  timer.start();
}

int y = 0;
void draw() {
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      pixelBuffer[x][y] = pixelBuffer[x][y].add(calcPixelSpectrum(x, y));
      set(x, y, pixelBuffer[x][y].scale(1.0 / (sampleCount + 1)).toColor());
    }
  }

  sampleCount++;
  timer.update(((float)sampleCount / SAMPLE_NUM));
  println(timer.getPrintOut());

  if(SAMPLE_NUM <= sampleCount) {
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
  for(int i = 0; i < 40; i++) {
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
  Spectrum sum = BLACK;
  for(int i = 0; i < SAMPLE_NUM; i++) {
    Ray ray = getPrimaryRay(x, y);
    sum = sum.add(scene.trace(ray, 0));
  }
  return sum.scale(1.0 / SAMPLE_NUM).toColor();
}

// ピクセルの色を計算
Spectrum calcPixelSpectrum(int x, int y) {
  Ray ray = getPrimaryRay(x, y);
  return scene.trace(ray, 0);
}
