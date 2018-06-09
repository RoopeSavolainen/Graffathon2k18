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
  
  colorMode(HSB, 360.0, 1.0, 1.0);
  
  ml = Moonlander.initWithSoundtrack(this, "The_Polish_Ambassador_-_09_-_Fax_Travel.mp3", 120, 4);
  ml.start();
  
  white = loadShader("White.glsl");
  chroma = loadShader("Chroma.glsl");
  
  frame = createGraphics(w, h, P3D);
}

void draw() {
  ml.update();
  
  int scene = (int)ml.getValue("scene");
  whiteout = (float)ml.getValue("whiteout");
  chroma_intens = (float)ml.getValue("chroma");
  
  frame.beginDraw();
  frame.translate(width/2.0, height/2.0);
  frame.scale(height/720.0);
  
  switch(scene) {
    case 1:
      scene1();
      break;
    case 2:
      scene2();
      break;
  }
  frame.endDraw();
  
  set_shader_params();
  
  if (chroma_intens >= 0.0) {
    frame.shader(chroma);
    frame.image(frame.get(), 0, 0);
  }
  
  float blurring = (float)ml.getValue("blurring");
  if (blurring >= 0.0) {
    frame.filter(BLUR, blurring);
  }
  
  if (whiteout >= 0.0) {
    frame.shader(white);
  }
  image(frame.get(), 0, 0);
}

void set_shader_params() {
  white.set("whiteout_r", 1.0);
  white.set("whiteout_g", 1.0);
  white.set("whiteout_b", 1.0);
  white.set("whiteout", whiteout);
  
  chroma.set("chroma", chroma_intens);
}

void scene1() {
  float pulse = (float)ml.getValue("pulse") * 240;
  frame.background(255);
  frame.noFill();
  frame.stroke(0, 0, 1);
  float weight = map((float)ml.getValue("opening"), 0.0, 1.0, 48.0, 720);
  frame.strokeWeight(weight);
  frame.bezier(-680, 0, -120, -pulse, 120, pulse, 680, 0);
}

void scene2() {
  frame.background(0);
}
