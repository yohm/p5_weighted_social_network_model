// parameters for aging
static class Parameters {
  
  // simulation parameters
  static int num_nodes = 300;
  static float p_la = 0.05;
  static float p_ga = 0.0005;
  static int deletion_type = 0;  // 0: node deletion, 1: aging, 2: link deletion
  static float p_nd = 0.001;
  static float aging = 0.96;
  static float w_th = 0.01;
  static float p_ld = 0.001;
  static float init_weight = 1.0;

  // spring parameters
  static float repulsive_l = 50.0;
  static float repulsive_f = 0.1;
  static float attractive_l = 30.0;
  static float attractive_f = 0.02;
  
  // visualize parameters for links
  static color link_colors[] = {#CBE6F3, #B2CF3E, #DA5019};
  static float link_mid_weight = 300;
  static float link_stroke_weight = 0.2;
  static float link_min_weight_to_show = 0.0;

  // visualize parameters for nodes
  static color node_color = #555555;
  static float node_stroke_weight = 1.0;
  static float node_radius = 2.0;
  
  static void setAgingParameter() {
    deletion_type = 1;
    p_ga = 0.001;
    aging = 0.98;
    
    link_mid_weight = 30;
  }
  
  static void setLDParameter() {
    deletion_type = 2;
    p_ld = 0.0035;
    link_mid_weight = 200.0;
  }
};

