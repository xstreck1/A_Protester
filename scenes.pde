final String DOOR_SCENE = "Door";
final String WALL_SCENE = "Wall";
final String CLIMB_SCENE = "Climb";

final float WIDTH_PER_STEP = 0.8; // Percents of window per step

void createScenes() {
  scenes.put(DOOR_SCENE, new Scene(0.8, DOOR_SCENE, 10, 30, 60));
  scenes.put(WALL_SCENE, new Scene(0.75, WALL_SCENE, 10, 20, 50));
  scenes.put(CLIMB_SCENE, new Scene(0.82, CLIMB_SCENE, 10, 20, 50));
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
    return left_border;
  }
};
