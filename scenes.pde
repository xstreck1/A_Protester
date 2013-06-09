final int SHOT_SCENE = 1;
final int FALL_SCENE = 2;

final float WIDTH_PER_STEP = 0.8; // Percents of window per step

void createScenes() {
  scenes.add(new Scene(0, 0.95, 10, 30, 60));
  scenes.add(new Scene(1, 1.75, -230, 20, 50));
  scenes.add(new Scene(2, 0.82, 10, 20, 50));
  scenes.add(new Scene(3, 0.82, 10, 20, 50));
  scenes.add(new Scene(4, 0.82, 10, 20, 50));  
}

public class Scene {
  float scale;
  PImage background;
  int floor;
  int left_border;
  int right_border;
  
  Scene(int _scene_no, float _scale, int _floor, int _left_border, int _right_border) {
    scale = _scale;
    background = loadImage("Scene" + _scene_no + ".jpg");
    floor = _floor;
    left_border = _left_border;
    right_border = _right_border;
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
};

void setScene() {
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

void setUpTheFall() {
  Animation fall = new Animation("fall", 20);
  avatar.setAnimation(fall);
  avatar.animateOnce();
  avatar.stopMove();
  game_state.blocked = Integer.MAX_VALUE;  
}
