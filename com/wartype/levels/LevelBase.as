package com.wartype.levels
{
	import com.wartype.Universe;
	
	public class LevelBase 
	{
		protected var _universe = Universe.getInstance();
		protected var _wordsArray:Array;
		protected var _timerWord:int;
		protected var _speedY:int;
		
		public function LevelBase()
		{
			
		}
		
		public function load():void
		{
			_universe.speedY = _speedY; //Задаём скорость полёта слова
			_universe.timer = _timerWord; //Задаём скорость выпадения слов (интервал)
			_universe.wordsArray = _wordsArray; //Задаём массив слов
		}
	}
}