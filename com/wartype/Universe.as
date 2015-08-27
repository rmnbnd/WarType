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
    import flash.net.URLLoader;
    import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;

    public class Universe extends Sprite
    {
        private static var _instance:Universe; //Ссылка на игровой мир
        private var _timerWord:Timer; //Таймер выпадения слов
        private var _lastTick:int = 0; //Последний тик таймера //Максимальное Delta-время
        public var _gun:GunBase = GunBase.getInstance(); //Пушка
        private var _word:WordBase;
        private var levelManager:LevelManager;
        private var levelTimer:Timer;

        public var bullets:ObjectController;
        public var guns:ObjectController;

        private static const PATH_TO_JSON:String = ".\\com/wartype/resources/words.json";
        private static var LEVEL_NUMBER:uint = 1;

        private static var TYPING_SPEED:uint = 90;
        private static var FIRST_LEVEL_BORDER:Number = 0.9;
        private static var SECOND_LEVEL_BORDER:Number = 0.1;
        private static var THIRD_LEVEL_BORDER:Number = 0.0;
        private static var FOURTH_LEVEL_BORDER:Number = 0.0;


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
            levelTimer.stop();
            levelTimer.removeEventListener(TimerEvent.TIMER, create_new_level);
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

            var myTextLoader:URLLoader = new URLLoader();
            myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
            myTextLoader.load(new URLRequest(PATH_TO_JSON));

            trace("Universe was created!");
        }
        
        private function onLoaded(e:Event):void {
			var words:Array = com.adobe.serialization.json.JSON.decode(e.target.data);
			
            levelManager = new LevelManager(words);
            levelManager.createLevel(TYPING_SPEED, FIRST_LEVEL_BORDER, SECOND_LEVEL_BORDER, THIRD_LEVEL_BORDER,
                                        FOURTH_LEVEL_BORDER);
            trace("Level " + LEVEL_NUMBER + " created!");

            trace("=========");
            trace("FIRST " + FIRST_LEVEL_BORDER);
            trace("SECOND " + SECOND_LEVEL_BORDER);
            trace("THIRD " + THIRD_LEVEL_BORDER);
            trace("FOURTH " + FOURTH_LEVEL_BORDER);
            trace("=========");

            bullets = new ObjectController();
            guns = new ObjectController();
            _gun = new GunSimple();

            //_timerWave = new Timer(60000);
            //_timerSlowly = new Timer(80000);
            levelTimer = new Timer(60000);
            levelTimer.addEventListener(TimerEvent.TIMER, create_new_level);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _gun.keyDownHandler); //Слушатель на нажатие кнопки

            _timerWord.addEventListener(TimerEvent.TIMER, create_new_word); //Words timer
            _timerWord.start(); //Старт таймера
            //_timerWave.addEventListener(TimerEvent.TIMER, create_new_wave);
            //_timerSlowly.addEventListener(TimerEvent.TIMER, create_new_slowly);
            //_timerWave.start();
            //_timerSlowly.start();
            levelTimer.start();

            removeEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function prepareVariablesToNewLevel():void
        {
            TYPING_SPEED += 10;

            if(FIRST_LEVEL_BORDER < 1 && SECOND_LEVEL_BORDER < 1 && THIRD_LEVEL_BORDER < 1 &&
                FOURTH_LEVEL_BORDER < 1)
            {
                if(FIRST_LEVEL_BORDER > 0)
                {
                    FIRST_LEVEL_BORDER = toFixedNumber(FIRST_LEVEL_BORDER, 1, "minus", 0.2);
                    SECOND_LEVEL_BORDER = toFixedNumber(SECOND_LEVEL_BORDER, 1, "plus", 0.1);
                    THIRD_LEVEL_BORDER = toFixedNumber(THIRD_LEVEL_BORDER, 1, "plus", 0.1);
                }
                else if(SECOND_LEVEL_BORDER > 0)
                {
                    SECOND_LEVEL_BORDER = toFixedNumber(SECOND_LEVEL_BORDER, 1, "minus", 0.1);
                    THIRD_LEVEL_BORDER = 0.5;
                    FOURTH_LEVEL_BORDER = toFixedNumber(FOURTH_LEVEL_BORDER, 1, "plus", 0.1);
                } else
                {
                    THIRD_LEVEL_BORDER = toFixedNumber(THIRD_LEVEL_BORDER, 1, "minus", 0.1);
                    FOURTH_LEVEL_BORDER = toFixedNumber(FOURTH_LEVEL_BORDER, 1, "plus", 0.1);
                }
            }
            trace("=========");
            trace("FIRST " + FIRST_LEVEL_BORDER);
            trace("SECOND " + SECOND_LEVEL_BORDER);
            trace("THIRD " + THIRD_LEVEL_BORDER);
            trace("FOURTH " + FOURTH_LEVEL_BORDER);
            trace("=========");
        }

        private function toFixedNumber(number:Number, decPlaces:Number, sign:String, value:Number):Number
        {
            var resultNumber:Number = number;
            if("plus" == sign)
            {
                resultNumber += value;
                return Number(resultNumber.toFixed(decPlaces));
            }
            else if("minus" == sign)
            {
                resultNumber -= value;
                return Number(resultNumber.toFixed(decPlaces));
            }
            return 0;
        }

        private function create_new_level(event:TimerEvent):void
        {
            trace("Level " + ++LEVEL_NUMBER + " created!");
            prepareVariablesToNewLevel();
            levelManager.createLevel(TYPING_SPEED, FIRST_LEVEL_BORDER, SECOND_LEVEL_BORDER, THIRD_LEVEL_BORDER,
                                        FOURTH_LEVEL_BORDER);
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

            //Запоминаем последний тик таймера
            _lastTick = getTimer();
        }

        //Функция создаёт рандомно слово по тику таймера
        private function create_new_word(event:TimerEvent):void
        {
            if(levelManager.getRandomWordsArrayToOneLevel.length != 0)
            {
                _word = levelManager.getRandomWordsArrayToOneLevel.pop();
                this.addChild(_word);
                trace(_word.wordSplitChars);
            }
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