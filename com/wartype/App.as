package com.wartype {
	import com.wartype.menu.MainMenu;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;

public class App extends Sprite {

			public function App() {
				trace("App class is created!");

				stage.scaleMode = StageScaleMode.NO_SCALE;
				var game: Game = new Game(stage);
				new MainMenu(stage, game).load();
			}

		}
}