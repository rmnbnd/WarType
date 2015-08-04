package com.wartype {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageScaleMode;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.controls.Button;

	public class App extends Sprite {
		public static const SCR_WIDTH: int = 600;
		public static const SCR_HEIGHT: int = 800;
		public static const SCRN_WIDTH_HALF: int = SCR_WIDTH / 2;
		public static const SCRN_HEIGHT_HALF: int = SCR_HEIGHT / 2;

		public var startButton: Button;

		public function App() {
			trace("App class is created!");

			createStartButton();
			addChild(startButton);
		}

		public function onClickStart(event: MouseEvent): void {
			startButton.visible = false;			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var _game: Game = new Game(stage);
			addChild(_game);
		}
		
		function createStartButton() {
			startButton = new Button();
			startButton.visible = true;
			startButton.label = "Start Game";
			startButton.x = SCRN_WIDTH_HALF - startButton.height;
			startButton.y = SCRN_HEIGHT_HALF - startButton.width;
			
			startButton.addEventListener(MouseEvent.CLICK, onClickStart);
		}

	}
}