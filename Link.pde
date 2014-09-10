class Link extends VerletSpring2D {
  
  Node n1, n2;
  float weight;
  color original_color;
  color new_born;
  float color_scale;
  
  Link(Node _n1, Node _n2, float _weight) {
    super(_n1, _n2, 300.0, 0.01);
    n1 = _n1;
    n2 = _n2;
    weight = _weight;
    float s = calcStrength(weight);
    setStrength(s);

    original_color = color(0,255,150,200);
    new_born = color(255,0,255,200);
    color_scale = 0.0;
  }
  
  float calcStrength(float w) {
    //    return 0.01 * log(w+1);
    return 0.001 * w;
  }

  void strengthen(float dw) {
    weight += dw;
    float s = calcStrength(weight);
    setStrength(s);
  }

  void setNewBornColor() {
    color_scale = 1.0;
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    color_scale -= 0.01;
    color current_color = lerpColor(original_color, new_born, color_scale); 
    stroke(current_color);
    strokeWeight(0.5*weight);
    line(n1.x, n1.y, n2.x, n2.y);
  }
}

