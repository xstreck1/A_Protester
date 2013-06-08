Animation animation;

// import ddf.minim.*;
import java.util.Map;
import java.util.Vector;

GameState game_state = new GameState();
HashMap<String, Scene> scenes = new HashMap<String, Scene>();
HashMap<String, Sprite> sprites = new HashMap<String,Sprite>();
Avatar avatar;

/* AudioPlayer player;
Minim minim; */

void setup() {
  
  size(480,320);
  // size(800,600);
  frameRate(25);
  // orientation(LANDSCAPE);
  
  initDimensions();
  createScenes();
  setScene(DOOR_SCENE);
  
  /* minim = new Minim(this);
  player = minim.loadFile("bg_music.mp3", 2048);
  player.play(); */
}

void setupFont() {
  PFont text_font;
  text_font = loadFont("text_font.vlw");
  textFont(text_font);
}

void setScene(String name) {
  game_state.cur_scene = name;
  float scale = scenes.get(name).scale;
  float av_width = AVATAR_WIDHT * scale;
  float av_x = scenes.get(name).getLeftBorder() + ((av_width - PURPOSED_WIDTH * scale) / 2);
  float av_y = -scenes.get(name).floor + (PURPOSED_HEIGHT) * (1.0 - scale) + AVATAR_UP * scale; // Adjust to uplift of the sprite, the floor height and scaling of the picture w.r.t. the original assumption.
  float d_x = WIDTH_PER_STEP * scale * PURPOSED_WIDTH / 100.0;
  float d_y = 0.0;
  avatar = new Avatar("walk", 20,  av_x, av_y, d_x, d_y, av_width, scale);
}

void draw() {
  // Display objects.
  displayScene();
  displayText();
  displaySprites();
  avatar.display();

  // React to input / event
  if (game_state.blocked <= 0) {
    if (game_state.cur_scene.equals(CLIMB_SCENE) && avatar.isLeftFrom(win_width/2 + win_x)) {
        avatar.setAnimation("shot", 20);
        avatar.animateOnce();
        avatar.stopMove();
        avatar.move(-50.0,-50.0);
        game_state.blocked = 10000;
    }
    else if (mousePressed) {
      if (avatar.isRightFrom(mouseX)) {
        avatar.startAnim(1);
        game_state.blocked = avatar.getCount();
      } else if (avatar.isLeftFrom(mouseX)) {
        game_state.cur_text = "There is no way back.";
        game_state.text_time = 30;
      }
    }
  } else {
    game_state.blocked--;
  }
  
  // Control scene change.
  if (!avatar.isRightFrom(win_width - scenes.get(game_state.cur_scene).getRightBorder())) {
    setScene(nextScene(game_state.cur_scene));  
  }
}

void displayScene() {
  background(255,255,255);
  image(scenes.get(game_state.cur_scene).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  if (game_state.text_time > 0) {
    game_state.text_time--;
    textSize(font_size);
    float text_width = textWidth(game_state.cur_text);
    float x_coord = (win_width - text_width) / 2 + win_x;
    text(game_state.cur_text, x_coord, text_y); 
  }
}

void displaySprites() {
  for (Map.Entry sprite: sprites.entrySet()) {
      ((Sprite) sprite.getValue()).display();
  }
}
// Sprite animation states
final int NONE = 1;
final int WALK = 2;

// Scene states
final int DOOR = 101;
final int WALL = 102;

public class GameState {
  int blocked = 0;
  String cur_scene = "";
  String cur_text;
  int text_time = 0;
};

final int PURPOSED_WIDTH = 480;
final int PURPOSED_HEIGHT = 320;

final float AVATAR_UP = 52.0;
final float AVATAR_WIDHT = 30.0;
int win_width = 0;
int win_height = 0;
int win_x = 0;
int win_y = 0;
float ratio = 0.0;

final int PURPOSED_FONT_SIZE = 32;
int font_size = 0;
final int PURPOSED_TEXT_LINE = 50;
int text_y = 0;

void initDimensions () {
  setWindow();
}

void setWindow() {
  if ((float) width / (float) height < (float) PURPOSED_WIDTH / (float) PURPOSED_HEIGHT) {
    ratio = (float) width / (float) PURPOSED_WIDTH;
    win_width = width;
    win_height = Math.round(PURPOSED_HEIGHT * ratio);
    win_y = (height - win_height) / 2;
  } else {
    ratio = (float) height / (float) PURPOSED_HEIGHT;
    win_height = height;  
    win_width = Math.round(PURPOSED_WIDTH * ratio);
    win_x = (width - win_width) / 2;
  }
  print (width + " " + height + "\n");
  print (ratio + " " + win_x + " " + win_y + " " + win_width + " " + win_height); 
  text_y = Math.round((float) PURPOSED_TEXT_LINE * ratio) + win_y;
  font_size = Math.round((float) PURPOSED_FONT_SIZE * ratio);
}
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
final String DOOR_SCENE = "Door";
final String WALL_SCENE = "Wall";
final String CLIMB_SCENE = "Climb";

final float WIDTH_PER_STEP = 0.8; // Percents of window per step

void createScenes() {
  scenes.put(DOOR_SCENE, new Scene(0.8, DOOR_SCENE, 10, 30, 50));
  scenes.put(WALL_SCENE, new Scene(0.75, WALL_SCENE, 10, 20, 40));
  scenes.put(CLIMB_SCENE, new Scene(0.82, CLIMB_SCENE, 10, 20, 40));
}

final String nextScene(final String current_scene) {
  if (current_scene.equals(DOOR_SCENE)) {
    return WALL_SCENE;
  } else if (current_scene.equals(WALL_SCENE)) {
    return CLIMB_SCENE;
  } else if (current_scene.equals(CLIMB_SCENE)) {
    return DOOR_SCENE;
  } else {
    return "";
  }
}

