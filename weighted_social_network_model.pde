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

// Font
PFont f;

void setup() {
  size(640, 560);
  f = createFont("Arial", 14, true);

  // Initialize the physics
  physics=new VerletPhysics2D();

  // Spawn a new random graph
  cluster = new Cluster(200, width, height);
  physics.setWorldBounds(new Rect(10, 10, width-20, height-20));
}

void draw() {

  cluster.updateNetwork();

  // Update the physics world
  physics.update();

  background(255);

  // Display all points
  if (showParticles) {
    cluster.showNodes();
  }

  // If we want to see the physics
  if (showConnections) {
    cluster.showConnections();
  }

  // Instructions
  fill(0);
  textFont(f);
  text("Weighted Social Network model",10,20);
}

// Key press commands
void keyPressed() {
  if (key == 'c') {
    showConnections = showConnections ? false : true;
  }
  else if (key == 'p') {
    showParticles = showParticles ? false : true;
  }
}

