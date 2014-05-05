package com.wartype
{
	import com.wartype.words.*;
	import com.wartype.bullets.*;
	import com.wartype.controllers.ObjectController;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	
	public class Universe extends Sprite
	{
		private static var _instance:Universe; //Ссылка на игровой мир
		private var _timer_word:Timer = new Timer(4000); //Таймер выпадения слов 
		private var _wordsArray:Array = ['ROSTISLAV', 'QWERTY', 'LEMON', 'JIMMY', 'YANA', 'NIKITA', 'NGOLOG']; //Массив слов
		private var _random:int; //Рандомное число для выбора слова из массива слов
		private var _wordObject:String; //Слово в стринг для передачи в конструктор WordBase
		private var _deltaTime:Number = 0; //Delta-время
		private var _lastTick:int = 0; //Последний тик таймера
		private var _maxDeltaTime:Number = 0.03; //Максимальное Delta-время
		private var _gun:GunSimple = GunSimple.getInstance(); //Пушка
		private var word:WordBase;
		
		public var words:ObjectController;
		public var bullets:ObjectController;
		public var guns:ObjectController;
		
		
		public function Universe()
	    {
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
				
		//Функция получения ссылки на игровой мир
		public static function getInstance():Universe
		{
			return (_instance == null) ? new Universe() : _instance;
		}
		
		public function endGame():void
		{
			_timer_word.stop();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler);
			//words.clear();
			for (var i:int = 0; i < words.objects.length; i++)
			{
				word = words.objects[i];
				word.stop();
			}
			bullets.clear();
		}
		
		//Фукнция инициализации игрового мира
		private function init(event:Event = null):void
		{
			if (_instance != null)
			{
				throw("The universe is already created. Use the Universe.getInstance();");
			}
			_instance = this;
			trace("Universe was created!");
			
			words = new ObjectController();
			bullets = new ObjectController();
			guns = new ObjectController();
			_gun = new GunSimple();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler); //Слушатель на нажатие кнопки
			
			_timer_word.addEventListener(TimerEvent.TIMER, create_new_word); //Слушатель на тик таймера
			_timer_word.start(); //Старт таймера
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			//Расчёты Delta-времени для избежания ошибок в выводе графики при низких fps
			//getTimer() считает время с момента запуска приложения до вызова функции
			_deltaTime = (getTimer() - _lastTick) / 1000;
			_deltaTime = (_deltaTime > _maxDeltaTime) ? _maxDeltaTime : _deltaTime;
			
			//Обновление всех объектов на экране
			bullets.update(_deltaTime);
			words.update(_deltaTime);
			guns.update(_deltaTime);
			
			//Запоминаем последний тик таймера
			_lastTick = getTimer();
		}
		
		//Функция создаёт рандомно слово по тику таймера
		private function create_new_word(event:TimerEvent):void
		{
			_random = Math.random() * _wordsArray.length;
			_wordObject = _wordsArray[_random];
			var word = new WordBase(_wordObject);
		}
	}
}