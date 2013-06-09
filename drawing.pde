void displayScene() {
  background(0, 0, 0);
  image(scenes.get(game_state.cur_scene).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  if (game_state.text_time > 0) {
    game_state.text_time--;
    textSize(font_size);
    fill(255,255);
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
  game_state.to_mist--;
  fill(MIST_COL,MIST_ALPHA);
  noStroke();
  float corner_dist = Math.max(win_width + win_x, win_height + win_y) * 2.0;
  int to_fill = Math.round((corner_dist / (SECOND*6)) * Math.max(0,(SECOND*6 - game_state.to_mist)));
  if (to_fill > 0) {
    game_state.dont_draw = 1;
  }
  ellipse(win_width/2 + win_x, win_height + win_y - scenes.get(game_state.cur_scene).getFloor() * ratio, to_fill, to_fill);  
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
    rect(0,0,win_width + win_x*2,win_height + win_y*2);
    game_state.to_visible--;
  }
}
