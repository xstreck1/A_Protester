// Class for animating a sequence of GIFs
// Based on an Example Animated Sprite (Shifty + Teddy) by James Paterson. 
class Animation {
  PImage[] images;
  int image_count;
  int frame;
  float scale;
  int my_width;
  int my_height;
  
  Animation(String _name, int _image_count, float _scale) {
    image_count = _image_count;
    images = new PImage[_image_count];
    scale = _scale;
    my_width = Math.round(PURPOSED_WIDTH * scale * ratio);
    my_height = Math.round(PURPOSED_HEIGHT * scale * ratio);

    setAnimation(_name, _image_count);
  }
  
  void setAnimation(String _name, int _image_count) {
    image_count = _image_count;
    images = new PImage[_image_count]; 
 
     for (int i = 0; i < image_count; i++) {
      String filename = _name + nf(i, 2) + ".png";
      images[i] = loadImage(filename);
    }   
  }

  void display(float xpos, float ypos, boolean animate) {
    if (animate) {
      frame = (frame+1) % image_count;
    }
    image(images[frame], xpos, ypos, my_width, my_height); 
  }
  
  int getWidth() {
    return my_width;
  }
  
  int getCount() {
    return image_count;
  }
};

class Sprite extends Animation {
  float x;
  float y;
  float d_x;
  float d_y;
  int animation_steps;
  
  void display() {
    if (animation_steps > 0) {
      display(x,y,true);
      animation_steps--;
      x += d_x;
      y += d_y;
    } else if (animation_steps == 0) {
      display(x,y,false);
    } else {
      display(x,y,true);
    }
  }
  
  Sprite(String _name, int _count, float _x, float _y,  float _d_x, float _d_y, float _scale) {
    super(_name, _count, _scale);
    x = _x * ratio + win_x;
    y = _y * ratio + win_y;
    d_x = _d_x * ratio;
    d_y = _d_y * ratio;
  }
  
  void startAnim(int iterations) {
    frame = 0;
    animation_steps = iterations * image_count;
  }
  
  void animateOnce() {
    frame = 0;
    animation_steps = image_count - 1;
  }
  
  void stopAnim() {
    animation_steps = 0;
  }
  
  void stopMove() {
    d_x = d_y = 0;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
};

class Avatar extends Sprite {
  float av_width;
  
  Avatar(String _image_prefix, int _count, float _x, float _y,  float _d_x, float _d_y, float _av_width, float _scale) {
    super(_image_prefix, _count, _x, _y, _d_x, _d_y, _scale);
    av_width = _av_width;
  }
  
  void move(float _x, float _y) {
    x += _x * scale * ratio;
    y += _y * scale * ratio;
  }
  
  boolean isRightFrom(int _x) {
    return (_x > (getWidth() + av_width) / 2 + x );      
  }
  
  boolean isLeftFrom(int _x) {
    return (_x < (getWidth() - av_width) / 2 + x );      
  }
  
  int getAvWidth() {
    return Math.round(av_width);
  }
};

public class Scene {
  float scale;
  PImage background;
  int floor;
  int left_border;
  int right_border;
  
  Scene(float _scale, String _bg_image, int _floor, int _left_border, int _right_border) {
    scale = _scale;
    background = loadImage(_bg_image + ".png");
    floor = _floor;
    left_border = _left_border;
    right_border = _right_border;
  }
  
  int getRightBorder() {
    return right_border;
  }
  
  int getLeftBorder() {
    return right_border;
  }
};
