import java.util.ArrayList;

final int SHOT_SCENE = 6;
final int FALL_SCENE = 10;

final float WIDTH_PER_STEP = 0.8; // Percents of window per ste

void createScenes() {
  scenes = new ArrayList<Scene>();
  // All set up based on the properties of the background.
  scenes.add(new Scene(0, 1.0, -50, 190, 100, 0));
  scenes.add(new Scene(1, 2.45, -470, 410, 90, 1));
  scenes.add(new Scene(2, 1.10, -80, 210, 80, 2));
  scenes.add(new Scene(3, 0.95, -40, 180, 70, 3));
  scenes.add(new Scene(4, 1.32, -85, 250, 70, 4));  
  scenes.add(new Scene(5, 0.76, -30, 150, 70, 5)); 
  scenes.add(new Scene(6, 0.82, -25, 150, 0, 1));  
  scenes.add(new Scene(7, 0.92, -65, 180, 95, 0));  
  scenes.add(new Scene(8, 1.45, -260, 260, 40, 0));  
  scenes.add(new Scene(9, 1.22, -125, 220, 60, 0));  
  scenes.add(new Scene(10, 0.82, -19, 150, 50, 0));   
}

public class Scene {
  float scale;
  PImage background;
  int floor;
  int left_border;
  int right_border;
  int bystanders;
  
  Scene(int _scene_no, float _scale, int _floor, int _left_border, int _right_border, int _bystanders) {
    scale = _scale;
    background = loadImage("Scene" + _scene_no + ".jpg");
    floor = _floor;
    left_border = _left_border;
    right_border = _right_border;
    bystanders = _bystanders;
  }
  
  int getRightBorder() {
    return right_border;
  }
  
  int getLeftBorder() {
    return left_border;
  }
  
  int getFloor() {
    return floor;
  }
  
  int getByNo() {
    return bystanders;
  }
  
  float getScale() {
    return scale;
  }
};

void setScene() {  
  // Set new scene type
  if (game_state.cur_scene == 1) {
    game_state.scene_type = WALK;
  } else if (game_state.cur_scene == SHOT_SCENE + 1) {
    game_state.scene_type = APPROACH;
  } else if (game_state.cur_scene == FALL_SCENE) {
    game_state.scene_type = INJURED;
  }
  
  // Set scaling
  int scene = game_state.cur_scene;
  float scale = scenes.get(scene).scale;
  float av_width = AVATAR_WIDHT * scale;
  float av_x = scenes.get(scene).getLeftBorder() + ((av_width - PURPOSED_WIDTH * scale) / 2);
  float av_y = -scenes.get(scene).floor + (PURPOSED_HEIGHT) * (1.0 - scale) + AVATAR_UP * scale; // Adjust to uplift of the sprite, the floor height and scaling of the picture w.r.t. the original assumption.
  float d_x = WIDTH_PER_STEP * scale * PURPOSED_WIDTH / 100.0;
  float d_y = 0.0;
  
  // Sete avatar type
  if (game_state.scene_type == HOME || game_state.scene_type == WALK) {
    avatar = new Avatar(walk, av_x, av_y, d_x, d_y, scale, av_width);
  } else if (game_state.scene_type == APPROACH || game_state.scene_type == INJURED) {
    avatar = new Avatar(walkw, av_x, av_y, d_x, d_y, scale, av_width);
  } else {
    println("Errorneous scene type.");
  }
  
  bystanders = new ArrayList<Bystander>();
  game_state.no_of_sprites = scenes.get(game_state.cur_scene).getByNo();
  for (int i = 0; i < game_state.no_of_sprites; i++) {
    bystanders.add(new Bystander(bystanders_data.get(i), (i % 2 == 0) ? walk : walkw, av_x - (random(FOLLOW_START, FOLLOW_START*4) * ratio * scale), av_y, d_x, d_y, scale));
  }
}

void setUpTheShot() {
  Animation shot = new Animation("shot", 20);
  avatar.setAnimation(shot);
  avatar.animateOnce();
  avatar.stopMove();
  avatar.move(-226.0, -78.0, 3.0,1.25);
  game_state.blocked = SECOND * 7;
  game_state.to_mist = SECOND * 7;
}

void setUpTheFall() {
  Animation fall = new Animation("fall", 20);
  avatar.setAnimation(fall);
  avatar.animateOnce();
  avatar.stopMove();
  avatar.move(31.0, 0.0, 2.1,0.96);
  game_state.blocked = Integer.MAX_VALUE; // Block forever.
  game_state.to_end = SECOND * 15; 
}
