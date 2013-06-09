import java.util.Vector;

void displayScene() {
  background(0, 0, 0);
  image(scenes.get(game_state.cur_scene).background, win_x, win_y, win_width, win_height);
}

void displayText() {
  if (game_state.text_time > 0) {
    game_state.text_time--;
    textSize(font_size);
    
    fill(0,255);
    rect(win_x, win_y + Math.round(win_height * 1.0 / 6.0) - font_size, win_width, font_size * 2);
    fill(255,255);
    textOut(1.0, game_state.cur_text);
  }
}

void displaySprites() {
  for (int i = 0; i < game_state.no_of_sprites; i++) {
    if ((scenes.get(game_state.cur_scene).getScale()) * random(FOLLOW_UP, FOLLOW_UP*4) * ratio < (avatar.getX() - ((Bystander) bystanders.get(i)).getX()) && ((Bystander) bystanders.get(i)).getFrame() == 0 && game_state.frame % ((i + 1) * 2 + 3) == 0)
      ((Bystander) bystanders.get(i)).startAnim(1);
    if (game_state.cur_scene == SHOT_SCENE && ((Bystander) bystanders.get(i)).getFrame() == 0 && ((Bystander) bystanders.get(i)).getX() > -(((Bystander) bystanders.get(i)).getWidth() / 2))
      ((Bystander) bystanders.get(i)).stopAnim();
    ((Bystander) bystanders.get(i)).display();
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
    textOut(1.0, "This Is Not The End");
  } else if (game_state.to_end > SECOND * 3) {
    textOut(3.0, "Other Stories Are Happening Right Now");
  } else {
    textOut(5.0, "Public Attention May Prevent Violence");
  }
  
  if (game_state.to_end == 1) {
    game_state.finished = true;
  }
}

void textOut(float position, String text) {
  float text_width = textWidth(text);
  float x_coord = (win_width - text_width) / 2 + win_x;
  text(text, x_coord, win_y + Math.round(win_height * position / 6.0) + font_size / 2);
}

