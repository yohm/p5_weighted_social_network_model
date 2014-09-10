// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Toxiclibs example: http://toxiclibs.org/

// Force directed graph
// Heavily based on: http://code.google.com/p/fidgen/

class Cluster {

  // A cluster is a grouping of nodes
  ArrayList<Node> m_nodes;
  ArrayList<Link> m_links;

  // We initialize a Cluster with a number of nodes, a diameter, and centerpoint
  Cluster(int n, float width, float height) {

    // Initialize the ArrayList
    m_nodes = new ArrayList<Node>();
    m_links = new ArrayList<Link>();

    // Create the nodes
    for (int i = 0; i < n; i++) {
      // We can't put them right on top of each other
      float x = random(50, width - 100);
      float y = random(50, height - 100);
      Node node = new Node(new Vec2D(x,y));
      m_nodes.add(node);
    }
  }

  // Draw all nodes
  void showNodes() {
    for( Node n : m_nodes ) {
      n.display();
    }
  }

  // Draw all the internal connections
  void showConnections() {
    for( Link l: m_links ) {
      l.display();
    }
  }

  void addLink(int i, int j) {
    Node ni = m_nodes.get(i);
    Node nj = m_nodes.get(j);
    Link l = new Link(ni, nj, 1.0);
    m_links.add(l);
    physics.addSpring(l);
  }

  void strengthenLink(int link_idx) {
    Link l = m_links.get(link_idx);
    l.strengthen(1.0);
  }

  void removeLink(int link_idx) {
    if( link_idx >= m_links.size() ) { return; }
    Link l = m_links.get(link_idx);
    physics.removeSpring(l);
    m_links.remove(link_idx);
  }
}

