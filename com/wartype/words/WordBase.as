package com.wartype.words
{
	import com.wartype.App;
	import com.wartype.Universe;
	import com.wartype.guns.GunSimple;
	import com.wartype.interfaces.IObject;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class WordBase extends Sprite implements IObject
	{
		protected var _wordsArrayLenght:int; //Размерность массива
		protected var _textLabel:TextField; //Текстовое поле для вывода текста слова на экран
		protected var textClip:Sprite; //Спрайт для вывода текста слова на экран
		protected var wordIntoTextField:String; //Собственно, само слово
		protected var _sprite:Sprite; //Спрайт слова
		private var _speedY:int; //Скорость по Y
		protected var _go:Boolean; //Движется ли слово
		protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		protected var _gun:GunSimple = GunSimple.getInstance();
		
		public var isAttacked:Boolean; //Атаковано ли слово
		public var wordSplitChars:Array = []; //Массив букв слова
		public var isDead:Boolean; //Уничтожено ли слово

		private static const RED_COLOR_16BIT:String = "0xff0000";
		
		public function WordBase()
		{}
		
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
		
		//Фукнция нанесения урона слову по нажатию на клавишу
		public function damage():void
		{}
		
		//Нанесение урона пулей
		public function destruction():void
		{
			if (_wordsArrayLenght <= 0 && wordSplitChars.length <= 0)
			{
				free();
			}
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
			if (_go)
			{
				this.y += speedY * delta;
				_textLabel.text = wordIntoTextField.toString();
				setTextFormat();
			}
		}
		
		public function stop():void
		{
			_speedY = 0;
		}

		public function set speedY(value:int):void
		{
			_speedY = value;
		}

		public function get speedY():int
		{
			return _speedY;
		}

		private function setTextFormat():void
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = RED_COLOR_16BIT;
			textFormat.size = 16;
			if(wordSplitChars.length != 0)
			{
				_textLabel.setTextFormat(textFormat, 0, 1);
			}
		}
	}
}