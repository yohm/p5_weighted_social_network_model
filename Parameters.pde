static class Parameters {
  
  // simulation parameters
  static int num_nodes = 300;
  static float p_la = 0.05;
  static float p_ga = 0.0005;
  static int deletion_type = 1;  // 0: node deletion, 1: aging, 2: link deletion
  static float p_nd = 0.001;
  static float aging = 0.92;
  static float w_th = 0.01;
  static float p_ld = 0.001;
  static float init_weight = 1.0;

  // spring parameters
  static float repulsive_l = 50.0;
  static float repulsive_f = 0.1;
  static float attractive_l = 30.0;
  static float attractive_f = 0.01;
};
