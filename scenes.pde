final String DOOR_SCENE = "Door";
final String WALL_SCENE = "Wall";

final float WIDTH_PER_STEP = 0.8; // Percents of window per step

void createScenes() {
  scenes.put(DOOR_SCENE, new Scene(0.8, DOOR_SCENE, 10, 30, 50));
  scenes.put(WALL_SCENE, new Scene(0.6, WALL_SCENE, 10, 20, 40));
}

final String nextScene(final String current_scene) {
  if (current_scene == DOOR_SCENE) {
    return WALL_SCENE;
  } else if (current_scene == WALL_SCENE) {
    return DOOR_SCENE;
  } else {
    return "";
  }
}
