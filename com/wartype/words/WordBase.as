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
		private var _wordsArrayLenght:int; //Размерность массива
		private var _textLabel:TextField; //Текстовое поле для вывода текста слова на экран
		private var textClip:Sprite; //Спрайт для вывода текста слова на экран
		private var _wordObjText:String; //Собственно, само слово
		
		protected var _sprite:Sprite; //Спрайт слова
		protected var _speedY:Number; //Скорость по Y
		protected var _go:Boolean; //Движется ли слово
		protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		protected var _gun:GunSimple = GunSimple.getInstance();
		
		public var wordsArray:Array = []; //Массив букв слова
		public var isDead:Boolean; //Уничтожено ли слово
		public var isAttacked:Boolean; //Атаковано ли слово
	
		
		public function WordBase(wordObject:String)
		{
			_wordObjText = wordObject; //Записываем слово, передаваемое в конструктор, в переменную
			wordsArray = wordObject.split(''); //Разделяем слово по буквам
			_wordsArrayLenght = wordsArray.length; //Записываем размерность массива в переменную
			trace(wordsArray);
			_speedY = 50; //Устанавливаем скорость
			_sprite = new word_mc(); //Спрайт для слова
			_go = true; //Флаг движения
			isDead = false; //Флаг "смерти" слова
		    isAttacked = false; //Флаг атакуемости слова
			
			_universe.words.add(this); //Добавляем слово в массив слов (ObjectController)
			start_coordinats(); //Устанавливаем рандомно слово
			
			textClip = new textlabel_mc(); //Клип для TextLabel
			addChild(textClip);
			
			if (textClip["text"] != null)
			{
				_textLabel = textClip["text"] as TextField;
			}
		}
		
		//Фукнция нанесения урона по нажатию на клавишу
		public function damage():void
		{
			//Выводим слово после нанесения урона
			_wordObjText = '';
			wordsArray.shift();
			for (var i:int = 0; i < wordsArray.length; i++)
			{
				_wordObjText += wordsArray[i].toString();
			}
			
			if (wordsArray.length <= 0 || this.y >= App.SCR_HEIGHT)
			{
				_textLabel.visible = false;
				isDead = true;
				GunSimple.isAttackedFlag = false;
			}
		}
		
		//Нанесение урона пулей
		public function destruction():void
		{
			_wordsArrayLenght--;
			
			if (_wordsArrayLenght <= 0 && wordsArray.length <=0)
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
				this.y += _speedY * delta;
				_textLabel.text = _wordObjText.toString();
			}
			
			if (this.y >= App.SCR_HEIGHT)
			{
				_gun.setHealth = 10;
				free();
				return;
			}
		}
		
		public function stop():void
		{
			_speedY = 0;
		}
		
		//Функция, устанавливающая рандомно слово на сцене
		private function start_coordinats():void
		{
			this.x = ((App.SCR_WIDTH - 50) - 50) * Math.random() + 50;
			addChild(_sprite);
			_universe.addChild(this);
		}
	}
}