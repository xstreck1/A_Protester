package processing.test.aprotester;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AProtester extends PApplet {

Animation animation1, animation2;

float xpos = 0;
float ypos = -20;
PImage bg_img;

public void setup() {
 
  bg_img = loadImage("wall.png");
  frameRate(25);
  animation1 = new Animation("walk", 20);
}

public void draw() { 
  background(bg_img);
  tint(255, 230);
  animation1.display(xpos,ypos);
  if (mousePressed) {
    if (mouseX > xpos + 250)
      xpos += 3;
    else if (mouseX < xpos + 230)
      xpos -= 3;
  }
}

// Class for animating a sequence of GIFs

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
}

  public int sketchWidth() { return 480; }
  public int sketchHeight() { return 320; }
}
