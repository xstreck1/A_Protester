Animation animation;

import java.util.Map;

PImage bg_img;

int blocked = 0;
PFont text_font;
HashMap<Integer,Integer> animations = new HashMap<Integer,Integer>();

// Scene states
float xpos = 0;
float ypos = 0;
int scene = 0;
int sprite_anim = 0;

void setup() {
  size(480,320);
  frameRate(25);
  orientation(LANDSCAPE);
  
  initDimensions();
  ypos = height / 4 + 30;
  bg_img = loadImage("door.png");
  animation = new Animation("walk", 20);
  text_font = createFont("Serif", 24);
  textFont(text_font);
}

void draw() {

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

void animateBG(Integer bg_num) {
  text("It is happening out there.", 40, 40); 
}

void animate() {
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

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
  
  void displayFirst(float xpos, float ypos) {
    image(images[0], xpos, ypos);
  }
    
}
