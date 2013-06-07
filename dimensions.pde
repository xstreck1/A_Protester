final int PURPOSED_WIDTH = 320;
final int PURPOSED_HEIGHT = 480;
int win_width = 0;
int win_height = 0;
float ratio = 0.0;
float step = 0.0;

void initDimensions () {
  if (width / height > PURPOSED_WIDTH / PURPOSED_HEIGHT) {
    ratio = width / PURPOSED_WIDTH;
    win_width = width;
    win_height = Math.round(PURPOSED_HEIGHT * ratio);
  } else {
    ratio = height / PURPOSED_HEIGHT;
    win_height = height;  
    win_width = Math.round(PURPOSED_WIDTH * ratio);
  }
  final float WIDTH_PER_STEP = 0.6; // Percents of window per step
  step = (float) win_width / 100 * WIDTH_PER_STEP;
  print(step);
}
