import java.util.Collections;

class LinkComparator implements java.util.Comparator {
  public int compare( Object l1, Object l2 ) {
    float l1w = ((Link)l1).weight;
    float l2w = ((Link)l2).weight;
    if( l1w == l2w ) { return 0; }
    else if( l1w > l2w ) { return 1; }
    else { return -1; }
  } 
} 

class Link extends VerletSpring2D {
  
  Node n1, n2;
  float weight;
  
  Link(Node _n1, Node _n2) {
    super(_n1, _n2, Parameters.attractive_l, Parameters.attractive_f);
    n1 = _n1;
    n2 = _n2;
    weight = Parameters.init_weight;
    setStrength( calcStrength() );
    setRestLength( calcRestLength() );

    // original_color = color(0,255,128,255);
  }
  
  float calcStrength() {
    return Parameters.attractive_f * log(weight+1);
  }

  float calcRestLength() {
    return Parameters.attractive_l;
  }

  void strengthen(float dw) {
    weight += dw;
    setStrength( calcStrength() );
    setRestLength( calcRestLength() );
  }
  
  void Aging(float f) {
    weight = weight * f;
  }

  void display() {
    // display( color(0,255,0) );
    display( calcColor() );
  }

  color calcColor() {
    color min = Parameters.link_colors[0]; // color(64, 64, 192);
    color mid = Parameters.link_colors[1]; // color(255, 255, 255);
    color max = Parameters.link_colors[2]; // color(192, 32, 32);
    float w_mid = Parameters.link_mid_weight;
    if( weight < w_mid ) {
      float w = (weight - 0.0) / (w_mid - 0.0);
      return lerpColor(min,mid,w);
    }
    else {
      float w = (weight - w_mid) / ( 2*w_mid - w_mid);
      return lerpColor(mid,max,w);
    }
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display( color current_color ) {
    if( weight < Parameters.link_min_weight_to_show ) return;
    stroke(current_color);
    strokeWeight(Parameters.link_stroke_weight*log(weight+1.0));
    // strokeWeight(0.5*weight);
    line(n1.x, n1.y, n2.x, n2.y);
  }
}

