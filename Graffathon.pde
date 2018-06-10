import moonlander.library.*;

import ddf.minim.*;

static boolean release = true;

Moonlander ml;
PGraphics frame, buffer;

int w = 1280;
int h = 720;

float whiteout;
float chroma_intens;
float bluramount;
int neon_intens;
float display_noise;

static int particlenum = 64;
static int rainnum = 32;

float[] dropx = new float[rainnum];
PVector[] dropdir = new PVector[rainnum];
float[] dropcol = new float[rainnum];
float[] droplen = new float[rainnum];

PShader post, neon, glitch;
PShape[] platonics = new PShape[5];

PVector[] particles = new PVector[particlenum];
PVector[] particle_v = new PVector[particlenum];

PFont f;

void settings() {
  if (release) {
    fullScreen(P2D);
  }
  else {
    size(w, h, P2D);
  }
}

void setup() {
  noCursor();
  frameRate(60);
  
  randomSeed(1337387);
  
  for (int i = 0; i < particlenum; i++) {
    float x = random(-640.0, 640.0);
    float y = random(-640.0, 640.0);
    float dx = random(-5.0, 5.0);
    float dy = random(-5.0, 5.0);
    particles[i] = new PVector(x, y);
    particle_v[i] = new PVector(dx, dy);
  }
  
  for (int i = 0; i < rainnum; i++) {
    float x = random(-720.0, 720.0);
    float dx = random(-10.0, 10.0);
    float dy = random(30.0, 100.0);
    float hue = random(0.0, 360.0);
    float len = random(50.0, 100.0);
    
    dropx[i] = x;
    dropdir[i] = new PVector(dx,dy);
    dropcol[i] = hue;
    droplen[i] = len;
  }
  
  ml = Moonlander.initWithSoundtrack(this, "The_Polish_Ambassador_-_09_-_Fax_Travel.mp3", 120, 4);
  ml.start();
  
  post = loadShader("Post.glsl");
  neon = loadShader("Neon.glsl");
  glitch = loadShader("Glitch.glsl");
  
  frame = createGraphics(width, height, P3D);
  buffer = createGraphics(w, h, P3D);
  
  f = loadFont("YanoneKaffeesatz-Regular-48.vlw");
  
  for (int i = 1; i <= 5; i++) {
    String name = "plato" + i + ".obj";
    PShape model = loadShape(name);
    platonics[i-1] = model;
  }
}

void draw() {
  ml.update();
  frame.colorMode(HSB, 360.0, 100.0, 100.0);
  
  int scene = (int)ml.getValue("scene");
  whiteout = (float)ml.getValue("whiteout");
  chroma_intens = (float)ml.getValue("chroma");
  bluramount = (float)ml.getValue("blurring");
  neon_intens = (int)ml.getValue("neon");
  display_noise = (float)ml.getValue("disp_noise");
  
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
      particles();
      break;
    case 4:
      platon();
      break;
    case 5:
      neon_rain();
      break;
    case 6:
      particles();
      break;
    case 7:
      platon();
      break;
    case 8:
      growing_terrain();
      break;
    case 9:
      platon();
      break;
    case 10:
      neon_rain();
      break;
    case 11:
      platon();
      break;
    case 12:
      exit();
      break;
  }
  frame.endDraw();
  
  set_shader_params();
  
  PImage i = frame.get();
  
  buffer.beginDraw();
  buffer.image(i, 0.0, 0.0, w, h);
    
  if (chroma_intens > 0.0 || whiteout > 0.0 || bluramount > 0.0) {
    buffer.shader(post);
    buffer.image(buffer.get(), 0, 0);
  }
  
  if (neon_intens > 0.0) {
    buffer.shader(neon);
    buffer.image(buffer.get(), 0, 0);
  }
  
  if (display_noise > 0.0) {
    buffer.shader(glitch);
    buffer.image(buffer.get(), 0, 0);
  }
  
  buffer.endDraw();
  
  image(buffer.get(), 0, 0, width, height);
}

void set_shader_params() {
  post.set("whiteout", whiteout);  
  post.set("chroma", chroma_intens);
  post.set("blur", bluramount);
  
  if (display_noise > 0.0) {
    float start = map(noise(display_noise), 0.0, 1.0, 0.0, 0.99);
    float str = map(noise(display_noise+200), 0.0, 1.0, -0.1, 0.1);
    float len = map(noise(display_noise+400), 0.0, 1.0, 0.01, 0.1);
    len = constrain(len, 0.0, 1.0-start);
    glitch.set("glitch_row", start);
    glitch.set("glitch_str", str);
    glitch.set("glitch_len", len);
  }
  else {
    post.set("glitch_row", -1.0);
    post.set("glitch_str", 0.0);
    post.set("glitch_len", 0.0);
  }
  
  neon.set("strength", neon_intens);
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
  
  float scene_rot = (float)ml.getValue("scene_rot");
  float title_alpha = (float)ml.getValue("title_alpha");
  
  int credits = (int)ml.getValue("credits_idx");
  
  frame.textFont(f);
  frame.textSize(48.0);
  frame.fill(0.0, 0.0, 100.0, title_alpha);
  frame.text("Platonic Love", -96.0, -100.0, 360.0);
  
  frame.textSize(8.0);
  frame.fill(0.0, 0.0, 100.0, 255.0);
  switch(credits) {
    case 3:
      frame.text("Music:", -80.0, 20.0, 540.0);
      frame.text("Fax Travel by The Polish Ambassador", -80, 30.0, 540.0);
    case 2:
      frame.text("Greets go to everyone at Graffathon 2018", -80.0, 0.0, 540.0);
    case 1:
      frame.text("A production by ruuben", -80.0, -20.0, 540.0);
      break;
  }
  
  float zoom = (float)ml.getValue("platon_zoom");
  frame.translate(360 * zoom, 0.0);
  frame.scale(zoom + 1.0);
  
  frame.stroke(10.0, 60, 80, floor);
  frame.strokeWeight(5.0);
  
  frame.translate(0.0, 0.0, 450);
  frame.rotateY(scene_rot);
  frame.translate(0.0, 0.0, -450);
  
  frame.translate(0.0, 40.0, 400.0);
  for (int i = 0; i <= 10; i++) {
    frame.line(-50 + 10*i, 0.0, 0.0,        -50 + 10*i, 0.0, 100.0);
    frame.line(-50.0,      0.0, 0.0 + 10*i, 50.0,       0.0, 0 + 10*i);
  }
  
  if (platonic >= 1 && platonic <= 5) {
    frame.pushMatrix();
    
    frame.translate(0.0, -50.0, 50.0);
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

void particles() {
  frame.background(255.0);
  frame.strokeWeight(3.0);
  frame.stroke(0.0, 0.0, 25.0, 255.0);
  frame.fill(0.0, 0.0, 10.0, 255.0);
  
  float t = (float)ml.getValue("particle_t");
  float noise = (float)ml.getValue("particle_noise");
  
  PVector[] displacement = new PVector[particlenum];
  for (int i = 0; i < particlenum; i++) {
    if (noise > 0.0) {
      float x = noise((float)i, 0.0, t) * noise;
      float y = noise((float)i, 10.0, t) * noise;
      displacement[i] = new PVector(x,y);
    }
    else {
      displacement[i] = new PVector(0.0, 0.0);
    }
  }
  
  for (int i = 0; i < particlenum; i++) {
    frame.ellipse(particles[i].x + t*particle_v[i].x + displacement[i].x, particles[i].y + t*particle_v[i].y + displacement[i].y, 10, 10);
  }
  
  frame.strokeWeight(2.0);
  for (int i = 0; i < particlenum; i++) {
    for (int j = i; j < particlenum; j++) {
      PVector pos1 = new PVector(particles[i].x + t*particle_v[i].x + displacement[i].x, particles[i].y + t*particle_v[i].y + displacement[i].y);
      PVector pos2 = new PVector(particles[j].x + t*particle_v[j].x + displacement[j].x, particles[j].y + t*particle_v[j].y + displacement[j].y);
      float distx = pos1.x - pos2.x;
      float disty = pos1.y - pos2.y;
      float dist = sqrt(distx*distx + disty*disty);
      float a = map(255.0 / dist, 1.0, 3.0, 0.0, 255.0);
      frame.stroke(0.0, 0.0, 25.0, a);
      frame.line(pos1.x, pos1.y, pos2.x, pos2.y);
    }
  }
}

void neon_rain() {
  frame.background(0.0);
  frame.strokeWeight(1.5);
  
  float t = (float)ml.getValue("drop_t");
  
  for (int i = 0; i < rainnum; i++) {
    frame.stroke(dropcol[i], 60.0, 100.0, 255.0);
    float x1 = dropx[i] + t*dropdir[i].x;
    float y1 = -360 + t*dropdir[i].y - i*dropdir[i].y;
    
    float x2 = x1 - droplen[i]*dropdir[i].x;
    float y2 = y1 - droplen[i]*dropdir[i].y;
    
    frame.line(x1, y1, x2, y2);
  }
}

void growing_terrain() {
  float t = (float)ml.getValue("terrain_t");
  float ampl = (float)ml.getValue("terrain_ampl");
  
  frame.background(0.0);
  frame.stroke(10.0, 60, 80, 16.0);
  frame.strokeWeight(5.0);
  frame.noFill();
  
  frame.pushMatrix();
  frame.translate(0.0, 100.0, 0.0);
  frame.rotateY(PI/8);
  frame.rotateX(-PI/8);
  frame.translate(0.0, 0.0, 0.0);
  
  float h;
  for (int i = 0; i < 20; i++) {
    frame.beginShape(QUAD_STRIP);
    for (int j = 0; j <= 20; j++) {
      h = -1.0 * noise(i, j, t) * ampl;
      frame.vertex(-400.0 + 40*i, h, -400.0 + 40*j);
      h = -1.0 * noise(i+1.0, j, t) * ampl;
      frame.vertex(-400.0 + 40*i + 40.0, h, -400.0+40*j);
    }
    frame.endShape();
  }
  frame.popMatrix();
}
