// Scene type
final int HOME = 1;
final int WALK = 2;
final int INJURED = 3;

// Scene states
final int DOOR = 101;
final int WALL = 102;

final int SECOND = 25;

final int MIST_COL = 230;
final int MIST_ALPHA = 20;

public class GameState {
  int blocked = 0;
  String cur_scene = "";
  String cur_text;
  int text_time = 0;
  int to_change = 0;
  int to_begin = 0;
  int to_mist = 0;
  int dont_draw = 0;
  int to_visible = 0;
};

