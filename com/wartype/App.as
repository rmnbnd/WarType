package com.wartype {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;

	public class App extends Sprite {
		private var playGameButton:MovieClip;

		public function App() {
			trace("App class is created!");

			createStartButton();
			if(playGameButton != null)
			{
				addChild(playGameButton);
			}
		}

		private function onClickStart(event: MouseEvent):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var _game: Game = new Game(stage);
			addChild(_game);
		}

		private function playButtonMouseOver(event: MouseEvent):void
		{
			playGameButton.gotoAndStop(2);
		}

		private function playButtonMouseOut(event: MouseEvent):void
		{
			playGameButton.gotoAndStop(1);
		}
		
		private function createStartButton():void
		{
			playGameButton = new playGameButton_mc();
			playGameButton.gotoAndStop(1);
			playGameButton.x = MainConstants.SCRN_WIDTH_HALF;
			playGameButton.y = MainConstants.SCRN_HEIGHT_HALF;
			playGameButton.addEventListener(MouseEvent.CLICK, onClickStart);
			playGameButton.addEventListener(MouseEvent.ROLL_OVER, playButtonMouseOver);
			playGameButton.addEventListener(MouseEvent.ROLL_OUT, playButtonMouseOut);
		}

	}
}