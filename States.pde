// Scene type
final int HOME = 1;
final int WALK = 2;
final int APPROACH = 3;
final int INJURED = 4;

// Scene states
final int DOOR = 101;
final int WALL = 102;

final int SECOND = 25;


public class GameState {
  int scene_type = 0;
  int blocked = 0;
  int cur_scene = 0;
  String cur_text;
  int text_time = 0;
  int to_change = 0;
  int to_begin = 0;
  int to_mist = 0;
  int dont_draw = 0;
  int to_visible = 0;
  int to_end = 0;
};

Vector< Vector < String > > texts;

void initTexts() {
  texts = new Vector< Vector< String > >();
  Vector<String> scene_text = new Vector<String>();
  scene_text.add("It Is Happening Out There");
  scene_text.add("Everything is behind the door.");
  texts.add(scene_text);
  scene_text = new Vector<String>();
  scene_text.add("There is no way back.");
  texts.add(scene_text);
  scene_text = new Vector<String>();
  scene_text.add("Not point going back.");
  texts.add(scene_text);
  scene_text = new Vector<String>();
  scene_text.add("There he is...");
  texts.add(scene_text);
}


