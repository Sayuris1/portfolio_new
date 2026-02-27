components {
  id: "scale_to_screen"
  component: "/scripts/scale_to_screen.script"
}
components {
  id: "animate_bg"
  component: "/scripts/animate_bg.script"
}
embedded_components {
  id: "model"
  type: "model"
  data: "mesh: \"/builtins/assets/meshes/quad_2x2.dae\"\n"
  "skeleton: \"/builtins/assets/meshes/quad_2x2.dae\"\n"
  "animations: \"/builtins/assets/meshes/quad_2x2.dae\"\n"
  "name: \"{{NAME}}\"\n"
  "materials {\n"
  "  name: \"default\"\n"
  "  material: \"/shaders/bg.material\"\n"
  "}\n"
  "create_go_bones: false\n"
  ""
}
