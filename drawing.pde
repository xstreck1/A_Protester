void displayScene() {
  background(0, 0, 0);
  image(scenes.get(game_state.cur_scene).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  if (game_state.text_time > 0) {
    game_state.text_time--;
    textSize(font_size);
    fill(255, 255);
    float text_width = textWidth(game_state.cur_text);
    float x_coord = (win_width - text_width) / 2 + win_x;
    text(game_state.cur_text, x_coord, text_y);
  }
}

void displaySprites() {
  for (Map.Entry sprite: sprites.entrySet()) {
    ((Sprite) sprite.getValue()).display();
  }
}

void fillWithWhite() {
  fill(MIST_COL, MIST_ALPHA);
  noStroke();
  float corner_dist = Math.max(win_width + win_x, win_height + win_y) * 2.0;
  int to_fill = Math.round((corner_dist / (SECOND*6)) * Math.max(0, (SECOND*6 - game_state.to_mist)));
  if (to_fill > 0) {
    game_state.dont_draw = 1;
  }
  ellipse(win_width/2 + win_x, win_height + win_y - scenes.get(game_state.cur_scene).getFloor() * ratio, to_fill, to_fill);
}

void lightUp() {
  fill(MIST_COL, 255);
  rect(0, 0, win_width + win_x*2, win_height + win_y*2);
  game_state.cur_scene++;
  game_state.scene_type = APPROACH;
  setScene();
  game_state.to_visible = SECOND * 6;
  game_state.blocked = SECOND * 5;
}

void controlFading() {
  if (game_state.to_change > 0) {
    fill(0, (255 / SECOND) * (SECOND - game_state.to_change));
    rect(win_x, win_y, win_width, win_height);
    if (--game_state.to_change <= 0) {
      game_state.cur_scene++;
      setScene();
      game_state.to_begin = SECOND * 2;
    }
  }
  if (--game_state.to_begin > 0) {
    fill(0, (255 / SECOND) * (game_state.to_begin));
    rect(win_x, win_y, win_width, win_height);
  } else {
    game_state.to_begin = 0;
  }
  if (game_state.to_visible > 0) {
    int alpha = Math.min(255, Math.round((255.0 / (SECOND * 3.0)) * (game_state.to_visible)));
    fill(MIST_COL, alpha);
    rect(0, 0, win_width + win_x*2, win_height + win_y*2);
    game_state.to_visible--;
  }
}

void showEnd() {
  if (game_state.to_end > SECOND * 12)
    return;

  game_state.dont_draw = Integer.MAX_VALUE; // Stop drawing.
  if (game_state.to_end > SECOND * 9) {
    fill(0, END_FADE_ALPHA);
    rect(win_x, win_y, win_width, win_height);
    return;
  } else if (game_state.to_end == SECOND * 9) {
    fill(0, 255);
    rect(win_x, win_y, win_width, win_height);
  }
  
  textSize(font_size);
  fill(255, FONT_APPEAR_ALPHA);

  if (game_state.to_end > SECOND * 6) {
    String text = "This Is Not The End";
    float text_width = textWidth(text);
    float x_coord = (win_width - text_width) / 2 + win_x;
    text(text, x_coord, win_y + Math.round(win_height * 1.0 / 6.0) + font_size / 2);
  } else if (game_state.to_end > SECOND * 3) {
    String text = "Other Stories Are Happening Right Now";
    float text_width = textWidth(text);
    float x_coord = (win_width - text_width) / 2 + win_x;
    text(text, x_coord, win_y + Math.round(win_height * 3.0 / 6.0) + font_size / 2);
  } else  {
    String text = "Public Attention May Prevent Violence";
    float text_width = textWidth(text);
    float x_coord = (win_width - text_width) / 2 + win_x;
    text(text, x_coord, win_y + Math.round(win_height * 5.0 / 6.0) + font_size / 2);
  }
}

