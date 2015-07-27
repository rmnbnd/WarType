package com.wartype
{
    import com.wartype.controllers.ObjectController;
    import com.wartype.guns.GunBase;
    import com.wartype.guns.GunSimple;
    import com.wartype.levels.LevelManager;
    import com.wartype.words.*;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    public class Universe extends Sprite
    {
        private static var _instance:Universe; //Ссылка на игровой мир
        private var _timerWord:Timer; //Таймер выпадения слов
/*        private var _timerWave:Timer;
        private var _timerSlowly:Timer;*/
        /*private var _wordsArray:Array; //Массив слов
        private var _wordObject:String; //Слово в стринг для передачи в конструктор WordBase*/
        private var _lastTick:int = 0; //Последний тик таймера //Максимальное Delta-время
        public var _gun:GunBase = GunBase.getInstance(); //Пушка
        private var _word:WordBase;
        private var numberOfWords:int;
        private var levelManager:LevelManager;

        public var bullets:ObjectController;
        public var guns:ObjectController;

        private static var NUMBER_OF_WORDS_FIRST_LVL:uint = 10;


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

        public function endGame():void
        {
            _timerWord.stop();
/*          _timerWave.stop();
            _timerSlowly.stop();
            _timerWave.removeEventListener(TimerEvent.TIMER, create_new_wave);
            _timerSlowly.removeEventListener(TimerEvent.TIMER, create_new_slowly);*/
            _timerWord.removeEventListener(TimerEvent.TIMER, create_new_word);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler);
            this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            var allWordsOnLevel:ObjectController = LevelManager.getWords;
            for (var i:int = 0; i < allWordsOnLevel.objects.length; i++)
            {
                _word = LevelManager.getWords.objects[i];
                _word.stop();
            }
            bullets.clear();
            if (_gun.getHealth <= 0)
            {
                trace("Game over! You are dead!");
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

            levelManager = new LevelManager();
            levelManager.createLevel(NUMBER_OF_WORDS_FIRST_LVL); //Создаём уровень

            trace("Universe was created!");

            //words = new ObjectController();
            bullets = new ObjectController();
            guns = new ObjectController();
            _gun = new GunSimple();

            //_timerWave = new Timer(60000);
            //_timerSlowly = new Timer(80000);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler); //Слушатель на нажатие кнопки

            _timerWord.addEventListener(TimerEvent.TIMER, create_new_word); //Words timer
            _timerWord.start(); //Старт таймера
            //_timerWave.addEventListener(TimerEvent.TIMER, create_new_wave);
            //_timerSlowly.addEventListener(TimerEvent.TIMER, create_new_slowly);
            //_timerWave.start();
            //_timerSlowly.start();

            removeEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function enterFrameHandler(event:Event):void
        {
            //Расчёты Delta-времени для избежания ошибок в выводе графики при низких fps
            //getTimer() считает время с момента запуска приложения до вызова функции
            var _deltaTime:Number = (getTimer() - _lastTick) / 1000;
            var _maxDeltaTime:Number = 0.03;
            _deltaTime = (_deltaTime > _maxDeltaTime) ? _maxDeltaTime : _deltaTime;

            //Обновление всех объектов на экране
            bullets.update(_deltaTime);
            LevelManager.getWords.update(_deltaTime);
            guns.update(_deltaTime);

            if (numberOfWords <= 0 && LevelManager.getWords.objects.length == 0)
            {
                endGame();
            }
            //Запоминаем последний тик таймера
            _lastTick = getTimer();
        }

        //Функция создаёт рандомно слово по тику таймера
        private function create_new_word(event:TimerEvent):void
        {
            _word = levelManager.getRandomWordsArrayToOneLevel.pop();
            this.addChild(_word);
            trace(_word.wordSplitChars);
        }

        /*private function create_new_wave(event:TimerEvent):void
        {
            speedY = 100;
            trace("Prepare for battle! A new wave of words is coming!");

        }

        private function create_new_slowly(event:TimerEvent):void
        {
            speedY = 50;
            trace("Normal mode is enabled!");
            _timerWave.stop();
            _timerWave.start();

        }*/

        public function get word():WordBase
        {
            return _word;
        }

        //Функция получения ссылки на игровой мир
        public static function getInstance():Universe
        {
            return (_instance == null) ? new Universe() : _instance;
        }

        public function set timer(value:int):void
        {
            if (value != 0)
            {
                _timerWord = new Timer(value);
            }
        }

    }
}