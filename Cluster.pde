// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Toxiclibs example: http://toxiclibs.org/

// Force directed graph
// Heavily based on: http://code.google.com/p/fidgen/

class Cluster {

  // A cluster is a grouping of nodes
  ArrayList<Node> nodes;

  float diameter;

  // We initialize a Cluster with a number of nodes, a diameter, and centerpoint
  Cluster(int n, float d, Vec2D center) {

    // Initialize the ArrayList
    nodes = new ArrayList<Node>();

    // Set the diameter
    diameter = d;

    // Create the nodes
    for (int i = 0; i < n; i++) {
      // We can't put them right on top of each other
      nodes.add(new Node(center.add(Vec2D.randomVector())));
    }

    // Connect all the nodes with a Spring
    for (int i = 0; i < nodes.size()-1; i++) {
      VerletParticle2D ni = nodes.get(i);
      for (int j = i+1; j < nodes.size(); j++) {
        VerletParticle2D nj = nodes.get(j);
        // A Spring needs two particles, a resting length, and a strength
        physics.addSpring(new VerletSpring2D(ni, nj, diameter, 0.01));
      }
    }
    
    VerletParticle2D n0 = nodes.get(0);
    VerletParticle2D n2 = nodes.get(2);
    VerletSpring2D s = physics.getSpring(n0, n2);
    // s.setStrength(0.001);
    // s.setRestLength(200.0);
  }

  void display() {
    // Show all the nodes
    for (Node n : nodes) {
      n.display();
    }
  }


  // Draw all the internal connections
  void showConnections() {
    stroke(0, 150);
    strokeWeight(2);

    for( VerletSpring2D spring: physics.springs ) {
      line(spring.a.x, spring.a.y, spring.b.x, spring.b.y);
    }
  }
}

