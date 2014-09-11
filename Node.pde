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

  Link getLinkTo(Node node) {
    return m_edges.get(node);
  }

  void deleteEdge(Node node) {
    m_edges.remove(node);
  }

  int degree() {
    return m_edges.size();
  }

  Link edgeSelection(Node node) {
    float w_sum = 0.0;
    if( node == null && degree() == 0 ) { return null; }
    if( node != null && degree() < 1 ) { return null; }

    for( Node n : m_edges.keySet() ) {
      if( n == node ) { continue; }
      println(n, node, m_edges);
      Link l = m_edges.get(n);
      println(l);
      w_sum += l.weight;
      // w_sum += m_edges.get(n).weight;
    }
    float r = random(w_sum);
    Link ret = null;
    for( Node n : m_edges.keySet() ) {
      if( n == node ) { continue; }
      Link link = m_edges.get(n);
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

