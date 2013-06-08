// Scene type
final int HOME = 1;
final int WALK = 2;
final int INJURED = 3;

// Scene states
final int DOOR = 101;
final int WALL = 102;

final int SECOND = 25;

public class GameState {
  int blocked = 0;
  String cur_scene = "";
  String cur_text;
  int text_time = 0;
  int to_change = 0;
  int to_begin = 0;
};

