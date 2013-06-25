import java.util.Map;
import java.util.ArrayList;

GameState game_state = new GameState();
ArrayList<Scene> scenes;
ArrayList<Bystander> bystanders;
ArrayList<BystanderData> bystanders_data;
ArrayList< ArrayList< String > > texts;

Avatar avatar;
Animation walk;
Animation walkw;

boolean sound;
PImage sound_im;
PImage no_sound;

void setup() {
  size(480, 320); 
  frameRate(25);
  orientation(LANDSCAPE);
  setupFont();
}

void draw() {
  if (loaded == 0) {
    drawLoading();
    loaded++;
  } else if (loaded == 1) {
    initialize();
    game_state.scene_type = HOME;
    game_state.cur_scene = 0;
    setScene();
    loaded++;
  } else {
    // Display objects (during normal workflow).
    if (game_state.dont_draw <= 0) {
      displayScene();
      displaySprites();
      
      tint(255, 255);
      avatar.display();
      
      displayText();
      if (!sound)
        image(no_sound, win_x, win_height + win_y - sound_ico_size, sound_ico_size, sound_ico_size);
      else
        image(sound_im, win_x, win_height + win_y - sound_ico_size, sound_ico_size, sound_ico_size);
      
      // Cover the overlaping areas with black 
      if (win_x != 0) {
        fill(0,255);
        rect(0,0, win_x,win_height);
        rect(win_x + win_width, 0, win_x,win_height);
      } else if (win_y != 0) {
        fill(0,255);
        rect(0,0, win_width,win_y);    
        rect(0,win_y + win_height, win_width,win_y); 
      }
    } else {
      --game_state.dont_draw;
    }
    reactToEvents();
    controlFading();
    
    game_state.frame++;
  }
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
  if (mouseX > win_x && mouseX < (win_x + sound_ico_size) && mouseY < win_height + win_y && mouseY  > win_height + win_y - sound_ico_size) {
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

