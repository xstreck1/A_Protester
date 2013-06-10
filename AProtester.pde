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

void setup() {

  size(480, 320);
  // size(800, 600);
  frameRate(25);
  // orientation(LANDSCAPE);

  initialize();
  game_state.scene_type = HOME;
  game_state.cur_scene = 0;
  setScene();
}

void draw() {
  // Display objects (during normal workflow).
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
    
    // Cover the overlaping areas with black 
    fill(0,255);
    rect(0,0, win_x,win_height);
    rect(0,0, win_width,win_y);    
    rect(win_x + win_width, 0, win_x,win_height);
    rect(0,win_y + win_height, win_width,win_y);   
  } else {
    --game_state.dont_draw;
  }
  reactToEvents();
  controlFading();
  
  game_state.frame++;
}

// React to environment, if the workflow is not blocked.
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
      // React to mouse only if nothing else is scheduled.
      reactToMouse();
    }
  } else {
    game_state.blocked--;
    // Check timed events.
  
    if (game_state.to_mist > 0) {
      // Start filling with smoke (white circles)
      fillWithWhite();
      game_state.to_mist--;
      if (game_state.to_mist == 0) {
        // If the scene is filled, start a new one.
        lightUp();
      }
    }
    
    if (game_state.to_end-- > 0) {
      showEnd();
    }
  }
}

// React to mouse input (button is pressed event).
void reactToMouse() {
  if (mouseX > win_x && mouseX < (win_x + Math.round(50.0 * ratio)) && mouseY < win_height + win_y && mouseY  > win_height + win_y - Math.round(50.0 * ratio)) {
    // Switch the sound
    sound = !sound;
  } else if (avatar.isRightFrom(mouseX)) {
    // Move
    avatar.startAnim(1);
    game_state.blocked = avatar.getCount();
  } else if (avatar.isLeftFrom(mouseX) && game_state.text_time <= 0) {
    // Display text
    game_state.cur_text = texts.get(game_state.scene_type - 1).get(0);
    // Recycle texts.
    if (texts.get(game_state.scene_type - 1).size() > 1)
      texts.get(game_state.scene_type - 1).remove(0);
    game_state.text_time = SECOND;
  }
}

