components {
  id: "ship_shadow"
  component: "/scripts/ship_shadow.script"
  properties {
    id: "move_speed"
    value: "6.9"
    type: PROPERTY_TYPE_NUMBER
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ship_blured\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/basic.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.11
    y: 0.11
    z: 0.11
  }
}
embedded_components {
  id: "factory"
  type: "factory"
  data: "prototype: \"/prefabs/bullet.go\"\n"
  ""
}
