components {
  id: "ship"
  component: "/scripts/ship.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"logo\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/video_atlases/videos.atlas\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "factory"
  type: "factory"
  data: "prototype: \"/prefabs/bullet.go\"\n"
  ""
}
