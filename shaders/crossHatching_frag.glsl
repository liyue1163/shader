// Fragment shader template for the bonus question

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

uniform sampler2D uSampler;	// 2D sampler for the earth texture

void main() {

  // vector computations
  vec3 unitNorm = normalize(normalInterp);
  vec3 unitLight = normalize(lightPos - vertPos);
  vec3 unitView = normalize(viewVec);

  // calculate intensity of lighting
  float ambient = 0.0030;

  float diffuse = Kd * min(max(dot(unitLight, unitNorm), 0.0), 1.0);

  vec3 unitReflect = normalize(-unitLight + 2.0 *(dot(unitNorm, unitLight)) * unitNorm);
  float specular = 0.0;
  if(diffuse > 0.0) {
    specular = Ks * pow(dot(unitView, unitReflect), shininessVal);
  }
  float lightIntensity = min(max(diffuse + specular + ambient, 0.0), 1.0);
  //float lightIntensity = min(max(0.0, dot(unitNorm, unitLight)), 0.9);
  gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
  if (lightIntensity < 0.95) {
    // hatch from left top corner to right bottom
    if (mod(gl_FragCoord.x + gl_FragCoord.y, 9.0) == 0.0) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
  }
  if (lightIntensity < 0.6){
    // hatch from right top corner to left boottom
    if (mod(gl_FragCoord.x - gl_FragCoord.y, 8.0) == 0.0) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
  }
  if (lightIntensity < 0.30){
    // hatch from left top to right bottom
    if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 7.0) == 0.0) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
      }
  }
  if (lightIntensity < 0.10) {
    // hatch from right top corner to left bottom
    if (mod(gl_FragCoord.x + gl_FragCoord.y - 6.0, 6.0) == 0.0) {
      gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
  }
}
