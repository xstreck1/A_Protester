import java.util.ArrayList;

// Class for animating a sequence of GIFs
// Based on an Example Animated Sprite (Shifty + Teddy) by James Paterson. 
class Animation {
  PImage[] images;
  int image_count;
  
  Animation(String _name, int _image_count) {
    image_count = _image_count;
    images = new PImage[_image_count]; 
 
     for (int i = 0; i < image_count; i++) {
      String filename = _name + nf(i, 2) + ".png";
      images[i] = loadImage(filename);
    }
  }

  void display(int frame, float xpos, float ypos, int my_width, int my_height) {
    // println(xpos + " " + ypos + " " + my_width + " " + my_height);
    image(images[frame], xpos, ypos, my_width, my_height); 
  }
  
  int getWidth() {
    return images[0].width;
  }
  
  int getHeight() {
    return images[0].height;
  }
  
  int getCount() {
    return image_count;
  }
};

class Sprite {
  int frame;
  float x;
  float y;
  float d_x;
  float d_y;
  int my_width;
  int my_height;
  float scale;
  int animation_steps;
  Animation animation;
  
  void display() {
    if (animation_steps > 0) {
      animation_steps--;
      frame = (frame + 1) % animation.getCount();
      x += d_x;
      y += d_y;
    } 
    animation.display(frame,x,y,my_width, my_height);
  }
  
  Sprite(Animation _animation, float _x, float _y,  float _d_x, float _d_y, float _scale) {
    animation = _animation;
    frame = 0;
    x = _x * ratio + win_x;
    y = _y * ratio + win_y;
    d_x = _d_x * ratio;
    d_y = _d_y * ratio;
    scale = _scale * ratio * 10;
    my_width = Math.round(animation.getWidth() * scale);
    my_height = Math.round(animation.getHeight() * scale);
  }
  
  void setAnimation(Animation _animation) {
    animation = _animation;
  }
  
  void startAnim(int iterations) {
    frame = 0;
    animation_steps = iterations * getCount();
  }
  
  void animateOnce() {
    frame = 0;
    animation_steps = getCount() - 1;
  }
  
  int getCount() {
    return animation.getCount();
  }
  
  void stopAnim() {
    animation_steps = 0;
  }
  
  void reset() {
    frame = 0;
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
  
  float getWidth() {
    return (animation.getWidth() * scale);
  }
  
  int getFrame() {
    return frame;
  }
};

class Avatar extends Sprite {
  float av_width;
  
  Avatar(Animation animation, float _x, float _y,  float _d_x, float _d_y, float _scale, float _av_width) {
    super(animation, _x, _y, _d_x, _d_y, _scale);
    av_width = _av_width;
  }
  
  void move(float _x, float _y) {
    x += _x * scale;
    y += _y * scale;
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

class Bystander extends Sprite {
  BystanderData my_data;
  
  Bystander(BystanderData _my_data, Animation animation, float _x, float _y,  float _d_x, float _d_y, float _scale) {
    super(animation, _x, _y, _d_x, _d_y, _scale);
    my_data = _my_data;
  }
  
  void display() {
    tint(my_data.tint_r, my_data.tint_g, my_data.tint_b);
    super.display();
  }
};

class BystanderData {
  int tint_r;
  int tint_g;
  int tint_b;
  float scale;
  
  BystanderData(int _tint_r, int _tint_g, int _tint_b, float _scale) {
    tint_r = _tint_r;
    tint_g = _tint_g;
    tint_b = _tint_b;
    scale = _scale;
  }
};
