shader_type canvas_item;

uniform float width; // pixels
uniform float angle; // degrees
uniform vec2 offset; // pixel coordinates
uniform float duration; // seconds
uniform float speed; // 

bool in_range(float dot, vec2 vec) {
  return 0.0 <= dot && dot <= length(vec);
}

void vertex() {
  // Called for every vertex the material is visible on.
}

void fragment() {
  float step = mod(TIME, duration) * speed;
  float angle_rads = radians(angle);
  mat2 rotation_matrix = mat2(vec2(cos(angle_rads), -sin(angle_rads)), vec2(sin(angle_rads), cos(angle_rads)));
  vec2 start = (rotation_matrix * vec2(step, 0.0) + offset);
  vec2 direction = vec2(width, 0.0);
  vec2 rotation = rotation_matrix * direction;
  vec2 screen_uv_pixelized = SCREEN_UV / SCREEN_PIXEL_SIZE;
  vec2 point = screen_uv_pixelized - start;
  float dot_product = sqrt(dot(point, rotation));
  bool range = in_range(dot_product, rotation);
  vec4 texture_color = texture(TEXTURE, UV);

  COLOR = vec4(range ? 1.0:  COLOR.x, range ? 1.0 : COLOR.y, range ?1.0 :  COLOR.z, texture_color.a);
} 

//void light() {
//  // Called for every pixel for every light affecting the CanvasItem.
//  // Uncomment to replace the default light processing function with this one.
//}
