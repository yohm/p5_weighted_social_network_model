class Link extends VerletSpring2D {
  
  Node n1, n2;
  float weight;
  color original_color;
  color fresh_color;
  float freshness;
  
  Link(Node _n1, Node _n2, float _weight) {
    super(_n1, _n2, 100.0, 0.01);
    n1 = _n1;
    n2 = _n2;
    weight = _weight;
    float s = calcStrength(weight);
    setStrength(s);

    original_color = color(0,255,150,200);
    fresh_color = color(255,0,255,200);
    freshness = 0.0;
  }
  
  float calcStrength(float w) {
    return 0.01 * log(w+1);
    // return 0.001 * w;
  }

  void strengthen(float dw) {
    weight += dw;
    float s = calcStrength(weight);
    setStrength(s);
  }

  void setFresh() {
    freshness = 1.0;
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    freshness -= 0.01;
    color current_color = lerpColor(original_color, fresh_color, freshness); 
    stroke(current_color);
    strokeWeight(0.5*log(weight+1.0));
    // strokeWeight(0.5*weight);
    line(n1.x, n1.y, n2.x, n2.y);
  }
}

