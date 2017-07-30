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

Network net;

// Boolean that indicates whether we draw connections or not
boolean showParticles = true;
boolean showConnections = true;
boolean writing = false;
boolean stopped = false;
boolean showStatistics = true;
boolean showColorScale = true;
int showingLink = -1;

// Font
PFont f;

float g_averageDegree = 0.0;
float g_CC = 0.0;
float g_averageWeight = 0.0;

void setup() {
  size(1280, 720);
  f = createFont("Arial", 18, true);
  // Parameters.setAgingParameter();
  // Parameters.setLDParameter();

  // Initialize the physics
  physics=new VerletPhysics2D();

  // Spawn a new random graph
  net = new Network(width, height);
  physics.setWorldBounds(new Rect(30,30,width-30,height-30));
  
}

void draw() {
  for( int f=0; f < 3; f++) {
    if(!stopped) {
      for( int i=0; i < 1; i++ ) {
        net.updateNetwork();
      }
    }
    physics.update();
  }
  background(Parameters.background_c);

  // Display all points
  if( showingLink >= 0 ) {
    net.showOne(showingLink);
  } else {
    net.showAll();
  }
  
  if( writing ) {
    PrintWriter writer = createWriter("net_proc.edg");
    net.Print(writer);
    writing = false;
  }

  if( showStatistics ) {
    displayStatistics();
  }

  if( showColorScale ) {
    displayColorScale();
  }

  // saveFrame("frames/####.tif");
}

void displayStatistics() {
  // calculate Stylized facts
  if( frameCount % 9 == 0 ) {
    g_averageDegree = net.calcAverageDegree();
    g_CC = net.calcCC();
    g_averageWeight = net.calcAverageWeight();
  }

  // Print
  fill(255,120,255);
  textFont(f);
  textAlign(LEFT,TOP);
  String time = String.valueOf( net.time_step );
  text("t = " + time + "\n<k> = " + g_averageDegree + "\nCC = " + g_CC + "\n<w> = " + g_averageWeight,10,20);
}

void displayColorScale() {
  color c0 = Parameters.link_colors[0];
  color c1 = Parameters.link_colors[1];
  color c2 = Parameters.link_colors[2];
  color colors[] = {c0, lerpColor(c0,c1,0.5), c1, lerpColor(c1,c2,0.5), c2};
  String keys[] = {"0", "", String.valueOf(Parameters.link_mid_weight), "", String.valueOf(Parameters.link_mid_weight*2)};
  int x = width-30;
  int d = 20;
  int y = 10;
  int dy = 2;
  textAlign(RIGHT,TOP);
  noStroke();
  for( int i=0; i<5; i++) {
    fill(colors[4-i]);
    rect(x, y+(d+dy)*i, d, d);
    text(keys[4-i], x, y+(d+dy)*i);
  }
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
    if( showingLink >= net.m_links.size() ) {
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
    showingLink = net.m_links.size() - 10; 
  }
  else if (key == 't') {
    showStatistics = !showStatistics;
  }
  else if (key == 'c') {
    showColorScale = !showColorScale;
  }
  else if (key == 'p') {
    saveFrame("snapshot.tif");
    println("snapshot is saved");
  }
}