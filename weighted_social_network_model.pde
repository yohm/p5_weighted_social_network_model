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

// Boolean that indicates whether we draw connections or not
boolean showParticles = true;
boolean showConnections = true;
boolean writing = false;

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
  cluster = new Cluster(300, width, height);
  physics.setWorldBounds(new Rect(100,100,width-200,height-200));
  
}

void draw() {
  cluster.updateNetwork();

  // Update the physics world
  physics.update();

  background(0);

  // Display all points
  if (showParticles) {
    cluster.showNodes();
  }

  // If we want to see the physics
  if (showConnections) {
    cluster.showConnections();
  }
  
  if( writing ) {
    PrintWriter writer = createWriter("net_proc.edg");
    cluster.Print(writer);
    writing = false;
  }

  // calculate Stylized facts
  if( frameCount % 9 == 0 ) {
    g_averageDegree = cluster.calcAverageDegree();
    g_CC = cluster.calcCC();
    g_averageWeight = cluster.calcAverageWeight();
  }

  // Print
  fill(255,120,255);
  textFont(f);
  String time = String.valueOf(frameCount/3);
  text("t = " + time + "\n<k> = " + g_averageDegree + "\nCC = " + g_CC + "\n<w> = " + g_averageWeight,10,20);

  //if( frameCount % 3 == 0 ) {
    //saveFrame("frames/####.tif");
  //}
}

// Key press commands
void keyPressed() {
  if (key == 'c') {
    showConnections = showConnections ? false : true;
  }
  else if (key == 'p') {
    showParticles = showParticles ? false : true;
  }
  else if (key == 'o') {
    writing = true;
  }
}

