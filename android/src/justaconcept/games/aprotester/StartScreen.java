package justaconcept.games.aprotester;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;

public class StartScreen extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	setContentView(R.layout.start_screen);
    }
    
    public void startNewGame(View view) {
	Intent new_game_intent = new Intent(this, AProtester.class);
	startActivity(new_game_intent);
    }
    
    public void onToggleClicked(View view) {
	
    }
    
    public void finishGame(View view) {
	finish();
    }
}
