class Link extends VerletSpring2D {
  
  Node n1, n2;
  float weight;
  
  Link(Node _n1, Node _n2, float _weight) {
    super(_n1, _n2, 30.0, 0.01);
    n1 = _n1;
    n2 = _n2;
    weight = _weight;
    setStrength( calcStrength() );
    setRestLength( calcRestLength() );

    // original_color = color(0,255,128,255);
  }
  
  float calcStrength() {
    return 0.005 * log(weight+1);
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
  
  void Aging(float f) {
    weight = weight * f;
  }

  void display() {
    // display( color(0,255,0) );
    display( calcColor() );
  }

  color calcColor() {
    color min = color(64, 64, 192);
    color mid = color(255, 255, 255);
    color max = color(192, 32, 32);
    if( weight < 20.0 ) {
      float w = (weight - 0.0) / (20.0 - 0.0);
      // float w = (log(weight) - log(0.01))/(log(10.0) - log(0.01));
      return lerpColor(min,mid,w);
    }
    else {
      float w = (weight - 20.0) / (40.0-20.0);
      return lerpColor(mid,max,w);
    }
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display( color current_color ) {
    if( weight < 1.0 ) return;
    stroke(current_color);
    strokeWeight(0.2*log(weight+1.0));
    // strokeWeight(0.5*weight);
    line(n1.x, n1.y, n2.x, n2.y);
  }
}

