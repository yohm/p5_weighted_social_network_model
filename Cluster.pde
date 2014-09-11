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

  Link addLink(Node ni, Node nj) {
    float init_weight = 1.0;
    Link l = new Link(ni, nj, init_weight);
    m_links.add(l);
    physics.addSpring(l);
    ni.addEdge(nj, l);
    nj.addEdge(ni, l);
    return l;
  }

  Link addLink(int i, int j) {
    Node ni = m_nodes.get(i);
    Node nj = m_nodes.get(j);
    return addLink(ni, nj);
  }

  void strengthenLink(int link_idx) {
    Link l = m_links.get(link_idx);
    l.strengthen(1.0);
  }

  void removeLink(Link l) {
    physics.removeSpring(l);
    l.n1.deleteEdge( l.n2 );
    l.n2.deleteEdge( l.n1 );
    m_links.remove(l);
  }

  void removeLink(int link_idx) {
    if( link_idx >= m_links.size() ) { return; }
    Link l = m_links.get(link_idx);
    removeLink(l);
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
    Node ni = m_nodes.get(n);

    Link l_ij = ni.edgeSelection(null);
    if( l_ij == null ) { return; }
    l_ij.strengthen(1.0);

    Node nj = (l_ij.n1 == ni) ? l_ij.n2 : l_ij.n1;
    Link l_jk = nj.edgeSelection(ni);
    if( l_jk == null ) { return; }
    l_jk.strengthen(1.0);

    Node nk = (l_jk.n1 == nj) ? l_jk.n2 : l_jk.n1;
    Link l_ik = ni.getLinkTo(nk);
    if( l_ik == null ) {
      if( random(1.0) < 0.05 ) { addLink(ni, nk); }
    }
    else {
      l_ik.strengthen(1.0);
    }
  }

  void GA(int i) {
    float p_ga = 0.5;
    if( random(1.0) > p_ga ) { return; }

    Node ni = m_nodes.get(i);
    int j = int(random(m_nodes.size()-1));
    if( j >= i ) { j += 1; }
    Node nj = m_nodes.get(j);
    if( ! ni.hasEdge(nj) ) {
      Link l = addLink(ni, nj);
      l.setFresh();
    }
    else {
      println(i, j, " already has edge");
    }
  }

  void ND(int n) {
    float p_nd = 0.1;
    if( random(1.0) > p_nd ) { return; }

    println("removing ", n);
    Node node = m_nodes.get(n);
    for( Link l : node.allLinks() ) {
      removeLink(l);
    }
    node.setColorRed();
  }
}

