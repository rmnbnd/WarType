package com.wartype
{
    import com.framework.math.Anumber;
    import com.wartype.controllers.ObjectController;
    import com.wartype.guns.GunBase;
    import com.wartype.guns.GunSimple;
    import com.wartype.levels.LevelManager;
    import com.wartype.words.*;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;

    public class Universe extends Sprite
    {
        public var bullets:ObjectController;
        public var guns:ObjectController;
        public var gun:GunBase = GunBase.getInstance();

        private var timerWord:Timer; //Таймер выпадения слов
        private var lastTick:int = 0; //Последний тик таймера //Максимальное Delta-время
        private var wordOnScene:WordBase;
        private var levelManager:LevelManager;
        private var levelTimer:Timer;
        private var levelNumberSprite:Sprite;
        private var levelNumberTextField:TextField;
        private var backgroundSprite:Sprite;

        private static const PATH_TO_JSON:String = ".\\com/wartype/resources/words.json";
        private static var _instance:Universe; //Ссылка на игровой мир
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
            timerWord.stop();
            levelTimer.stop();
            levelTimer.removeEventListener(TimerEvent.TIMER, prepareAndCreateLevel);
            timerWord.removeEventListener(TimerEvent.TIMER, create_new_word);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, gun.keyDownHandler);
            this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            var allWordsOnLevel:ObjectController = LevelManager.getWords;
            for (var i:int = 0; i < allWordsOnLevel.objects.length; i++)
            {
                wordOnScene = LevelManager.getWords.objects[i];
                wordOnScene.stop();
            }
            bullets.clear();
            trace("Game over! You are dead!");
        }

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

            createBackground();

            createLevelNumberTextField();

            levelManager = new LevelManager(words);
            createLevel();
            timerWord = new Timer(levelManager.getRandomWordsArrayToOneLevel[0].getThrowTimeWord);

            trace("Time to throw next word: " + timerWord.delay);
            traceLevelsBorder();

            bullets = new ObjectController();
            guns = new ObjectController();
            gun = new GunSimple();

            levelTimer = new Timer(60000);
            levelTimer.addEventListener(TimerEvent.TIMER, prepareAndCreateLevel);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, gun.keyDownHandler); //Слушатель на нажатие кнопки

            timerWord.addEventListener(TimerEvent.TIMER, create_new_word); //Words timer
            timerWord.start();
            levelTimer.start();

            removeEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function createBackground():void {
            backgroundSprite = new backgroundDesert_mc();
            backgroundSprite.y = 100;
            backgroundSprite.x = -90;
            if (backgroundSprite != null) {
                addChild(backgroundSprite);
            }
        }

        private static function traceLevelsBorder():void
        {
            trace("=========");
            trace("FIRST " + FIRST_LEVEL_BORDER);
            trace("SECOND " + SECOND_LEVEL_BORDER);
            trace("THIRD " + THIRD_LEVEL_BORDER);
            trace("FOURTH " + FOURTH_LEVEL_BORDER);
            trace("=========");
        }

        private function createLevelNumberTextField():void
        {
            levelNumberSprite = new numberlevel_mc();
            levelNumberSprite.x = 100;
            levelNumberSprite.y = 100;
            if (levelNumberSprite != null)
            {
                addChild(levelNumberSprite);
            }

            if (levelNumberSprite["text"] != null)
            {
                levelNumberTextField = levelNumberSprite["text"] as TextField;
            }
        }

        private static function prepareVariablesToNewLevel():void
        {
            TYPING_SPEED += 10;

            if(FIRST_LEVEL_BORDER < 1 && SECOND_LEVEL_BORDER < 1 && THIRD_LEVEL_BORDER < 1 &&
                FOURTH_LEVEL_BORDER < 1)
            {
                if(FIRST_LEVEL_BORDER > 0)
                {
                    FIRST_LEVEL_BORDER = Anumber.toFixedNumber(FIRST_LEVEL_BORDER, 1, "minus", 0.2);
                    SECOND_LEVEL_BORDER = Anumber.toFixedNumber(SECOND_LEVEL_BORDER, 1, "plus", 0.1);
                    THIRD_LEVEL_BORDER = Anumber.toFixedNumber(THIRD_LEVEL_BORDER, 1, "plus", 0.1);
                }
                else if(SECOND_LEVEL_BORDER > 0)
                {
                    SECOND_LEVEL_BORDER = Anumber.toFixedNumber(SECOND_LEVEL_BORDER, 1, "minus", 0.1);
                    THIRD_LEVEL_BORDER = 0.5;
                    FOURTH_LEVEL_BORDER = Anumber.toFixedNumber(FOURTH_LEVEL_BORDER, 1, "plus", 0.1);
                } else
                {
                    THIRD_LEVEL_BORDER = Anumber.toFixedNumber(THIRD_LEVEL_BORDER, 1, "minus", 0.1);
                    FOURTH_LEVEL_BORDER = Anumber.toFixedNumber(FOURTH_LEVEL_BORDER, 1, "plus", 0.1);
                }
            }

            traceLevelsBorder();
        }

        private function prepareAndCreateLevel(event:TimerEvent):void
        {
            prepareVariablesToNewLevel();
            createLevel();
            LEVEL_NUMBER++;
        }

        private function createLevel():void
        {
            trace("Level " + LEVEL_NUMBER + " created!");
            levelManager.createLevel(TYPING_SPEED, FIRST_LEVEL_BORDER, SECOND_LEVEL_BORDER, THIRD_LEVEL_BORDER,
                    FOURTH_LEVEL_BORDER);
        }

        private function enterFrameHandler(event:Event):void
        {
            levelNumberTextField.text = "Level " + LEVEL_NUMBER;
            //Расчёты Delta-времени для избежания ошибок в выводе графики при низких fps
            //getTimer() считает время с момента запуска приложения до вызова функции
            var _deltaTime:Number = (getTimer() - lastTick) / 1000;
            var _maxDeltaTime:Number = 0.03;
            _deltaTime = (_deltaTime > _maxDeltaTime) ? _maxDeltaTime : _deltaTime;

            //Обновление всех объектов на экране
            bullets.update(_deltaTime);
            LevelManager.getWords.update(_deltaTime);
            guns.update(_deltaTime);

            //Запоминаем последний тик таймера
            lastTick = getTimer();
        }

        //Функция создаёт рандомно слово по тику таймера
        private function create_new_word(event:TimerEvent):void
        {
			trace("WORDS IN ARRAY: " + levelManager.getRandomWordsArrayToOneLevel.length);
            if(levelManager.getRandomWordsArrayToOneLevel.length != 0)
            {
                wordOnScene = levelManager.getRandomWordsArrayToOneLevel.shift();
                this.addChildAt(wordOnScene, 1);
                this.setChildIndex(gun, 1);
                trace(wordOnScene.wordSplitChars);
                if(levelManager.getRandomWordsArrayToOneLevel.length > 0)
                {
                    trace("Next word: " + levelManager.getRandomWordsArrayToOneLevel[0].wordSplitChars);
                    timerWord.delay = levelManager.getRandomWordsArrayToOneLevel[0].getThrowTimeWord;
                    trace(timerWord.delay);
                }
            }
        }

        public function get getWordOnScene():WordBase
        {
            return wordOnScene;
        }

        public static function getInstance():Universe
        {
            return (_instance == null) ? new Universe() : _instance;
        }
    }
}