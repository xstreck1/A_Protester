final int PURPOSED_WIDTH = 480;
final int PURPOSED_HEIGHT = 320;
int win_width = 0;
int win_height = 0;
int win_x = 0;
int win_y = 0;
float ratio = 0.0;
float step = 0.0;

float TEXT_Y_INDENT = 0.05;
int text_y = 0;

void initDimensions () {
  setWindow();
  
  
  
  final float WIDTH_PER_STEP = 0.6; // Percents of window per step
  step = (float) win_width / 100 * WIDTH_PER_STEP;
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
  print (ratio + " " + win_x + " " + win_y + " " + win_width + " " + win_height); 
}
