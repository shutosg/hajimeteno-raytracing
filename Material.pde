class Material {
  Spectrum diffuse;
  float reflective = 0;
  float refractive = 0;
  float refractiveIndex = 1;

  Material(Spectrum diffuse) {
    this.diffuse = diffuse;
  }
  Material(Spectrum diffuse, float reflective) {
    this.diffuse = diffuse;
    this.reflective = reflective;
  }
  Material(Spectrum diffuse, float reflective, float refractive, float refractiveIndex) {
    this.diffuse = diffuse;
    this.reflective = reflective;
    this.refractive = refractive;
    this.refractiveIndex = refractive;
  }
}