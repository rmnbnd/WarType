package com.wartype
{
	import flash.display.Sprite;
	
	
	public class App extends Sprite
	{
		public static const SCR_WIDTH:int = 480;
		public static const SCR_HEIGHT:int = 640;
		
		public static const SCRN_WIDTH_HALF:int = 240; 
		public static const SCRN_HEIGHT_HALF:int = 320;
		
		private var _game:Game;
		
		public function App()
		{
			trace("App class is created!");
			
			_game = new Game();
			addChild(_game);
		}
	}
}