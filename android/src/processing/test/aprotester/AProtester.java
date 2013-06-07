package processing.test.aprotester;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AProtester extends PApplet {

Animation animation;



PImage bg_img;

int blocked = 0;
PFont text_font;
HashMap<Integer,Integer> animations = new HashMap<Integer,Integer>();

// Scene states
float xpos = 0;
float ypos = 0;
int scene = 0;
int sprite_anim = 0;

public void setup() {
 
  frameRate(25);
  orientation(LANDSCAPE);
  
  initDimensions();
  ypos = height / 4 + 30;
  bg_img = loadImage("door.png");
  animation = new Animation("walk", 20);
  text_font = createFont("Serif", 24);
  textFont(text_font);
}

public void draw() {

  background(bg_img);
  tint(255, 220);
  
  for (Map.Entry anim: animations.entrySet()) {
    if ((Integer) anim.getValue() <= 0)
      animations.remove(anim.getKey());
    else
      animateBG((Integer) anim.getKey());
    animations.put((Integer) anim.getKey(), (Integer) anim.getValue() - 1);
  }
  
  if (blocked == 0) {
    animation.displayFirst(xpos,ypos);
    if (mousePressed) {
      if (mouseX > xpos + 480/8*3) {
        sprite_anim = WALK;
        blocked = 20;
      }
      else {
        animations.put(0,30);
      }
    }
    else 
      sprite_anim = NONE;  
  } else {
    blocked--;
    animate();
  }
}

public void animateBG(Integer bg_num) {
  text("It is happening out there.", 40, 40); 
}

public void animate() {
  switch (sprite_anim) {
    case WALK:
      animation.display(xpos,ypos);
      xpos += step;
  }
}

// Class for animating a sequence of GIFs
// Based on an Example Animated Sprite (Shifty + Teddy) by James Paterson. 
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 2) + ".png";
      images[i] = loadImage(filename);
    }
  }

  public void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  public int getWidth() {
    return images[0].width;
  }
  
  public void displayFirst(float xpos, float ypos) {
    image(images[0], xpos, ypos);
  }
    
}
// Sprite animation states
final int NONE = 1;
final int WALK = 2;

// Scene states
final int DOOR = 101;
final int WALL = 102;
final int PURPOSED_WIDTH = 320;
final int PURPOSED_HEIGHT = 480;
int win_width = 0;
int win_height = 0;
float ratio = 0.0f;
float step = 0.0f;

public void initDimensions () {
  if (width / height > PURPOSED_WIDTH / PURPOSED_HEIGHT) {
    ratio = width / PURPOSED_WIDTH;
    win_width = width;
    win_height = Math.round(PURPOSED_HEIGHT * ratio);
  } else {
    ratio = height / PURPOSED_HEIGHT;
    win_height = height;  
    win_width = Math.round(PURPOSED_WIDTH * ratio);
  }
  final float WIDTH_PER_STEP = 0.6f; // Percents of window per step
  step = (float) win_width / 100 * WIDTH_PER_STEP;
  print(step);
}

  public int sketchWidth() { return 480; }
  public int sketchHeight() { return 320; }
}
