import moonlander.library.*;

import ddf.minim.*;

Moonlander ml;
PGraphics frame;
PImage buff;

boolean fullscreen = false;
int w = 640;
int h = 360;

float whiteout;
float chroma_intens;

PShader white, chroma;
PShape[] platonics = new PShape[5];

void settings() {
  if (fullscreen) {
    fullScreen(P2D);
  }
  else {
    size(w, h, P2D);
  }
}

void setup() {
  noCursor();
  frameRate(60);
  
  ml = Moonlander.initWithSoundtrack(this, "The_Polish_Ambassador_-_09_-_Fax_Travel.mp3", 120, 4);
  ml.start();
  
  white = loadShader("White.glsl");
  chroma = loadShader("Chroma.glsl");
  
  frame = createGraphics(w, h, P3D);
  
  for (int i = 1; i <= 5; i++) {
    String name = "plato" + i + ".obj";
    PShape model = loadShape(name);
    platonics[i-1] = model;
  }
}

void draw() {
  ml.update();
  colorMode(HSB, 360.0, 100.0, 100.0);
  
  int scene = (int)ml.getValue("scene");
  whiteout = (float)ml.getValue("whiteout");
  chroma_intens = (float)ml.getValue("chroma");
  
  frame.beginDraw();
  frame.translate(width/2.0, height/2.0);
  frame.scale(height/720.0);
  
  switch(scene) {
    case 1:
      pulssi();
      break;
    case 2:
      platon();
      break;
    case 3:
      visualization();
      break;
  }
  frame.endDraw();
  
  set_shader_params();
  
  image(frame.get(), 0, 0);
  if (chroma_intens >= 0.0) {
    shader(chroma);
    image(get(), 0, 0);
  }
  
  float blurring = (float)ml.getValue("blurring");
  if (blurring >= 0.0) {
    filter(BLUR, blurring);
  }
  
  if (whiteout >= 0.0) {
    shader(white);
    image(get(), 0, 0);
  }
}

void set_shader_params() {
  white.set("whiteout_r", 1.0);
  white.set("whiteout_g", 1.0);
  white.set("whiteout_b", 1.0);
  white.set("whiteout", whiteout);
  
  chroma.set("chroma", chroma_intens);
}

void pulssi() {
  float pulse = (float)ml.getValue("pulse") * 240;
  float pulse_rev = (float)ml.getValue("pulse_rev");
  frame.background(255);
  frame.noFill();
  frame.stroke(0, 0, 1);
  float weight = map((float)ml.getValue("opening"), 0.0, 1.0, 48.0, 720);
  frame.strokeWeight(weight);
  frame.bezier(-680, 0, -120, -pulse * pulse_rev, 120, pulse * pulse_rev, 680, 0);
}

void platon() {
  frame.background(0);
  float floor = (float)ml.getValue("floor");
  float scale = (float)ml.getValue("platon_scale");
  int platonic = (int)ml.getValue("platonic_idx");
  float rotx = (float)ml.getValue("platon_rotx");
  float roty = (float)ml.getValue("platon_roty");
  float rotz = (float)ml.getValue("platon_rotz");
  frame.stroke(10.0, 60, 80, floor);
  frame.strokeWeight(5.0);
  
  frame.translate(0.0, 40.0, 400.0);
  for (int i = 0; i <= 10; i++) {
    frame.line(-50 + 10*i, 0.0, 0.0,        -50 + 10*i, 0.0, 100.0);
    frame.line(-50.0,      0.0, 0.0 + 10*i, 50.0,       0.0, 0 + 10*i);
  }
  
  if (platonic >= 1 && platonic <= 5) {
    frame.pushMatrix();
    
    frame.translate(0.0, -50.0, 0.0);
    frame.resetShader();
    frame.lights();
    frame.pointLight(0.0, 0.0, 100.0, -50.0, -50.0, 50.0);
    
    frame.scale(scale);
    
    frame.rotateY(roty);
    frame.rotateZ(rotz);
    frame.rotateX(rotx);
    
    frame.shape(platonics[platonic-1]);
    frame.noLights();
    frame.popMatrix();
  }  
}

void visualization() {
  
}
