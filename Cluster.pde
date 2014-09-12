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
  int time_step;

  // We initialize a Cluster with a number of nodes, a diameter, and centerpoint
  Cluster(int n, float width, float height) {

    // Initialize the ArrayList
    m_nodes = new ArrayList<Node>();
    m_links = new ArrayList<Link>();
    time_step = 0;

    // Create the nodes
    for (int i = 0; i < n; i++) {
      // We can't put them right on top of each other
      float x = random(50, width - 100);
      float y = random(50, height - 100);
      Node node = new Node(i, new Vec2D(x,y));
      m_nodes.add(node);
    }
    
    for( int i=0; i < n; i++) {
      Node ni = m_nodes.get(i);
      for( int j=0; j < n; j++) {
        Node nj = m_nodes.get(j);
        attachRepulsionSpring(ni,nj);
      }
    }
  }

  void attachRepulsionSpring(Node ni, Node nj) {
    VerletMinDistanceSpring2D repulsion = new VerletMinDistanceSpring2D(ni,nj,50.0,0.1);
    physics.addSpring(repulsion);
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

  void Print(PrintWriter writer) {
    for( Link l : m_links ) {
      writer.println(String.valueOf(l.n1.id) + " " + String.valueOf(l.n2.id) + " " + String.valueOf(l.weight));
    }
  }

  Link addLink(Node ni, Node nj) {
    VerletSpring2D s = physics.getSpring(ni,nj);
    if( s != null ) { physics.removeSpring(s); }

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

  void removeLinksOfNode(Node node) {
    for( Link l : node.allLinks() ) {
      Node pair = ( l.n1.id == node.id ) ? l.n2 : l.n1;
      pair.deleteEdge(node);
      m_links.remove(l);
      physics.removeSpring(l);
      attachRepulsionSpring(node,pair);
    }
    node.clearEdge();
  }

  void updateNetwork() {
    int num_nodes = m_nodes.size();

    int action = time_step % 3;
    for( Node node : m_nodes ) {
      if( action == 0 ) { LA(node);}
      else if( action == 1 ) { GA(node); }
      else if( action == 2 ) { ND(node); }
    }

    if( time_step % 1 == 0 ) {
      for( Node n : m_nodes ) { n.aging(); }
      for( Link l : m_links ) { l.aging(); }
    }
    time_step += 1;
  }

  void LA(Node ni) {
    float p_la = 0.05;

    if( ni.degree() == 0 ) { return; }
    Link l_ij = ni.edgeSelection(null);
    if( l_ij == null ) { println("must not happen"); throw new RuntimeException("foo"); }
    l_ij.strengthen(1.0);

    Node nj = (l_ij.n1.id == ni.id) ? l_ij.n2 : l_ij.n1;
    if( nj.degree() == 1 ) { return; }
    Link l_jk = nj.edgeSelection(ni);
    if( l_jk == null ) { println("must not happen"); throw new RuntimeException("foo"); }
    l_jk.strengthen(1.0);

    Node nk = (l_jk.n1.id == nj.id) ? l_jk.n2 : l_jk.n1;
    Link l_ik = ni.getLinkTo(nk);
    if( l_ik == null ) {
      if( random(1.0) < p_la ) {
        Link l = addLink(ni, nk);
        l.setFresh(false);
      }
    }
    else {
      l_ik.strengthen(1.0);
    }
  }

  void GA(Node ni) {
    float p_ga = 0.0005;

    if( ni.degree() > 0 && random(1.0) > p_ga ) { return; }
    int j = int(random(m_nodes.size()-1));
    if( j >= ni.id ) { j += 1; }
    Node nj = m_nodes.get(j);
    if( ! ni.hasEdge(nj) ) {
      Link l = addLink(ni, nj);
      l.setFresh(true);
    }
  }

  void ND(Node ni) {
    float p_nd = 0.001;
    if( random(1.0) > p_nd ) { return; }

    removeLinksOfNode(ni);
    ni.setNewBornColor();
  }
}

