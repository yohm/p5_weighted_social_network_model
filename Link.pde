class Link extends VerletSpring2D {
  
  Node n1, n2;
  float weight;
  
  Link(Node _n1, Node _n2, float _weight) {
    super(_n1, _n2, 100.0, 0.01);
    n1 = _n1;
    n2 = _n2;
    weight = _weight;
    float s = calcStrength(weight);
    setStrength(s);
  }
  
  float calcStrength(float w) {
    //    return 0.01 * log(w+1);
    return 0.01 * w;
  }

  void strengthen(float dw) {
    weight += dw;
    float s = calcStrength(weight);
    setStrength(s);
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    stroke(80,0,0,150);
    strokeWeight(weight);
    line(n1.x, n1.y, n2.x, n2.y);
  }
}

