package com.wartype.menu
{
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	import flash.display.Stage;
	
	public class BaseMenu extends MovieClip
	{
		public var stageRef:Stage;
		public var loadNext:BaseMenu;
		
		public function BaseMenu() 
		{
			alpha = 0;
			y = 400;
		}
		
		public function unload(loadMe:BaseMenu = null) : void
		{
			if (loadMe)
				loadNext = loadMe;
				
			Tweener.addTween(this, { alpha: 0, y:-400, time: 0.7, onComplete:remove } );
		}
		
		public function remove() : void
		{
			if (stageRef.contains(this))
				stageRef.removeChild(this);
				
			if (loadNext != null) 
				loadNext.load();
		}
		
		public function load() : void
		{
			stageRef.addChild(this);
			Tweener.addTween(this, { alpha: 1, y:0, time: 0.7} );
		}
		
	}
	
}