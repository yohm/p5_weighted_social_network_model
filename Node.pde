// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Toxiclibs example: http://toxiclibs.org/

// Force directed graph
// Heavily based on: http://code.google.com/p/fidgen/

// Notice how we are using inheritance here!
// We could have just stored a reference to a VerletParticle object
// inside the Node class, but inheritance is a nice alternative

import java.util.Map;
import java.util.Collection;

class Node extends VerletParticle2D {

  int id;
  HashMap<Node,Link> m_edges;
  int color_r;

  Node(int _id, Vec2D pos) {
    super(pos);
    id = _id;
    m_edges = new HashMap<Node,Link>();
    color_r = 0;
  }

  void addEdge(Node node, Link link) {
    m_edges.put(node, link);
  }

  Collection<Link> allLinks() {
    return m_edges.values();
  }

  boolean hasEdge(Node node) {
    return ( m_edges.get(node) != null ) ? true : false;
  }

  void deleteEdge(Node node) {
    m_edges.remove(node);
  }

  int degree() {
    return m_edges.size();
  }

  Link edgeSelection() {
    float w_sum = 0.0;
    for( Link link : m_edges.values() ) { w_sum += link.weight; }

    float r = random(w_sum);
    Link ret = null;
    for( Link link : m_edges.values() ) {
      r -= link.weight;
      if( r <= 0.0 ) { ret = link; break; }
    }
    return ret;
  }

  void setColorRed() {
    color_r = 255;
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    color_r -= 1;
    fill(color_r,0,0,150);
    stroke(color_r,0,0);
    strokeWeight(2);
    ellipse(x,y,8,8);
  }
}

