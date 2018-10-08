attribute vec3 position; // Given vertex position in object space
attribute vec3 normal; // Given vertex normal in object space
attribute vec3 worldPosition; // Given vertex position in world space

uniform mat4 projection, modelview, normalMat; // Given scene transformation matrices
uniform vec3 eyePos;	// Given position of the camera/eye/viewer

// These will be given to the fragment shader and interpolated automatically
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Vector from the eye to the vertex
varying vec4 color;

uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position in camera space


void main(){
 
  vec4 vertPos4 = modelview * vec4(position, 1.0);
  gl_Position = projection * vertPos4;

  // vectors computations
  vertPos = vec3(vertPos4);
  vec4 norm4 = normalMat * vec4(normal, 1.0);
  vec3 unitNorm = normalize(vec3(norm4));
  vec3 unitLight = normalize(lightPos - vertPos);
  vec3 origin = vec3(0.0, 0.0, 0.0);
  vec3 viewVec = origin - vertPos;
  vec3 unitView = normalize(viewVec);

  // ambient
  vec3 ambient = Ka * ambientColor;
  // diffuse
  vec3 diffuse = (Kd * diffuseColor * max(0.0, dot(unitNorm, unitLight)));
  // specular
  vec3 specular;
  vec3 unitReflect = normalize(-unitLight + 2.0*(dot(unitNorm, unitLight)) * unitNorm);
  if (dot(unitNorm, unitLight) < 0.0) {
    specular = vec3(0.0, 0.0, 0.0);
  }
  else {
    specular = Ks * specularColor * pow(max(0.0, dot(unitReflect, unitView)), shininessVal);
  }
  vec3 illumination = ambient + diffuse + specular;
  color = vec4(illumination, 1.0);
  // color = vec4(ambientColor, 1.0);
}
