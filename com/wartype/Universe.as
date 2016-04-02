package com.wartype
{
    import com.framework.math.Anumber;
    import com.wartype.controllers.ObjectController;
    import com.wartype.explosions.BigExplosion;
    import com.wartype.explosions.MediumExplosion;
    import com.wartype.guns.GunBase;
    import com.wartype.guns.GunConstants;
    import com.wartype.guns.GunSimple;
    import com.wartype.levels.LevelManager;
    import com.wartype.menu.bar.StatusBar;
    import com.wartype.scores.Score;
    import com.wartype.scores.ScoreConstants;
    import com.wartype.words.*;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
    import caurina.transitions.Tweener;

    public class Universe extends Sprite
    {
        public var bullets:ObjectController;
        public var guns:ObjectController;
        public var gun:GunBase = GunBase.getInstance();
        public var score:Score;

        private var timerWord:Timer; //Таймер выпадения слов
        private var lastTick:int = 0; //Последний тик таймера //Максимальное Delta-время
        private var wordOnScene:WordBase;
        private var levelManager:LevelManager;
        private var levelNumberSprite:Sprite;
        private var levelNumberTextField:TextField;
        private var backgroundSprite:Sprite;
        private var timerBetweenLevels:Timer;
        private var isStopGame:Boolean;
        private var timerBetweenLevelsWasRunning:Boolean;
        private var pauseBoardSprite:Sprite;
        private var pauseBoardTextField:TextField;
        private var charsPerMinuteSprite:Sprite;
        private var charsPerMinuteField:TextField;
        private var textFieldGun:TextField;
        private var healthSprite:Sprite;
        private var textFieldScore:TextField;
        private var scoreSprite:Sprite;
        private var mediumExplosion:MediumExplosion;
        private var bigExplosion:BigExplosion;
        private var game:Game;
        private var statusBar:StatusBar;
        private var blurFilter:BlurFilter;

        [Embed(source="../../assets/json/words.json", mimeType="application/octet-stream")]
        private var jsonData:Class;

        private static var _instance:Universe;

        public function Universe(game:Game = null)
        {
            this.game = game;
            if (stage)
            {
                init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }

        public function stopGame():void
        {
            isStopGame = true;
            if(timerBetweenLevelsWasRunning)
            {
                timerBetweenLevels.stop();
            }
            timerWord.stop();
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, gun.keyDownHandler);
            this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            var allWordsOnLevel:ObjectController = LevelManager.getWords;
            for (var i:int = 0; i < allWordsOnLevel.objects.length; i++)
            {
                wordOnScene = allWordsOnLevel.objects[i];
                wordOnScene.stop();
            }
            for (var j:int = 0; j < bullets.objects.length; j++)
            {
                bullets.objects[j].stop();
            }
            createPauseBoardTextField();
        }

        public function resetGame():void
        {
            isStopGame = false;
            if(timerBetweenLevelsWasRunning)
            {
                timerBetweenLevels.start();
            }
            timerWord.start();
            stage.addEventListener(KeyboardEvent.KEY_DOWN, gun.keyDownHandler);
            this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            var allWordsOnLevel:ObjectController = LevelManager.getWords;
            for (var i:int = 0; i < allWordsOnLevel.objects.length; i++)
            {
                wordOnScene = allWordsOnLevel.objects[i];
                wordOnScene.start();
            }
            for (var j:int = 0; j < bullets.objects.length; j++)
            {
                bullets.objects[j].start();
            }
            deletePauseBoardTextField();
        }

        public function endGame():void
        {
            timerWord.stop();
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
            gun.resetIsAttackedWord();
            statusBar.removeEventListeners();
            createGameOverScreen();
            trace("Game over! You are dead!");
        }

        private function init(event:Event = null):void
        {
            _instance = this;

            var myTextLoader:URLLoader = new URLLoader();
            myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
            myTextLoader.load(new URLRequest(MainConstants.PATH_TO_JSON));

            trace("Universe was created!");
        }

        private function onLoaded(e:Event):void {
            var words:Array = JSON.parse(new jsonData()) as Array;
            createBackground();

            statusBar = new StatusBar();

            createLevelNumberTextField();
            createHealthTextField();
            createScoreTextField();

            levelManager = new LevelManager(words);
            createLevel();
            timerWord = new Timer(levelManager.getRandomWordsArrayToOneLevel[0].getThrowTimeWord);

            trace("Time to throw next word: " + timerWord.delay);
            traceLevelsBorder();

            bullets = new ObjectController();
            guns = new ObjectController();
            gun = new GunSimple();
            score = new Score();

            if(score.getFactor.factorSprite != null)
            {
                addChild(score.getFactor.factorSprite);
                Tweener.addTween(score.getFactor.factorSprite, { alpha: 1, time: 3} );
            }

            mediumExplosion = new MediumExplosion(this);
            bigExplosion = new BigExplosion(this);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, gun.keyDownHandler);

            timerWord.addEventListener(TimerEvent.TIMER, create_new_word);
            timerWord.start();

            timerBetweenLevels = new Timer(5000);
            timerBetweenLevels.addEventListener(TimerEvent.TIMER, prepareAndCreateNewLevel);

            createCharsPerMinuteBoard();

            removeEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function createGameOverScreen():void
        {
            blurFilter = new BlurFilter();
            blurFilter.blurX = 2.95;
            blurFilter.blurY = 2.95;
            blurFilter.quality = BitmapFilterQuality.HIGH;
            backgroundSprite.filters = [blurFilter];
            gun.filters = [blurFilter];
            var allWordsOnLevel:ObjectController = LevelManager.getWords;
            for (var i:int = 0; i < allWordsOnLevel.objects.length; i++)
            {
                wordOnScene = LevelManager.getWords.objects[i];
                wordOnScene.filters = [blurFilter];
            }
            game.openGameOverScreen(score.getCount);
            getMediumExplosion.blurExplosion();
            getBigExplosion.blurExplosion();
        }

        private function createPauseBoardTextField():void
        {
            pauseBoardSprite = new pauseBoard_mc();
            pauseBoardSprite.name = "pauseBoard";
            pauseBoardSprite.x = MainConstants.SCRN_WIDTH_HALF;
            pauseBoardSprite.y = MainConstants.SCRN_HEIGHT_HALF;
            if (pauseBoardSprite != null)
            {
                addChild(pauseBoardSprite);
            }

            if (pauseBoardSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                pauseBoardTextField = pauseBoardSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
            pauseBoardTextField.text = MainConstants.PAUSE_TEXT;
            pauseBoardTextField.alpha = 0.8;
        }

        private function createCharsPerMinuteBoard():void
        {
            charsPerMinuteSprite = new charsPerMinuteText_mc();
            charsPerMinuteSprite.x = MainConstants.CHARS_PER_MINUTE_POSITION_X;
            charsPerMinuteSprite.y = MainConstants.CHARS_PER_MINUTE_POSITION_Y;
            if (charsPerMinuteSprite != null)
            {
                addChild(charsPerMinuteSprite);
            }

            if (charsPerMinuteSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                charsPerMinuteField = charsPerMinuteSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
            var charsPerMinuteText:String = String(MainConstants.TYPING_SPEED);
            charsPerMinuteField.text = charsPerMinuteText;
        }

        private function deletePauseBoardTextField():void
        {
            if(getChildByName("pauseBoard") != null)
            {
                removeChild(pauseBoardSprite);
            }
        }

        private function createBackground():void {
            backgroundSprite = new backgroundDesert_mc();
            if (backgroundSprite != null) {
                addChild(backgroundSprite);
            }
        }

        private function createHealthTextField():void {
            healthSprite = new gunHealth_mc();
            healthSprite.x = MainConstants.HEALTH_TEXT_FIELD_X;
            healthSprite.y = MainConstants.HEALTH_TEXT_FIELD_Y;
            if (healthSprite != null) {
                addChild(healthSprite);
            }
            if (healthSprite[GunConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                textFieldGun = healthSprite[GunConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
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

        private function createScoreTextField():void
        {
            scoreSprite = new scoreSprite_mc();
            scoreSprite.x = ScoreConstants.SCORE_SPRITE_X;
            scoreSprite.y = ScoreConstants.SCORE_SPRITE_Y;
            if (scoreSprite != null)
            {
                addChild(scoreSprite);
            }

            if (scoreSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                textFieldScore = scoreSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
            textFieldScore.text = ScoreConstants.SCORE_DEFAULT_TEXT;
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
                            Anumber.toFixedNumber(MainConstants.THIRD_LEVEL_BORDER, 1, MainConstants.PLUS, 0.1);
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

        private function createTimerBetweenLevels():void
        {
            timerWord.stop();
            timerBetweenLevels.start();
            timerBetweenLevelsWasRunning = true;
            trace("Preparing to new level...");
        }

        private function prepareAndCreateNewLevel(event:TimerEvent):void
        {
            MainConstants.LEVEL_NUMBER++;
            timerBetweenLevels.stop();
            timerWord.start();
            prepareVariablesToNewLevel();
            createLevel();
            timerBetweenLevelsWasRunning = false;
            charsPerMinuteField.text = String(MainConstants.TYPING_SPEED);
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
            mediumExplosion.update();
            bigExplosion.update();
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
            else
            {
                createTimerBetweenLevels();
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

        public function get getIsStopGame():Boolean
        {
            return isStopGame;
        }

        public function get getScore():Score
        {
            return this.score;
        }

        public function get getMediumExplosion():MediumExplosion {
            return mediumExplosion;
        }

        public function get getBigExplosion():BigExplosion {
            return bigExplosion;
        }

        public function get getTextFieldGun():TextField {
            return textFieldGun;
        }

        public function get getTextFieldScore():TextField {
            return textFieldScore;
        }
    }
}