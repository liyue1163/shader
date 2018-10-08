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

  //  opacity
  float opacity = dot(normalInterp, vertPos);
  opacity = 0.60 * abs(opacity);
  opacity = 1.0 - pow(opacity, 12.0);
  // opacity = pow(opacity, -4.0);

  // ambient
  vec3 ambient = Ka * ambientColor;
  // diffuse
  vec3 diffuse = Kd * diffuseColor * max(0.0, dot(unitNorm, unitLight));
  // specular
  vec3 specular;
  vec3 unitReflect = normalize(-unitLight + 2.0 *(dot(unitNorm, unitLight)) * unitNorm);
  if (dot(unitNorm, unitLight) < 0.0) {
    specular = vec3(0.0, 0.0, 0.0);
  }
  else {
    specular = Ks * specularColor * pow(max(0.0, dot(unitReflect, unitView)), shininessVal);
  }
  vec3 color = opacity * (ambient + diffuse)  ;
  // The model is currently rendered in black
  gl_FragColor = vec4(color, opacity);

}
