package justaconcept.games.aprotester;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PImage;
import android.content.SharedPreferences;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.preference.PreferenceManager;

public class AProtester extends PApplet {
    SharedPreferences prefs;
    SharedPreferences.Editor edit;
    MediaPlayer media_player;
    MediaPlayer shot_sound_player;

    public void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	prefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
	edit = prefs.edit();

	media_player = MediaPlayer.create(getApplicationContext(), R.raw.background);
	media_player.setLooping(true);
	media_player.setAudioStreamType(AudioManager.STREAM_MUSIC);

	shot_sound_player = MediaPlayer.create(getApplicationContext(), R.raw.gun2);
	shot_sound_player.setAudioStreamType(AudioManager.STREAM_MUSIC);
    }

    @Override
    public void onPause() {
	super.onPause();
	media_player.stop();
	shot_sound_player.stop();	
    }

    @Override
    public void onResume() {
	super.onResume();

	if (prefs.getBoolean("sound", false))
	    media_player.start();
    }

    @Override
    public void onStop() {
	super.onStop();
    }

    public int sketchWidth() {
	return getWindowManager().getDefaultDisplay().getWidth();
    }

    public int sketchHeight() {
	return getWindowManager().getDefaultDisplay().getHeight();
    }

    GameState game_state = new GameState();
    ArrayList<Scene> scenes;
    ArrayList<Bystander> bystanders;
    ArrayList<BystanderData> bystanders_data;
    ArrayList<ArrayList<String>> texts;

    Avatar avatar;
    Animation walk;
    Animation walkw;

    public void setup() {

	frameRate(25);
	setupFont();

	game_state.scene_type = prefs.getInt("scene_type", HOME);
	game_state.cur_scene = prefs.getInt("cur_scene", 0);
	initialize();
	game_state.background = loadImage(scenes.get(game_state.cur_scene).background);
	setScene();
	loaded++;
    }

    public void draw() {

	// Display objects (during normal workflow).
	if (game_state.dont_draw <= 0) {
	    displayScene();
	    displaySprites();

	    tint(255, 255);
	    avatar.display();

	    displayText();

	    // Cover the overlaping areas with black
	    if (win_x != 0) {
		fill(0, 255);
		rect(0, 0, win_x, win_height);
		rect(win_x + win_width, 0, win_x, win_height);
	    } else if (win_y != 0) {
		fill(0, 255);
		rect(0, 0, win_width, win_y);
		rect(0, win_y + win_height, win_width, win_y);
	    }
	} else {
	    --game_state.dont_draw;
	}
	reactToEvents();
	controlFading();

	game_state.frame++;
    }

    // React to environment, if the workflow is not blocked.
    public void reactToEvents() {
	// React to input / event
	if (game_state.blocked <= 0) {
	    if (game_state.cur_scene == SHOT_SCENE && avatar.isLeftFrom(Math.round(win_width * 6.0f / 8.0f) + win_x)) {
		setUpTheShot();
	    } else if (game_state.cur_scene == FALL_SCENE && avatar.isLeftFrom(Math.round(win_width * 1.5f / 8.0f) + win_x)) {
		setUpTheFall();
	    } else if (!avatar.isRightFrom(win_width - scenes.get(game_state.cur_scene).getRightBorder())) {// Control
													    // scene
													    // change.
		game_state.to_change = SECOND;
		game_state.blocked = SECOND;
	    } else if (mousePressed) {
		// React to mouse only if nothing else is scheduled.
		reactToMouse();
	    }
	} else {
	    game_state.blocked--;
	    // Check timed events.

	    if (game_state.to_mist > 0) {
		// Start filling with smoke (white circles)
		fillWithWhite();
		game_state.to_mist--;
		if (game_state.to_mist == 0) {
		    // If the scene is filled, start a new one.
		    lightUp();
		}
	    }

	    if (game_state.to_end-- > 0) {
		showEnd();
	    }

	    if (game_state.finished && mousePressed)
		finish();
	}
    }

    // React to mouse input (button is pressed event).
    public void reactToMouse() {
	if (avatar.isRightFrom(mouseX)) {
	    // Move
	    avatar.startAnim(1);
	    game_state.blocked = avatar.getCount();
	} else if (avatar.isLeftFrom(mouseX) && game_state.text_time <= 0) {
	    // Display text
	    game_state.cur_text = texts.get(game_state.scene_type - 1).get(0);
	    // Recycle texts.
	    if (texts.get(game_state.scene_type - 1).size() > 1)
		texts.get(game_state.scene_type - 1).remove(0);
	    game_state.text_time = SECOND;
	}
    }

    final int PURPOSED_WIDTH = 480;
    final int PURPOSED_HEIGHT = 320;

    final float AVATAR_UP = 52.0f;
    final float AVATAR_WIDHT = 10.0f;
    int win_width = 0;
    int win_height = 0;
    int win_x = 0;
    int win_y = 0;
    float ratio = 0.0f;

    final int MIST_COL = 230;
    final int MIST_ALPHA = 25;
    final int END_FADE_ALPHA = 12;
    final int FONT_APPEAR_ALPHA = 25;

    final int PURPOSED_FONT_SIZE = 24;
    int font_size = 0;
    final int PURPOSED_TEXT_LINE = 50;
    int font_line = 0;

    // Bystander move
    final int FOLLOW_START = 70;
    final int FOLLOW_UP = 50;

    // Change the size based on resolution.
    public void initDimensions() {
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
	println(width + " " + height);
	println(ratio + " " + win_x + " " + win_y + " " + win_width + " " + win_height);
	font_size = Math.round((float) PURPOSED_FONT_SIZE * ratio);
	font_line = win_y + Math.round(win_height * 1.0f / 6.0f) - font_size;
    }

    public void drawLoading() {
	fill(0);
	rect(0, 0, width, height);
	fill(255);
	String LOADING = "LOADING";
	float size = height;
	do {
	    size /= 2.0f;
	    textSize(size);
	} while (textWidth(LOADING) > width);
	text(LOADING, (width - textWidth(LOADING)) / 2, (height) / 2);
    }

    public void displayScene() {
	background(0, 0, 0);
	image(game_state.background, win_x, win_y, win_width, win_height);
    }

    public void displayText() {
	if (game_state.text_time > 0) {
	    game_state.text_time--;
	    textSize(font_size);

	    fill(0, 255);
	    rect(win_x, font_line, win_width, font_size * 2);
	    fill(255, 255);
	    textOut(1.0f, game_state.cur_text);
	}
    }

    public void displaySprites() {
	for (int i = 0; i < game_state.no_of_sprites; i++) {
	    // Randomization of when they start to move.
	    if ((scenes.get(game_state.cur_scene).getScale()) * random(FOLLOW_UP, FOLLOW_UP * 4) * ratio < (avatar.getX() - ((Bystander) bystanders.get(i)).getX())
		    && ((Bystander) bystanders.get(i)).getFrame() == 0 && game_state.frame % ((i + 1) * 2 + 3) == 0)
		((Bystander) bystanders.get(i)).startAnim(1);
	    // When the shot scene is up, stop the guy at the beginning.
	    if (game_state.cur_scene == SHOT_SCENE && ((Bystander) bystanders.get(i)).getFrame() == 0
		    && ((Bystander) bystanders.get(i)).getX() > -(((Bystander) bystanders.get(i)).getWidth() / 2))
		((Bystander) bystanders.get(i)).stopAnim();

	    ((Bystander) bystanders.get(i)).display();
	}
    }

    public void fillWithWhite() {
	fill(MIST_COL, MIST_ALPHA);
	noStroke();
	float corner_dist = Math.max(win_width + win_x, win_height + win_y) * 2.0f;
	int to_fill = Math.round((corner_dist / (SECOND * 6)) * Math.max(0, (SECOND * 6 - game_state.to_mist)));
	if (to_fill > 0) {
	    game_state.dont_draw = 1;
	}
	ellipse(win_width / 2 + win_x, win_height + win_y + scenes.get(game_state.cur_scene).getFloor() * ratio, to_fill, to_fill);
    }

    public void lightUp() {
	fill(MIST_COL, 255);
	rect(0, 0, win_width + win_x * 2, win_height + win_y * 2);
	game_state.cur_scene++;
	game_state.background = loadImage(scenes.get(game_state.cur_scene).background);
	game_state.scene_type = APPROACH;
	setScene();
	game_state.to_visible = SECOND * 6;
	game_state.blocked = SECOND * 5;
    }

    public void controlFading() {
	if (game_state.to_change > 0) {
	    fill(0, (255 / SECOND) * (SECOND - game_state.to_change));
	    rect(win_x, win_y, win_width, win_height);
	    if (--game_state.to_change <= 0) {
		game_state.cur_scene++;
		edit.putInt("scene_type", game_state.scene_type);
		edit.putInt("cur_scene", game_state.cur_scene);
		edit.apply();
		game_state.background = loadImage(scenes.get(game_state.cur_scene).background);
		setScene();
		game_state.to_begin = SECOND;
	    }
	}
	if (--game_state.to_begin > 0) {
	    fill(0, (255 / SECOND) * (game_state.to_begin));
	    rect(win_x, win_y, win_width, win_height);
	} else {
	    game_state.to_begin = 0;
	}
	if (game_state.to_visible > 0) {
	    int alpha = Math.min(255, Math.round((255.0f / (SECOND * 3.0f)) * (game_state.to_visible)));
	    fill(MIST_COL, alpha);
	    rect(0, 0, win_width + win_x * 2, win_height + win_y * 2);
	    game_state.to_visible--;
	}
    }

    public void showEnd() {
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
	    textOut(1.0f, "This Is Not The End");
	} else if (game_state.to_end > SECOND * 3) {
	    textOut(3.0f, "Other Stories Are Happening Right Now");
	} else {
	    textOut(5.0f, "Public Attention May Prevent Violence");
	}

	if (game_state.to_end == 1) {
	    game_state.finished = true;
	}
    }

    public void textOut(float position, String text) {
	float text_width = textWidth(text);
	float x_coord = (win_width - text_width) / 2 + win_x;
	text(text, x_coord, win_y + Math.round(win_height * position / 6.0f) + font_size / 2);
    }

    public void initialize() {
	initDimensions();
	createScenes();
	initTexts();
	initBystanders();
	walk = new Animation("walk", 20);
	walkw = new Animation("walkw", 20);
    }

    public void setupFont() {
	PFont text_font;
	text_font = createFont("text_font.vlw", 32, true);
	textFont(text_font);
    }

    public void initBystanders() {
	bystanders_data = new ArrayList<BystanderData>();
	bystanders_data.add(new BystanderData(128, 188, 255, 1.05f));
	bystanders_data.add(new BystanderData(188, 255, 128, 1.025f));
	bystanders_data.add(new BystanderData(255, 128, 188, 1.0f));
	bystanders_data.add(new BystanderData(255, 255, 188, 0.975f));
	bystanders_data.add(new BystanderData(188, 128, 255, 0.95f));
    }

    // Class for animating a sequence of GIFs
    // Based on an Example Animated Sprite (Shifty + Teddy) by James Paterson.
    class Animation {
	PImage[] images;
	int image_count;

	Animation(String _name, int _image_count) {
	    image_count = _image_count;
	    images = new PImage[_image_count];

	    for (int i = 0; i < image_count; i++) {
		String filename = _name + nf(i, 2) + ".png";
		images[i] = loadImage(filename);
	    }
	}

	public void display(int frame, float xpos, float ypos, int my_width, int my_height) {
	    // println(xpos + " " + ypos + " " + my_width + " " + my_height);
	    image(images[frame], xpos, ypos, my_width, my_height);
	}

	public int getCount() {
	    return image_count;
	}
    };

    class Sprite {
	int frame;
	float x;
	float y;
	float d_x;
	float d_y;
	int my_width;
	int my_height;
	float scale;
	int animation_steps;
	Animation animation;

	public void display() {
	    if (animation_steps > 0) {
		animation_steps--;
		frame = (frame + 1) % animation.getCount();
		x += d_x;
		y += d_y;
	    }
	    animation.display(frame, x, y, my_width, my_height);
	}

	Sprite(Animation _animation, float _x, float _y, float _d_x, float _d_y, float _scale) {
	    animation = _animation;
	    frame = 0;
	    x = _x * ratio + win_x;
	    y = _y * ratio + win_y;
	    d_x = _d_x * ratio;
	    d_y = _d_y * ratio;
	    scale = _scale * ratio;
	    my_width = Math.round(animation.images[0].width * scale);
	    my_height = Math.round(animation.images[0].height * scale);
	}

	public void setAnimation(Animation _animation) {
	    animation = _animation;
	}

	public void startAnim(int iterations) {
	    frame = 0;
	    animation_steps = iterations * getCount();
	}

	public void animateOnce() {
	    frame = 0;
	    animation_steps = getCount() - 1;
	}

	public int getCount() {
	    return animation.getCount();
	}

	public void stopAnim() {
	    animation_steps = 0;
	}

	public void reset() {
	    frame = 0;
	}

	public void stopMove() {
	    d_x = d_y = 0;
	}

	public float getX() {
	    return x;
	}

	public float getY() {
	    return y;
	}

	public float getWidth() {
	    return my_width;
	}

	public float getHeight() {
	    return my_height;
	}

	public int getFrame() {
	    return frame;
	}
    };

    class Avatar extends Sprite {
	float av_width;

	Avatar(Animation animation, float _x, float _y, float _d_x, float _d_y, float _scale, float _av_width) {
	    super(animation, _x, _y, _d_x, _d_y, _scale);
	    av_width = _av_width;
	}

	public void move(float _x, float _y, float _width, float _height) {
	    x += _x * scale;
	    y += _y * scale;
	    my_width *= _width;
	    my_height *= _height;
	}

	public boolean isRightFrom(int _x) {
	    return (_x > (getWidth() + av_width) / 2 + x);
	}

	public boolean isLeftFrom(int _x) {
	    return (_x < (getWidth() - av_width) / 2 + x);
	}

	public int getAvWidth() {
	    return Math.round(av_width);
	}
    };

    class Bystander extends Sprite {
	BystanderData my_data;

	Bystander(BystanderData _my_data, Animation animation, float _x, float _y, float _d_x, float _d_y, float _scale) {
	    super(animation, _x, _y, _d_x, _d_y, _scale);
	    my_data = _my_data;
	}

	public void display() {
	    tint(my_data.tint_r, my_data.tint_g, my_data.tint_b);
	    super.display();
	}
    };

    class BystanderData {
	int tint_r;
	int tint_g;
	int tint_b;
	float scale;

	BystanderData(int _tint_r, int _tint_g, int _tint_b, float _scale) {
	    tint_r = _tint_r;
	    tint_g = _tint_g;
	    tint_b = _tint_b;
	    scale = _scale;
	}
    };

    final int SHOT_SCENE = 6;
    final int FALL_SCENE = 10;

    final float WIDTH_PER_STEP = 0.8f; // Percents of window per ste

    public void createScenes() {
	scenes = new ArrayList<Scene>();
	// All set up based on the properties of the background.
	scenes.add(new Scene(0, 1.0f, -50, 190, 100, 0));
	scenes.add(new Scene(1, 2.45f, -470, 410, 90, 1));
	scenes.add(new Scene(2, 1.10f, -80, 210, 80, 2));
	scenes.add(new Scene(3, 0.95f, -40, 180, 70, 3));
	scenes.add(new Scene(4, 1.32f, -85, 250, 70, 4));
	scenes.add(new Scene(5, 0.76f, -30, 150, 70, 5));
	scenes.add(new Scene(6, 0.82f, -25, 150, 0, 1));
	scenes.add(new Scene(7, 0.92f, -65, 180, 95, 0));
	scenes.add(new Scene(8, 1.45f, -260, 260, 40, 0));
	scenes.add(new Scene(9, 1.22f, -125, 220, 60, 0));
	scenes.add(new Scene(10, 0.82f, -19, 150, 50, 0));
    }

    public class Scene {
	float scale;
	String background;
	int floor;
	int left_border;
	int right_border;
	int bystanders;

	Scene(int _scene_no, float _scale, int _floor, int _left_border, int _right_border, int _bystanders) {
	    scale = _scale;
	    background = "Scene" + _scene_no + ".jpg";
	    floor = _floor;
	    left_border = _left_border;
	    right_border = _right_border;
	    bystanders = _bystanders;
	}

	public int getRightBorder() {
	    return right_border;
	}

	public int getLeftBorder() {
	    return left_border;
	}

	public int getFloor() {
	    return floor;
	}

	public int getByNo() {
	    return bystanders;
	}

	public float getScale() {
	    return scale;
	}
    };

    public void setScene() {
	// Set new scene type
	if (game_state.cur_scene == 1) {
	    game_state.scene_type = WALK;
	} else if (game_state.cur_scene == SHOT_SCENE + 1) {
	    game_state.scene_type = APPROACH;
	} else if (game_state.cur_scene == FALL_SCENE) {
	    game_state.scene_type = INJURED;
	}

	// Set scaling
	int scene = game_state.cur_scene;
	float scale = scenes.get(scene).scale;
	float av_width = AVATAR_WIDHT * scale;
	float av_x = scenes.get(scene).getLeftBorder() + ((av_width - PURPOSED_WIDTH * scale) / 2);
	float av_y = -scenes.get(scene).floor + (PURPOSED_HEIGHT) * (1.0f - scale) + AVATAR_UP * scale; // Adjust
													// to
													// uplift
													// of
													// the
													// sprite,
													// the
													// floor
													// height
													// and
													// scaling
													// of
													// the
													// picture
													// w.r.t.
													// the
													// original
													// assumption.
	float d_x = WIDTH_PER_STEP * scale * PURPOSED_WIDTH / 100.0f;
	float d_y = 0.0f;

	// Sete avatar type
	if (game_state.scene_type == HOME || game_state.scene_type == WALK) {
	    avatar = new Avatar(walk, av_x, av_y, d_x, d_y, scale, av_width);
	} else if (game_state.scene_type == APPROACH || game_state.scene_type == INJURED) {
	    avatar = new Avatar(walkw, av_x, av_y, d_x, d_y, scale, av_width);
	} else {
	    println("Errorneous scene type.");
	}

	bystanders = new ArrayList<Bystander>();
	game_state.no_of_sprites = scenes.get(game_state.cur_scene).getByNo();
	for (int i = 0; i < game_state.no_of_sprites; i++) {
	    bystanders.add(new Bystander(bystanders_data.get(i), (i % 2 == 0) ? walk : walkw, av_x - (random(FOLLOW_START, FOLLOW_START * 4) * ratio * scale), av_y, d_x, d_y,
		    scale));
	}
    }

    public void setUpTheShot() {
	Animation shot = new Animation("shot", 20);
	avatar.setAnimation(shot);
	avatar.animateOnce();
	avatar.stopMove();
	avatar.move(-226.0f, -78.0f, 3.0f, 1.25f);
	game_state.blocked = SECOND * 7;
	game_state.to_mist = SECOND * 7;
	if (prefs.getBoolean("sound", false)) {
	    shot_sound_player.start();
	}
    }

    public void setUpTheFall() {
	Animation fall = new Animation("fall", 20);
	avatar.setAnimation(fall);
	avatar.animateOnce();
	avatar.stopMove();
	avatar.move(31.0f, 0.0f, 2.1f, 0.96f);
	game_state.blocked = Integer.MAX_VALUE; // Block forever.
	game_state.to_end = SECOND * 15;
    }

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

    public void initTexts() {
	texts = new ArrayList<ArrayList<String>>();
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
}
