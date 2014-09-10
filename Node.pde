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

  Node(int _id, Vec2D pos) {
    super(pos);
    id = _id;
    m_edges = new HashMap<Node,Link>();
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

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    fill(0,150);
    stroke(0);
    strokeWeight(2);
    ellipse(x,y,8,8);
  }
}

