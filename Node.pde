import java.util.Set;
import java.util.Map;
import java.util.Collection;

class Node extends VerletParticle2D {
  int id;
  HashMap<Integer,Link> m_edges;
  color original_color;

  Node(int _id, Vec2D pos) {
    super(pos);
    id = _id;
    m_edges = new HashMap<Integer,Link>();
    original_color = color(255,255,255);
  }

  void addEdge(Node node, Link link) {
    m_edges.put(node.id, link);
  }

  Collection<Link> allLinks() {
    return m_edges.values();
  }

  boolean hasEdge(Node node) {
    return ( m_edges.get(node.id) != null ) ? true : false;
  }

  Link getLinkTo(Node node) {
    return m_edges.get(node.id);
  }

  void deleteEdge(Node node) {
    m_edges.remove(node.id);
  }

  void clearEdge() {
    m_edges.clear();
  }

  int degree() {
    return m_edges.size();
  }
  
  Link edgeSelection(Node node) {
    if( node == null && degree() == 0 ) { return null; }
    if( node != null && degree() < 1 ) { return null; }

    float w_sum = 0.0;
    int id_to_skip = (node != null) ? node.id : -1;
    for( int nid : m_edges.keySet() ) {
      // if( node != null && nid == node.id ) { continue; }
      if( nid == id_to_skip ) { continue; }
      w_sum += m_edges.get(nid).weight;
    }
    float r = random(w_sum);
    float org_r = r;
    Link ret = null;
    for( int nid : m_edges.keySet() ) {
      // if( node != null && nid == node.id ) { continue; }
      if( nid == id_to_skip ) { continue; }
      Link link = m_edges.get(nid);
      r -= link.weight;
      ret = link;
      if( r <= 0.0 ) { break; }
    }
    return ret;
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    fill(original_color,150);
    stroke(original_color);
    strokeWeight(1);
    ellipse(x,y,2,2);
  }
}

