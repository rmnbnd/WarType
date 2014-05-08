package com.wartype.words
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import com.wartype.App;
	import com.wartype.Universe;
	import com.wartype.interfaces.IObject;
	import com.wartype.controllers.ObjectController;
	import com.wartype.bullets.GunSimple;
	
	public class WordBase extends Sprite implements IObject
	{
		protected var _wordsArrayLenght:int; //Размерность массива
		protected var _textLabel:TextField; //Текстовое поле для вывода текста слова на экран
		protected var textClip:Sprite; //Спрайт для вывода текста слова на экран
		protected var _wordObjText:String; //Собственно, само слово
		protected var _sprite:Sprite; //Спрайт слова
		protected var _speedY:int; //Скорость по Y
		protected var _go:Boolean; //Движется ли слово
		protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		protected var _gun:GunSimple = GunSimple.getInstance();
		
		public var isAttacked:Boolean; //Атаковано ли слово
		public var wordsArray:Array = []; //Массив букв слова
		public var isDead:Boolean; //Уничтожено ли слово
	
		
		public function WordBase()
		{	
			
		}
		
		public function init():void
		{
			this.x = ((App.SCR_WIDTH - 50) - 50) * Math.random() + 50;
			if (_sprite != null && textClip != null)
			{
				addChild(_sprite);
				addChild(textClip);
			}
			
			if (textClip["text"] != null)
			{
				_textLabel = textClip["text"] as TextField;
			}
			_universe.words.add(this); //Добавляем слово в массив слов (ObjectController)
			_universe.addChild(this);
		}
		
		//Фукнция нанесения урона по нажатию на клавишу
		public function damage():void
		{
			
		}
		
		//Нанесение урона пулей
		public function destruction():void
		{
			
		}
		
		public function free():void
		{
			_go = false;
			isDead = true;
			
			if (_sprite && contains(_sprite))
			{
				removeChild(_sprite);
			}
			
		    _universe.removeChild(this);
			_universe.words.remove(this);
		}
		
		public function update(delta:Number):void
		{
			//nothing
		}
		
		public function stop():void
		{
			_speedY = 0;
		}
	}
}