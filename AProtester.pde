Animation animation;

// import ddf.minim.*;
import java.util.Map;
import java.util.Vector;

GameState game_state = new GameState();
Vector<Scene> scenes = new Vector<Scene>();
Vector<Bystander> bystanders = new Vector<Bystander>();
Vector<BystanderData> bystanders_data = new Vector<BystanderData>();
Avatar avatar;
Animation walk;
Animation walkw;
boolean sound;
PImage sound_im;
PImage no_sound;

/* AudioPlayer player;
 Minim minim; */

void setup() {

  size(480, 320);
  // size(800, 600);
  frameRate(25);
  orientation(LANDSCAPE);

  initialize();
  game_state.scene_type = HOME;
  game_state.cur_scene = 0;
  setScene();

  /* minim = new Minim(this);
   player = minim.loadFile("bg_music.mp3", 2048);
   player.play(); */
}

void draw() {
  // Display objects.
  if (game_state.dont_draw <= 0) {
    displayScene();
    displaySprites();
    tint(255, 255);
    avatar.display();
    displayText();
    if (sound)
      image(no_sound, win_x, win_height + win_y - Math.round(50 * ratio), Math.round(50 * ratio), Math.round(50 * ratio));
    else
      image(sound_im, win_x, win_height + win_y - Math.round(50 * ratio), Math.round(50 * ratio), Math.round(50 * ratio));    
  } else {
    --game_state.dont_draw;
  }
  reactToEvents();
  controlFading();
  
  game_state.frame++;
}

void reactToEvents() {
  // React to input / event
  if (game_state.blocked <= 0) {
    if (game_state.cur_scene == SHOT_SCENE && avatar.isLeftFrom(Math.round(win_width * 6.0 / 8.0) + win_x)) {
      setUpTheShot();
    } else if (game_state.cur_scene == FALL_SCENE && avatar.isLeftFrom(Math.round(win_width * 1.5 / 8.0) + win_x)) {
      setUpTheFall();
    } else if (!avatar.isRightFrom(win_width - scenes.get(game_state.cur_scene).getRightBorder())) {// Control scene change.
      game_state.to_change = SECOND;
      game_state.blocked = SECOND * 2;
    } else if (mousePressed) {
      reactToMouse();
    }
  } else {
    game_state.blocked--;

    if (game_state.to_mist > 0) {
      fillWithWhite();
      game_state.to_mist--;
      if (game_state.to_mist == 0) {
        lightUp();
      }
    }
    
    if (game_state.to_end-- > 0) {
      showEnd();
    }
  }
}

void mouseClicked() {
  if (mouseX > win_x && mouseX < (win_x + Math.round(50.0 * ratio)) && mouseY < win_height + win_y && mouseY  > win_height + win_y - Math.round(50.0 * ratio)) {
    sound = !sound;
  }  
}

void reactToMouse() {
  if (avatar.isRightFrom(mouseX)) {
    avatar.startAnim(1);
    game_state.blocked = avatar.getCount();
  } else if (avatar.isLeftFrom(mouseX) && game_state.text_time <= 0) {
    game_state.cur_text = texts.get(game_state.scene_type - 1).get(0);
    if (texts.get(game_state.scene_type - 1).size() > 1)
      texts.get(game_state.scene_type - 1).remove(0);
    game_state.text_time = SECOND;
  }
}

