package com.wartype
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Game extends Sprite
	{
		
		private var _universe:Universe;
		
		public function Game()
		{
			trace("Game class is created!");
			
			_universe = new Universe();
			addChild(_universe);
			
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			//_universe.updateMousePos(event.stageX, event.stageY); //Возможно, в дальнейшем понадобится
		}
	}
}