components {
  id: "ship"
  component: "/scripts/ship.script"
}
components {
  id: "ship_particle_long"
  component: "/prefabs/ship_particle_long.particlefx"
  position {
    y: -23.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ship\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/basic.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.1
    y: 0.1
    z: 0.1
  }
}
embedded_components {
  id: "factory"
  type: "factory"
  data: "prototype: \"/prefabs/bullet.go\"\n"
  ""
}
