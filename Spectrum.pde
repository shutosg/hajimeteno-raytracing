class Spectrum {
  float r, g, b;
  Spectrum(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  Spectrum(float p) {
    this.r = p;
    this.g = p;
    this.b = p;
  }

  Spectrum add(Spectrum v) {
    return new Spectrum(this.r + v.r, this.g + v.g, this.b + v.b);
  }

  Spectrum sub(Spectrum v) {
    return new Spectrum(this.r - v.r, this.g - v.g, this.b - v.b);
  }
  
  Spectrum mul(Spectrum v) {
    return new Spectrum(this.r * v.r, this.g * v.g, this.b * v.b);
  }
  
  Spectrum scale(float s) {
    return new Spectrum(this.r * s, this.g * s, this.b * s);
  }

  color toColor() {
    int ir = (int)min(pow(this.r, 1.0 / DISPLAY_GAMMA) * 255, 255);
    int ig = (int)min(pow(this.g, 1.0 / DISPLAY_GAMMA) * 255, 255);
    int ib = (int)min(pow(this.b, 1.0 / DISPLAY_GAMMA) * 255, 255);
    return color(ir, ig, ib);
  }
  // スペクトラムを文字列として返す
  String toString() {
    return "Spectrum(" + this.r + ", " + this.g + ", " + this.b + ")";
  }
}
final float DISPLAY_GAMMA = 2.2;
final Spectrum BLACK = new Spectrum(0);