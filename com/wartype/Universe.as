package com.wartype
{
	import com.wartype.levels.LevelBase;
	import com.wartype.levels.LevelManager;
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
		private var _timerWord:Timer; //Таймер выпадения слов 
		private var _timerWave:Timer;
		private var _timerSlowly:Timer;
		private var _wordsArray:Array; //Массив слов
		private var _random:int; //Рандомное число для выбора слова из массива слов
		private var _wordObject:String; //Слово в стринг для передачи в конструктор WordBase
		private var _deltaTime:Number = 0; //Delta-время
		private var _lastTick:int = 0; //Последний тик таймера
		private var _maxDeltaTime:Number = 0.03; //Максимальное Delta-время
		private var _gun:GunSimple = GunSimple.getInstance(); //Пушка
		private var word:WordBase;
		private var _levelManager:LevelManager;
		private var _speedY:int;
		
		public var words:ObjectController;
		public var bullets:ObjectController;
		public var guns:ObjectController;
		public var currentLevel:LevelBase;
		
		
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
		
		public function set wordsArray(value:Array):void
		{
			if (value != null)
			{
				_wordsArray = value;
			}
		}
		
		public function set timer(value:int):void
		{
			if (value != 0)
			{
				_timerWord = new Timer(value);
			}
		}
		
		public function set speedY(value:int):void
		{
			_speedY = value;
		}
		
		public function endGame():void
		{
				_timerWord.stop();
				_timerWave.stop();
				_timerSlowly.stop();
				_timerWord.removeEventListener(TimerEvent.TIMER, create_new_word);
				_timerWave.removeEventListener(TimerEvent.TIMER, create_new_wave);
				_timerSlowly.removeEventListener(TimerEvent.TIMER, create_new_slowly);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler);
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				for (var i:int = 0; i < words.objects.length; i++)
				{
					word = words.objects[i];
					word.stop();
				}
				bullets.clear();
				if (_gun.getHealth <= 0)
				{
					trace("Game over! You are died!");
				}
				else
				{
					trace("You won!");
				}
		}
		
		//Фукнция инициализации игрового мира
		private function init(event:Event = null):void
		{
			if (_instance != null)
			{
				throw("The universe is already created. Use the Universe.getInstance();");
			}
			_instance = this;
			
			_levelManager = new LevelManager();
			currentLevel = _levelManager.getLevel(1); //Создаём уровень
			currentLevel.load();
			
			trace("Universe was created!");
			
			words = new ObjectController();
			bullets = new ObjectController();
			guns = new ObjectController();
			_gun = new GunSimple();
			
			_timerWave = new Timer(60000);
			_timerSlowly = new Timer(80000);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler); //Слушатель на нажатие кнопки
			
			_timerWord.addEventListener(TimerEvent.TIMER, create_new_word); //Слушатель на тик таймера
			_timerWave.addEventListener(TimerEvent.TIMER, create_new_wave);
			_timerSlowly.addEventListener(TimerEvent.TIMER, create_new_slowly);
			_timerWord.start(); //Старт таймера
			_timerWave.start();
			_timerSlowly.start();
			
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
			
			if (_wordsArray.length <= 0 && words.objects.length == 0)
			{
				endGame();
			}
			//Запоминаем последний тик таймера
			_lastTick = getTimer();
		}
		
		//Функция создаёт рандомно слово по тику таймера
		private function create_new_word(event:TimerEvent):void
		{
			if (_wordsArray.length - 1 >= 0)
			{
				_random = Math.random() * _wordsArray.length;
				_wordObject = _wordsArray[_random];
				var word = new WordSimple(_wordObject, _speedY);
				_wordsArray.splice(_random, 1);
			}
			else
			{
				return;
			}
		}
		
		private function create_new_wave(event:TimerEvent):void
		{
			_speedY = 100;
			trace("Prepare for battle! A new wave of words is coming!");
			
		}
		
		private function create_new_slowly(event:TimerEvent):void
		{
			_speedY = 50;
			trace("Normal mode is enabled!");
			_timerWave.stop();
			_timerWave.start();
			
		}
	}
}