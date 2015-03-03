/*
static class Parameters {
  
  // simulation parameters
  static int num_nodes = 300;
  static float p_la = 0.05;
  static float p_ga = 0.001;
  static int deletion_type = 1;  // 0: node deletion, 1: aging, 2: link deletion
  static float p_nd = 0.001;
  static float aging = 0.95;
  static float w_th = 0.01;
  static float p_ld = 0.001;
  static float init_weight = 1.0;

  // spring parameters
  static float repulsive_l = 50.0;
  static float repulsive_f = 0.1;
  static float attractive_l = 30.0;
  static float attractive_f = 0.01;
  
  // visualize parameters for links
  static color link_colors[] = {#007AB7, #F6CA06, #C7243A};
  static float link_mid_weight = 40;
  static float link_stroke_weight = 0.2;
  static float link_min_weight_to_show = 0.0;

  // visualize parameters for nodes
  static color node_color = #BBBBBB;
  static float node_stroke_weight = 1.0;
  static float node_radius = 2.0;
};
*/

// parameters for aging
static class Parameters {
  
  // simulation parameters
  static int num_nodes = 300;
  static float p_la = 0.05;
  static float p_ga = 0.001;
  static int deletion_type = 1;  // 0: node deletion, 1: aging, 2: link deletion
  static float p_nd = 0.001;
  static float aging = 0.96;
  static float w_th = 0.01;
  static float p_ld = 0.001;
  static float init_weight = 1.0;

  // spring parameters
  static float repulsive_l = 40.0;
  static float repulsive_f = 0.1;
  static float attractive_l = 40.0;
  static float attractive_f = 0.02;
  
  // visualize parameters for links
  static color link_colors[] = {#007AB7, #F6CA06, #C7243A};
  static float link_mid_weight = 40;
  static float link_stroke_weight = 0.2;
  static float link_min_weight_to_show = 0.0;

  // visualize parameters for nodes
  static color node_color = #BBBBBB;
  static float node_stroke_weight = 1.0;
  static float node_radius = 2.0;
};
