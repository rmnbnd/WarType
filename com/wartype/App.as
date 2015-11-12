package com.wartype {
	import com.wartype.MainConstants;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageScaleMode;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.controls.Button;

	public class App extends Sprite {
		public var startButton: Button;

		public function App() {
			trace("App class is created!");

			createStartButton();
			addChild(startButton);
		}

		public function onClickStart(event: MouseEvent):void {
			startButton.visible = false;			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var _game: Game = new Game(stage);
			addChild(_game);
		}
		
		function createStartButton():void {
			startButton = new Button();
			startButton.visible = true;
			startButton.label = "Start Game";
			startButton.x = MainConstants.SCRN_WIDTH_HALF - startButton.height;
			startButton.y = MainConstants.SCRN_HEIGHT_HALF - startButton.width;
			startButton.addEventListener(MouseEvent.CLICK, onClickStart);
		}

	}
}