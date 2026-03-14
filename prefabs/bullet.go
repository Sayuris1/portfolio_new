components {
  id: "bullet"
  component: "/scripts/bullet.script"
}
components {
  id: "particle"
  component: "/prefabs/blow_letter.particlefx"
  position {
    y: 15.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"bullet\"\n"
  "material: \"/shaders/sprite_bullet.material\"\n"
  "slice9 {\n"
  "  w: 16.800001\n"
  "}\n"
  "size {\n"
  "  x: 32.0\n"
  "  y: 32.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/basic.atlas\"\n"
  "}\n"
  ""
  rotation {
    z: 0.70710677
    w: 0.70710677
  }
  scale {
    x: 0.5
    y: 0.5
    z: 0.5
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_KINEMATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"bullet\"\n"
  "mask: \"label\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 1\n"
  "  }\n"
  "  data: 37.5\n"
  "}\n"
  "locked_rotation: true\n"
  "bullet: true\n"
  "event_contact: false\n"
  "event_trigger: false\n"
  ""
}
