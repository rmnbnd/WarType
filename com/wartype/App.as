package com.wartype {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;

	public class App extends Sprite {
		private var playGameButton:MovieClip;
		private var aboutButton:MovieClip;

		public function App() {
			trace("App class is created!");

			createButtons();
		}

		private function createButtons():void
		{
			playGameButton = createButton(playGameButton_mc, MainConstants.SCRN_WIDTH_HALF, MainConstants.SCRN_HEIGHT_HALF);
			playGameButton.addEventListener(MouseEvent.CLICK, onClickStart);
			playGameButton.addEventListener(MouseEvent.ROLL_OVER, playButtonMouseOver);
			playGameButton.addEventListener(MouseEvent.ROLL_OUT, playButtonMouseOut);
			if(playGameButton != null)
			{
				addChild(playGameButton);
			}

			aboutButton = createButton(aboutGameButton_mc, MainConstants.SCRN_WIDTH_HALF, MainConstants.SCRN_HEIGHT_HALF + 100);
			aboutButton.addEventListener(MouseEvent.CLICK, onClickAbout);
			aboutButton.addEventListener(MouseEvent.ROLL_OVER, aboutButtonMouseOver);
			aboutButton.addEventListener(MouseEvent.ROLL_OUT, aboutButtonMouseOut);
			if(aboutButton != null)
			{
				addChild(aboutButton);
			}
		}

		private function onClickStart(event: MouseEvent):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var _game: Game = new Game(stage);
			addChild(_game);
		}

		private function onClickAbout(event: MouseEvent):void
		{

		}

		private function playButtonMouseOver(event: MouseEvent):void
		{
			playGameButton.gotoAndStop(2);
		}

		private function playButtonMouseOut(event: MouseEvent):void
		{
			playGameButton.gotoAndStop(1);
		}

		private function aboutButtonMouseOver(event: MouseEvent):void
		{
			aboutButton.gotoAndStop(2);
		}

		private function aboutButtonMouseOut(event: MouseEvent):void
		{
			aboutButton.gotoAndStop(1);
		}
		
		private function createButton(button: Class, positionX: int, positionY: int):MovieClip
		{
			var menuButton:MovieClip = new button;
			menuButton.gotoAndStop(1);
			menuButton.x = positionX;
			menuButton.y = positionY;
			return menuButton;
		}

	}
}