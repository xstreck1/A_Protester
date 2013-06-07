Animation animation;

float xpos = 0;
float ypos = 0;
PImage bg_img;

int blocked = 0;
int current_anim = 0;

void setup() {
  size(480,320);
  ypos = height / 4 + 30;
  orientation(LANDSCAPE);
  bg_img = loadImage("door.png");
  frameRate(25);
  animation = new Animation("walk", 20);
}

void draw() {

  background(bg_img);
  tint(255, 220);
  
  if (blocked == 0) {
    animation.displayFirst(xpos,ypos);
    if (mousePressed) {
      if (mouseX > xpos + 480/8*3) {
        current_anim = 1;
        blocked = 20;
      }
    }
    else 
      current_anim = 0;  
  } else {
    blocked--;
    animate();
  }
}

void animate() {
  switch (current_anim) {
    case 1:
      animation.display(xpos,ypos);
      xpos += 3;
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
