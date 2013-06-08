Animation animation;

// import ddf.minim.*;
import java.util.Map;
import java.util.Vector;

GameState game_state = new GameState();
HashMap<String, Scene> scenes = new HashMap<String, Scene>();
HashMap<String, Sprite> sprites = new HashMap<String, Sprite>();
Avatar avatar;
Animation walk; 

/* AudioPlayer player;
 Minim minim; */

void setup() {

  size(480, 320);
  // size(800,600);
  frameRate(25);
  orientation(LANDSCAPE);

  initDimensions();
  createScenes();
  walk = new Animation("walk", 20); 
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
  avatar = new Avatar(walk, av_x, av_y, d_x, d_y, scale, av_width);
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
        Animation shot = new Animation("shot", 20);
        avatar.setAnimation(shot);
        avatar.animateOnce();
        avatar.stopMove();
        avatar.move(-50.0,-50.0);
        game_state.blocked = 10000;
    }
    else if (mousePressed) {
      if (avatar.isRightFrom(mouseX)) {
        avatar.startAnim(1);
        game_state.blocked = avatar.getCount();
      } 
      else if (avatar.isLeftFrom(mouseX)) {
        game_state.cur_text = "There is no way back.";
        game_state.text_time = 30;
      }
    }
  } 
  else {
    game_state.blocked--;
  }

  // Control scene change.
  if (!avatar.isRightFrom(win_width - scenes.get(game_state.cur_scene).getRightBorder())) {
    setScene(nextScene(game_state.cur_scene));
  }
}

void displayScene() {
  background(255, 255, 255);
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

