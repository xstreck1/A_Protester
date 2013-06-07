Animation animation;

import java.util.Map;
import java.util.Vector;

GameState game_state = new GameState();
Vector<Scene> scenes = new Vector<Scene>();
HashMap<String, Sprite> sprites = new HashMap<String,Sprite>();
Avatar avatar;

void setup() {
  size(480,320);
  frameRate(25);
  // orientation(LANDSCAPE);
  
  initDimensions();
  createScenes();
  avatar = new Avatar("walk", 20, 10.0, 100.0, step, 0.0, 1.0);
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
  image(scenes.get(game_state.cur_scene).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  
}

void displaySprites() {
  for (Map.Entry sprite: sprites.entrySet()) {
      ((Sprite) sprite.getValue()).display();
  }
}
