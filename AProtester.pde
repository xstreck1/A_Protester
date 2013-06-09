Animation animation;

// import ddf.minim.*;
import java.util.Map;
import java.util.Vector;

GameState game_state = new GameState();
HashMap<String, Scene> scenes = new HashMap<String, Scene>();
HashMap<String, Sprite> sprites = new HashMap<String, Sprite>();
Avatar avatar;
Animation walk;
Animation walkw;
Animation injured;

/* AudioPlayer player;
 Minim minim; */

void setup() {

  size(480, 320);
  // size(800, 600);
  frameRate(25);
  orientation(LANDSCAPE);

  initDimensions();
  createScenes();
  walk = new Animation("walk", 20);
  walkw = new Animation("walkw", 20);
  injured = new Animation("walk",20);
  game_state.cur_scene = DOOR_SCENE;
  setScene();

  /* minim = new Minim(this);
   player = minim.loadFile("bg_music.mp3", 2048);
   player.play(); */
}

void setupFont() {
  PFont text_font;
  text_font = loadFont("text_font.vlw");
  textFont(text_font);
}

void setScene() {
  float scale = scenes.get(game_state.cur_scene).scale;
  float av_width = AVATAR_WIDHT * scale;
  float av_x = scenes.get(game_state.cur_scene).getLeftBorder() + ((av_width - PURPOSED_WIDTH * scale) / 2);
  float av_y = -scenes.get(game_state.cur_scene).floor + (PURPOSED_HEIGHT) * (1.0 - scale) + AVATAR_UP * scale; // Adjust to uplift of the sprite, the floor height and scaling of the picture w.r.t. the original assumption.
  float d_x = WIDTH_PER_STEP * scale * PURPOSED_WIDTH / 100.0;
  float d_y = 0.0;
  if (game_state.scene_type == HOME || game_state.scene_type == WALK) {
    avatar = new Avatar(walk, av_x, av_y, d_x, d_y, scale, av_width);
  } else if (game_state.scene_type == APPROACH) {
    avatar = new Avatar(walkw, av_x, av_y, d_x, d_y, scale, av_width);
  } else {
    avatar = new Avatar(injured, av_x, av_y, d_x, d_y, scale, av_width);
  }
}

void draw() {
  // Display objects.
  if (game_state.dont_draw <= 0) {
    displayScene();
    displayText();
    displaySprites();
    avatar.display();
  } else {
    --game_state.dont_draw;
  }
  reactToEvents();
  controlFading();
}

void reactToEvents() {
  // React to input / event
  if (game_state.blocked <= 0) {
    if (game_state.cur_scene.equals(WALL_SCENE) && avatar.isLeftFrom(win_width/2 + win_x)) {
      setUpTheShot();
    } else if (mousePressed) {
      if (avatar.isRightFrom(mouseX)) {
        avatar.startAnim(1);
        game_state.blocked = avatar.getCount();
      } else if (avatar.isLeftFrom(mouseX)) {
        game_state.cur_text = "There is no way back.";
        game_state.text_time = SECOND ;
      }
    }
    // Control scene change.
    if (!avatar.isRightFrom(win_width - scenes.get(game_state.cur_scene).getRightBorder())) {
      if (game_state.scene_type == HOME) {
        game_state.scene_type = WALK;
      }
      game_state.to_change = SECOND;
      game_state.blocked = SECOND * 2;
    }
  } else {
    game_state.blocked--;
    
    if (game_state.to_mist > 0) {
      fillWithWhite();
      if (game_state.to_mist == 0) {
        fill(MIST_COL,255);
        rect(0,0,win_width + win_x*2,win_height + win_y*2);
        game_state.cur_scene = nextScene(game_state.cur_scene);
        game_state.scene_type = APPROACH;
        setScene();
        game_state.to_visible = SECOND * 6;
        game_state.blocked = SECOND * 6;  
      }
    }
  }  
}

void fillWithWhite() {
  game_state.to_mist--;
  fill(MIST_COL,MIST_ALPHA);
  noStroke();
  float corner_dist = Math.max(win_width + win_x, win_height + win_y) * 2.0;
  int to_fill = Math.round((corner_dist / (SECOND*6)) * Math.max(0,(SECOND*6 - game_state.to_mist)));
  if (to_fill > 0) {
    game_state.dont_draw = 1;
  }
  ellipse(win_width/2 + win_x, win_height + win_y - scenes.get(game_state.cur_scene).getFloor() * ratio, to_fill, to_fill);  
}

void setUpTheShot() {
  Animation shot = new Animation("shot", 20);
  avatar.setAnimation(shot);
  avatar.animateOnce();
  avatar.stopMove();
  avatar.move(-50.0, -50.0);
  game_state.blocked = SECOND * 8;
  game_state.to_mist = SECOND * 8;
}

void controlFading() {
  if (game_state.to_change > 0) {
    fill(0, (255 / SECOND) * (SECOND - game_state.to_change));
    rect(win_x, win_y, win_width, win_height);
    if (--game_state.to_change <= 0) {
      game_state.cur_scene = nextScene(game_state.cur_scene);
      setScene();
      game_state.to_begin = SECOND * 2;
    }
  }
  if (--game_state.to_begin > 0) {
    fill(0, (255 / SECOND) * (game_state.to_begin));
    rect(win_x, win_y, win_width, win_height);
  } else {
    game_state.to_begin = 0;
  }
  if (game_state.to_visible > 0) {
    int alpha = Math.min(255, Math.round((255.0 / (SECOND * 3.0)) * (game_state.to_visible)));
    fill(MIST_COL, alpha);
    rect(0,0,win_width + win_x*2,win_height + win_y*2);
    game_state.to_visible--;
  }
}

void displayScene() {
  background(0, 0, 0);
  image(scenes.get(game_state.cur_scene).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  if (game_state.text_time > 0) {
    game_state.text_time--;
    textSize(font_size);
    fill(255,255);
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

