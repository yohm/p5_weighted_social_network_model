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
      Node node = new Node(i, new Vec2D(x,y));
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
    float init_weight = 1.0;
    Link l = new Link(ni, nj, init_weight);
    m_links.add(l);
    physics.addSpring(l);
    ni.addEdge(nj, l);
    nj.addEdge(ni, l);
  }

  void strengthenLink(int link_idx) {
    Link l = m_links.get(link_idx);
    l.strengthen(1.0);
  }

  void removeLink(int link_idx) {
    if( link_idx >= m_links.size() ) { return; }
    Link l = m_links.get(link_idx);
    physics.removeSpring(l);
    l.n1.deleteEdge( l.n2 );
    l.n2.deleteEdge( l.n1 );
    m_links.remove(link_idx);
  }

  void updateNetwork() {
    int r = int( random( m_nodes.size() * 3 ) );
    int action = r % 3;
    int target = r / 3;
    if( action == 0 ) { LA(target);}
    else if( action == 1 ) { GA(target); }
    else if( action == 2 ) { ND(target); }
    else { println("ERROR"); }
  }

  void LA(int n) {
    Node node = m_nodes.get(n);
    // IMPLEMENT ME
  }

  void GA(int n) {
    Node node = m_nodes.get(n);
    // IMPLEMENT ME
  }

  void ND(int n) {
    Node node = m_nodes.get(n);
    // IMPLEMENT ME
  }
}

