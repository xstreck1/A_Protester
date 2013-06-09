import java.util.Vector;

final int PURPOSED_WIDTH = 480;
final int PURPOSED_HEIGHT = 320;

final float AVATAR_UP = 52.0;
final float AVATAR_WIDHT = 30.0;
int win_width = 0;
int win_height = 0;
int win_x = 0;
int win_y = 0;
float ratio = 0.0;

final int MIST_COL = 230;
final int MIST_ALPHA = 25;
final int END_FADE_ALPHA = 12;
final int FONT_APPEAR_ALPHA = 25;

final int PURPOSED_FONT_SIZE = 24;
int font_size = 0;
final int PURPOSED_TEXT_LINE = 50;

// Bystander move
final int FOLLOW_START = 70;
final int FOLLOW_UP = 50;

void initDimensions () {
  setWindow();
}

void setWindow() {
  if ((float) width / (float) height < (float) PURPOSED_WIDTH / (float) PURPOSED_HEIGHT) {
    ratio = (float) width / (float) PURPOSED_WIDTH;
    win_width = width;
    win_height = Math.round(PURPOSED_HEIGHT * ratio);
    win_y = (height - win_height) / 2;
  } else {
    ratio = (float) height / (float) PURPOSED_HEIGHT;
    win_height = height;  
    win_width = Math.round(PURPOSED_WIDTH * ratio);
    win_x = (width - win_width) / 2;
  }
  println (width + " " + height );
  println (ratio + " " + win_x + " " + win_y + " " + win_width + " " + win_height); 
  font_size = Math.round((float) PURPOSED_FONT_SIZE * ratio);
}
