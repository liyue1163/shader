precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector

// uniform values remain the same across the scene
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPos; // Light position in camera space

void main() {

  // vectors computations
  vec3 unitNorm = normalInterp;
  vec3 unitLight = normalize(lightPos - vertPos);
  vec3 origin = vec3(0.0, 0.0, 0.0);
  vec3 viewVec = origin - vertPos;
  vec3 unitView = normalize(viewVec);

  // ambient
  vec3 ambient = Ka * ambientColor;

  // diffuse
  float intensity = dot(unitNorm, unitLight);
  float assigned_intensity;
  if (intensity > 0.64) {
    assigned_intensity = 1.0;
  }
  else if (intensity > 0.35) {
    assigned_intensity = 0.6;
  }
  else if (intensity > 0.15) {
    assigned_intensity = 0.30;
  }
  else {
    assigned_intensity = 0.1;
  }
  vec3 diffuse = (Kd * diffuseColor * max(0.0, assigned_intensity));

  // specular
  vec3 specular;
  vec3 unitReflect = normalize(-unitLight + 2.0 *(dot(unitNorm, unitLight)) * unitNorm);
  intensity = dot(unitReflect, unitView);
  if (intensity > 0.98) {
    assigned_intensity = 1.0;
  }
  else {
    assigned_intensity = 0.0;
  }
  if (dot(unitNorm, unitLight) < 0.0) {
    specular = vec3(0.0, 0.0, 0.0);
  }
  else {
    specular = Ks * specularColor * pow(max(0.0, assigned_intensity), shininessVal);
  }

  gl_FragColor = vec4(ambient+diffuse+specular, 1.0);
}
