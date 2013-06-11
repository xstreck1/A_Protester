import java.util.ArrayList;

void initialize() {
  initDimensions();
  createScenes();
  initTexts();
  initBystanders();
  walk = new Animation("walk", 20);
  walkw = new Animation("walkw", 20);
  sound_im = loadImage("sound.png");
  no_sound = loadImage("nosound.png");
  sound = false;
}

void setupFont() {
  PFont text_font;
  text_font = loadFont("text_font.vlw");
  textFont(text_font);
}

void initBystanders() {
  bystanders_data = new ArrayList<BystanderData>();
  bystanders_data.add(new BystanderData(128,188,255,1.05));
  bystanders_data.add(new BystanderData(188,255,128,1.025));
  bystanders_data.add(new BystanderData(255,128,188,1.0));
  bystanders_data.add(new BystanderData(255,255,188,0.975));
  bystanders_data.add(new BystanderData(188,128,255,0.95));
}
