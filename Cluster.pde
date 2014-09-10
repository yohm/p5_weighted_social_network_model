// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Toxiclibs example: http://toxiclibs.org/

// Force directed graph
// Heavily based on: http://code.google.com/p/fidgen/

class Cluster {

  // A cluster is a grouping of nodes
  ArrayList<Node> nodes;
  ArrayList<Link> links;

  float diameter;

  // We initialize a Cluster with a number of nodes, a diameter, and centerpoint
  Cluster(int n, float d, Vec2D center) {

    // Initialize the ArrayList
    nodes = new ArrayList<Node>();
    links = new ArrayList<Link>();

    // Create the nodes
    for (int i = 0; i < n; i++) {
      // We can't put them right on top of each other
      nodes.add(new Node(center.add(Vec2D.randomVector())));
    }

    // Connect all the nodes with a Spring
    for (int i = 0; i < nodes.size()-1; i++) {
      Node ni = nodes.get(i);
      for (int j = i+1; j < nodes.size(); j++) {
        Node nj = nodes.get(j);
        // A Spring needs two particles, a resting length, and a strength
        Link l = new Link(ni, nj, 1.0);
        links.add(l);
        physics.addSpring(l);
      }
    }
    
    VerletParticle2D n0 = nodes.get(0);
    VerletParticle2D n2 = nodes.get(2);
    VerletSpring2D s = physics.getSpring(n0, n2);
    // s.setStrength(0.001);
    // s.setRestLength(200.0);
  }

  // Draw all nodes
  void showNodes() {
   for( Node n : nodes ) {
    n.display();
   }
  }

  // Draw all the internal connections
  void showConnections() {
    for( Link l: links ) {
      l.display();
    }
  }

  void strengthenLink(int link_idx) {
    Link l = links.get(link_idx);
    l.strengthen(1.0);
  }
}

