import moonlander.library.*;

import ddf.minim.*;

Moonlander ml;
PGraphics frame;
PImage buff;

boolean fullscreen = false;
int w = 1280;
int h = 720;

PShader post;

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
  
  post = loadShader("PostFrag.glsl");
  
  frame = createGraphics(w, h, P3D);
}

void draw() {
  ml.update();
  
  frame.beginDraw();
  frame.background(128);
  frame.stroke(0, 255, 0);
  frame.strokeWeight(3.0);
  frame.noFill();
  frame.translate(width/2, height/2);
  frame.rotateY(60);
  frame.box(100, 100, 50);
  frame.translate(0, 0, 100);
  
  frame.scale(height/720);
  frame.endDraw();
  buff = frame.get();
  
  set_shader_params();
  shader(post);
  image(buff, 0, 0);
}

void set_shader_params() {
  float whiteout = (float)ml.getValue("whiteout");
  float chroma = (float)ml.getValue("chroma");
  int blur = (int)ml.getValue("blurring");
  
  post.set("whiteout", whiteout);
  post.set("chroma", chroma);
  post.set("blurring", blur);
  
  post.set("whiteout_r", 1.0);
  post.set("whiteout_g", 1.0);
  post.set("whiteout_b", 1.0);
}
