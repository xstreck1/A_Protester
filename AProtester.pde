Animation animation;

import java.util.Map;
import java.util.Vector;

GameState game_state = new GameState();
HashMap<String, Scene> scenes = new HashMap<String, Scene>();
HashMap<String, Sprite> sprites = new HashMap<String,Sprite>();
Avatar avatar;

void setup() {
  size(480,320);
  frameRate(25);
  // orientation(LANDSCAPE);
  
  initDimensions();
  createScenes();
  setScene(DOOR_SCENE);
}

void setScene(String name) {
  game_state.cur_scene = name;
  float scale = scenes.get(name).scale;
  avatar = new Avatar("walk", 20, 10.0 * scale , -scenes.get(name).floor + (win_height) * (1.0 - scale) + AVATAR_UP * scale, WIDTH_PER_STEP * scale * win_width / 100.0, 0.0, scale);  
}

void draw() {
  displayScene();
  displayText();
  tint(255, 220);
  displaySprites();
  avatar.display();

  if (game_state.blocked-- <= 0) {
    if (mousePressed) {
      if (avatar.isRightFrom(mouseX)) {
        avatar.startAnim(1);
        game_state.blocked = avatar.getCount();
      }
    }
  } 
}

void displayScene() {
  image(scenes.get(DOOR_SCENE).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  
}

void displaySprites() {
  for (Map.Entry sprite: sprites.entrySet()) {
      ((Sprite) sprite.getValue()).display();
  }
}
