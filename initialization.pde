void initialize() {
  initDimensions();
  initTexts();
  createScenes();
  walk = new Animation("walk", 20);
  walkw = new Animation("walkw", 20);
}

void setupFont() {
  PFont text_font;
  text_font = loadFont("text_font.vlw");
  textFont(text_font);
}

