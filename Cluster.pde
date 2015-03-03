class Cluster {

  // A cluster is a grouping of nodes
  ArrayList<Node> m_nodes;
  ArrayList<Link> m_links;
  int time_step;

  // We initialize a Cluster with a number of nodes, a diameter, and centerpoint
  Cluster(float width, float height) {
    // Initialize the ArrayList
    m_nodes = new ArrayList<Node>();
    m_links = new ArrayList<Link>();
    time_step = 0;

    // Create the nodes
    for (int i = 0; i < Parameters.num_nodes; i++) {
      // We can't put them right on top of each other
      float x = random(50, width - 100);
      float y = random(50, height - 100);
      Node node = new Node(i, new Vec2D(x,y));
      m_nodes.add(node);
    }
    
    for( int i=0; i < Parameters.num_nodes; i++) {
      Node ni = m_nodes.get(i);
      for( int j=0; j < Parameters.num_nodes; j++) {
        Node nj = m_nodes.get(j);
        attachRepulsionSpring(ni,nj);
      }
    }
  }

  void attachRepulsionSpring(Node ni, Node nj) {
    VerletMinDistanceSpring2D repulsion =
      new VerletMinDistanceSpring2D(ni,nj, Parameters.repulsive_l, Parameters.repulsive_f);
    physics.addSpring(repulsion);
  }
  
  void showAll() {
    showNodes();
    showConnections();
  }
  
  boolean isCommonNeighbor(Node n, Node n1, Node n2) {
    return (n.hasEdge(n1) && n.hasEdge(n2));
  }
  
  void showOne(int link_idx) {
    Link l = m_links.get(link_idx);
    l.n1.display();
    l.n2.display();
    l.display( color(0,255,255) );
    int n_candidates = 0;
    int n_overlapping = 0;
    float total_weight = 0.0;
    float overlapping_weight = 0.0;
    for( Link neighbor : l.n1.allLinks() ) {
      if( neighbor == l ) { continue; }
      Node n3 = ( neighbor.n1 == l.n1 ) ? neighbor.n2 : neighbor.n1;
      color c = color(0,255,0);
      n_candidates++;
      total_weight += neighbor.weight;
      if( isCommonNeighbor( n3, l.n1, l.n2 ) ) {
        c = color(255,0,255);
        n_overlapping++;
        overlapping_weight += neighbor.weight;
      }
      neighbor.display(c);
    }
    for( Link neighbor : l.n2.allLinks() ) {
      if( neighbor == l ) { continue; }
      Node n3 = (neighbor.n1 == l.n2 ) ? neighbor.n2 : neighbor.n1;
      color c = color(0,255,0);
      n_candidates++;
      total_weight += neighbor.weight;
      if( isCommonNeighbor(n3, l.n1, l.n2) ) {
        c = color(255,0,255);
        overlapping_weight += neighbor.weight;
      }
      neighbor.display(c);
    }
    
    float o_ij = float(n_overlapping)/(n_candidates-n_overlapping);
    float weight_overlap = overlapping_weight / total_weight;
    printOverlap(l.weight, o_ij, weight_overlap);
  }
  
  void printOverlap(float w, float o_ij, float weight_o) {
    text("w = " + w + "\nO_ij = " + o_ij + "\nO_w = " + weight_o,10,400);
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
    Link l = new Link(ni, nj);
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
  
  void removeLink(Link l) {
    Node n1 = l.n1;
    Node n2 = l.n2;
    n1.deleteEdge(n2);
    n2.deleteEdge(n1);
    // m_links.remove(l);
    physics.removeSpring(l);
    attachRepulsionSpring(n1,n2);
  }

  void updateNetwork() {
    int num_nodes = m_nodes.size();

    for( Node node : m_nodes ) { LA(node); }
    for( Node node : m_nodes ) { GA(node); }
    
    if( Parameters.deletion_type == 0 ) {
      for( Node node : m_nodes ) { ND(node); }
    }
    else if( Parameters.deletion_type == 1 ) {
      Aging();
    }
    else if( Parameters.deletion_type == 2 ) {
      LinkDeletion();
    }
    
    time_step += 1;
  }
  
  void Aging() {
    // Aging
    ArrayList<Link> linksToRemove = new ArrayList<Link>();
    for( Link l : m_links ) {
      l.Aging(Parameters.aging);
      if( l.weight < Parameters.w_th ) {
        removeLink(l);
        linksToRemove.add(l);
      }
    }
    for( Link l : linksToRemove ) {
      m_links.remove(l);
    }
  }
  
  void LinkDeletion() {
    ArrayList<Link> linksToRemove = new ArrayList<Link>();
    for( Link l : m_links ) {
      if( random(1.0) < Parameters.p_ld ) {
        removeLink(l);
        linksToRemove.add(l);
      }
    }
    for( Link l : linksToRemove ) {
      m_links.remove(l);
    }
  }

  void LA(Node ni) {

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
      if( random(1.0) < Parameters.p_la ) {
        Link l = addLink(ni, nk);
      }
    }
    else {
      l_ik.strengthen(1.0);
    }
  }

  void GA(Node ni) {
    if( ni.degree() > 0 && random(1.0) > Parameters.p_ga ) { return; }
    int j = int(random(m_nodes.size()-1));
    if( j >= ni.id ) { j += 1; }
    Node nj = m_nodes.get(j);
    if( ! ni.hasEdge(nj) ) {
      Link l = addLink(ni, nj);
    }
  }
  
  void ND(Node ni) {
    if( random(1.0) > Parameters.p_nd ) { return; }

    removeLinksOfNode(ni);
  }

  float calcAverageDegree() {
    return 2.0 * float(m_links.size()) / m_nodes.size();
  }

  float calcCC() {
    float sum = 0.0;
    for( Node n : m_nodes ) {
      sum += calcLocalCC(n);
    }
    return sum / m_nodes.size();
  }
  float calcLocalCC(Node n) {
    int k = n.degree();
    if( k <= 1 ) { return 0.0; }
    float connected = 0.0;
    Set<Integer> neighbors = n.m_edges.keySet();
    for( int i : neighbors ) {
      for( int j : neighbors ) {
        if( i < j ) continue;
        connected += m_nodes.get(i).hasEdge(m_nodes.get(j)) ? 1.0 : 0.0;
      }
    }
    float localCC = connected * 2.0 / (k*(k-1));
    return localCC;
  }

  float calcAverageWeight() {
    float sum = 0.0;
    for( Link l : m_links ) { sum += l.weight; }
    return sum / m_links.size();
  }
}

