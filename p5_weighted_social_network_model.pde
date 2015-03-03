// Simulation based on Weighted Social Network model
//   proposed by Kumpula et al. PRL 99, 228701 (2007)
// Yohsuke Murase
//
// The code is based on
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
// Force directed graph,
// heavily based on: http://code.google.com/p/fidgen/

import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

// Reference to physics world
VerletPhysics2D physics;

// A list of cluster objects
Cluster cluster;
Parameters param;

// Boolean that indicates whether we draw connections or not
boolean showParticles = true;
boolean showConnections = true;
boolean writing = false;
boolean stopped = false;
boolean showStatistics = true;
int showingLink = -1;

// Font
PFont f;

float g_averageDegree = 0.0;
float g_CC = 0.0;
float g_averageWeight = 0.0;

void setup() {
  size(800, 600);
  f = createFont("Arial", 18, true);

  // Initialize the physics
  physics=new VerletPhysics2D();

  // Spawn a new random graph
  param = new Parameters();
  cluster = new Cluster(param, width, height);
  physics.setWorldBounds(new Rect(100,100,width-200,height-200));
  
}

void draw() {
  for( int f=0; f < 10; f++) {
    if(!stopped) {
      for( int i=0; i < 2; i++ ) {
        cluster.updateNetwork();
      }
    }
    physics.update();
  }

  background(0);

  // Display all points
  if( showingLink >= 0 ) {
    cluster.showOne(showingLink);
  } else {
    cluster.showAll();
  }
  
  if( writing ) {
    PrintWriter writer = createWriter("net_proc.edg");
    cluster.Print(writer);
    writing = false;
  }

  if( showStatistics ) {
    displayStatistics();
  }

  // saveFrame("frames/####.tif");
}

void displayStatistics() {
  // calculate Stylized facts
  if( frameCount % 9 == 0 ) {
    g_averageDegree = cluster.calcAverageDegree();
    g_CC = cluster.calcCC();
    g_averageWeight = cluster.calcAverageWeight();
  }

  // Print
  fill(255,120,255);
  textFont(f);
  String time = String.valueOf( cluster.time_step );
  text("t = " + time + "\n<k> = " + g_averageDegree + "\nCC = " + g_CC + "\n<w> = " + g_averageWeight,10,20);
}

// Key press commands
void keyPressed() {
  if (key == 'o') {
    writing = true;
  }
  else if (key == 's') {
    stopped = !stopped;
  }
  else if( key == 'j') {
    showingLink++;
    if( showingLink >= cluster.m_links.size() ) {
      showingLink = 0;
    }
  }
  else if( key == 'k') {
    showingLink--;
  }
  else if ( key == 'u' ) {
    showingLink = -showingLink;
  }
  else if (key == 'w') {
    showingLink = cluster.m_links.size() - 10; 
  }
  else if (key == 't') {
    showStatistics = !showStatistics;
  }
}

