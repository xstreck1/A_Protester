// Sprite animation states
final int NONE = 1;
final int WALK = 2;

// Scene states
final int DOOR = 101;
final int WALL = 102;

public class GameState {
  int blocked = 0;
  int cur_scene = 0;
  String cur_text;
  int text_time = 0;
};

