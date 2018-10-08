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

// Use the built-in variable gl_FragCoord to get the screen-space coordinates

void main() {
  
  vec2 screenCoord = vec2(gl_FragCoord.x, gl_FragCoord.y);
  screenCoord = screenCoord / 600.0;
  vec3 unitNorm = normalize(normalInterp);
  vec3 unitLight = normalize(lightPos - vertPos);
  float density = 60.0;

  vec2 nearest = 2.0 * fract(density * screenCoord) - 1.0;

  float dist = length(nearest);

  float intensity = min(max(0.0, dot(unitNorm, unitLight)), 0.9);
  float radius = 1.1 - intensity;

  vec3 ambient = Ka * ambientColor;
  vec3 diffuse = Kd * diffuseColor;
  // inside circle -> ambient; outside circle -> diffuse
  vec3 color = mix(ambient, diffuse, step(radius, dist));

  gl_FragColor = vec4(color, 1.0);
}
