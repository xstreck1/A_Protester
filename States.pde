import java.util.ArrayList;

// Scene type
final int HOME = 1;
final int WALK = 2;
final int APPROACH = 3;
final int INJURED = 4;

// Scene states
final int DOOR = 101;
final int WALL = 102;

final int SECOND = 25;

int loaded = 0;

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
  int no_of_sprites = 0;
  int frame = 0;
  boolean finished = false;
  PImage background;
};

void initTexts() {
  texts = new ArrayList< ArrayList< String > >();
  ArrayList<String> scene_text = new ArrayList<String>();
  scene_text.add("It Is Happening Out There");
  scene_text.add("Everyone Is Out");
  scene_text.add("I Have To Go");
  scene_text.add("The Door Is The Way");
  texts.add(scene_text);
  scene_text = new ArrayList<String>();
  scene_text.add("There Is No Way Back");
  scene_text.add("I Am Part Of This Now");
  scene_text.add("I Can't Back Out Now");
  scene_text.add("Everyone Sees Me");
  scene_text.add("Only One Way To Go");
  texts.add(scene_text);
  scene_text = new ArrayList<String>();
  scene_text.add("I Can't Believe It's Happening");
  scene_text.add("So Much Violence");
  scene_text.add("I Must Retain Hope");
  scene_text.add("I Must Persist"); 
  texts.add(scene_text);
  scene_text = new ArrayList<String>();
  scene_text.add("There he is...");
  scene_text.add("Why?");
  texts.add(scene_text);
}


