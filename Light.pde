class Light {
  Vec pos;
  Spectrum power;

  Light(Vec pos, Spectrum power) {
    this.pos = pos;
    this.power = power;
  }
}