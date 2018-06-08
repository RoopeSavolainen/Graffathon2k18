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
  
  post = loadShader("PostFrag.glsl");//, "PostVert.glsl");
  
  frame = createGraphics(w, h, P3D);
}

void draw() {
  ml.update();
  
  frame.beginDraw();
  frame.background(128);
  frame.stroke(0, 255, 0);
  frame.noFill();
  frame.translate(width/2, height/2);
  frame.box(100, 100, 50);
  frame.translate(0, 0, 100);
  
  frame.scale(height/720);
  frame.endDraw();
  buff = frame.get();
  
  shader(post);
  image(buff, 0, 0);
}

void set_shader_params() {
  float whiteout = (float)ml.getValue("whiteout");
  float chroma = (float)ml.getValue("chroma");
  float blur = (int)ml.getValue("blurring");
  float pixelate = (int)ml.getValue("pixelation");
  
  post.set("whiteout_intensity", whiteout);
  post.set("chromaberr", chroma);
  post.set("blur", blur);
  post.set("pixelate", pixelate);
  
  post.set("whiteout_r", 1.0);
  post.set("whiteout_g", 1.0);
  post.set("whiteout_b", 1.0);
}
