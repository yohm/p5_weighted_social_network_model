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

class Node extends VerletParticle2D {

  int id;
  HashMap<Integer,Link> m_edges;

  Node(int _id, Vec2D pos) {
    super(pos);
    id = _id;
  }

  void addEdge(int i, Link link) {
    m_edges.put(i, link);
  }

  boolean hasEdge(int i) {
    return ( m_edges.get(i) != null );
  }

  void deleteEdge(int i) {
    m_edges.remove(i);
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    fill(0,150);
    stroke(0);
    strokeWeight(2);
    ellipse(x,y,8,8);
  }
}

