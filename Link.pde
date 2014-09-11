class Link extends VerletSpring2D {
  
  Node n1, n2;
  float weight;
  color original_color;
  color ga_fresh_color;
  color la_fresh_color;
  float freshness;
  boolean ga_or_la;  // true: GA, false: LA
  
  Link(Node _n1, Node _n2, float _weight) {
    super(_n1, _n2, 30.0, 0.01);
    n1 = _n1;
    n2 = _n2;
    weight = _weight;
    setStrength( calcStrength() );
    setRestLength( calcRestLength() );

    original_color = color(0,255,128,255);
    ga_fresh_color = color(128,128,0,255);
    la_fresh_color = color(255,0,255,255);
    freshness = 0.0;
    ga_or_la = true;
  }
  
  float calcStrength() {
    return 0.01 * log(weight+1);
    // return 0.001 * w;
  }

  float calcRestLength() {
    // return 100.0 / log(weight+1);
    return 30.0;
  }

  void strengthen(float dw) {
    weight += dw;
    setStrength( calcStrength() );
    setRestLength( calcRestLength() );
  }

  void setFresh(boolean _ga_or_la) {
    freshness = 1.0;
    ga_or_la = _ga_or_la;
  }

  void aging() {
    freshness -= 0.01;
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    color fresh_color = ga_or_la ? ga_fresh_color : la_fresh_color;
    color current_color = lerpColor(original_color, fresh_color, freshness); 
    stroke(current_color);
    strokeWeight(0.2*log(weight+1.0));
    // strokeWeight(0.5*weight);
    line(n1.x, n1.y, n2.x, n2.y);
  }
}

