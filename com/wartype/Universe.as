package com.wartype
{
    import com.framework.math.Anumber;
    import com.wartype.MainConstants;
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

        private static var _instance:Universe;

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
            myTextLoader.load(new URLRequest(MainConstants.PATH_TO_JSON));

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
            trace("FIRST " + MainConstants.FIRST_LEVEL_BORDER);
            trace("SECOND " + MainConstants.SECOND_LEVEL_BORDER);
            trace("THIRD " + MainConstants.THIRD_LEVEL_BORDER);
            trace("FOURTH " + MainConstants.FOURTH_LEVEL_BORDER);
            trace("=========");
        }

        private function createLevelNumberTextField():void
        {
            levelNumberSprite = new numberlevel_mc();
            levelNumberSprite.x = MainConstants.LEVEL_NUMBER_POSITION_X;
            levelNumberSprite.y = MainConstants.LEVEL_NUMBER_POSITION_Y;
            if (levelNumberSprite != null)
            {
                addChild(levelNumberSprite);
            }

            if (levelNumberSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                levelNumberTextField = levelNumberSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
        }

        private static function prepareVariablesToNewLevel():void
        {
            MainConstants.TYPING_SPEED += MainConstants.WORD_SPEED_ITERATION;

            if(MainConstants.FIRST_LEVEL_BORDER < 1 && MainConstants.SECOND_LEVEL_BORDER < 1 &&
                    MainConstants.THIRD_LEVEL_BORDER < 1 && MainConstants.FOURTH_LEVEL_BORDER < 1)
            {
                if(MainConstants.FIRST_LEVEL_BORDER > 0)
                {
                    MainConstants.FIRST_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.FIRST_LEVEL_BORDER, 1, MainConstants.MINUS, 0.2);
                    MainConstants.SECOND_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.SECOND_LEVEL_BORDER, 1, MainConstants.PLUS, 0.1);
                    MainConstants.THIRD_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.THIRD_LEVEL_BORDER, 1, MainConstants.MINUS, 0.1);
                }
                else if(MainConstants.SECOND_LEVEL_BORDER > 0)
                {
                    MainConstants.SECOND_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.SECOND_LEVEL_BORDER, 1, MainConstants.MINUS, 0.1);
                    MainConstants.THIRD_LEVEL_BORDER = 0.5;
                    MainConstants.FOURTH_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.FOURTH_LEVEL_BORDER, 1, MainConstants.PLUS, 0.1);
                } else
                {
                    MainConstants.THIRD_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.THIRD_LEVEL_BORDER, 1, MainConstants.MINUS, 0.1);
                    MainConstants.FOURTH_LEVEL_BORDER =
                            Anumber.toFixedNumber(MainConstants.FOURTH_LEVEL_BORDER, 1, MainConstants.PLUS, 0.1);
                }
            }

            traceLevelsBorder();
        }

        private function prepareAndCreateLevel(event:TimerEvent):void
        {
            prepareVariablesToNewLevel();
            createLevel();
            MainConstants.LEVEL_NUMBER++;
        }

        private function createLevel():void
        {
            trace("Level " + MainConstants.LEVEL_NUMBER + " created!");
            levelManager.createLevel(MainConstants.TYPING_SPEED, MainConstants.FIRST_LEVEL_BORDER,
                    MainConstants.SECOND_LEVEL_BORDER, MainConstants.THIRD_LEVEL_BORDER,
                    MainConstants.FOURTH_LEVEL_BORDER);
        }

        private function enterFrameHandler(event:Event):void
        {
            levelNumberTextField.text = MainConstants.LEVEL_STATIC_TEXT + MainConstants.LEVEL_NUMBER;
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