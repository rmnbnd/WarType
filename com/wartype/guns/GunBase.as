package com.wartype.guns
{
    import com.framework.math.Amath;
    import com.wartype.MainConstants;
    import com.wartype.Universe;
    import com.wartype.bullets.BulletSimple;
    import com.wartype.interfaces.IObject;
    import com.wartype.levels.LevelManager;
    import com.wartype.words.WordBase;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;

    public class GunBase extends Sprite implements IObject
    {
        protected var body:MovieClip;
        protected var head:MovieClip;
        protected var universe:Universe = Universe.getInstance();
        protected var wordTarget:WordBase;
        protected var bulletSpeed:Number;
        protected var isFree:Boolean = true;
        protected var health:uint;
        protected var textFieldGun:TextField;
        protected var healthSprite:Sprite;
        private var word:WordBase;
        private var key:String; //Нажатая кнопка
        private var bullet:BulletSimple;
        public static var isAttackedWord:Boolean; //Флаг, указывающий,
        //было ли атаковано слово (для захвата ссылки на объект)
        private static var instanceGun:GunBase;
        private static var wordsEnemies:Array;

        public function GunBase()
        {}

        public function init():void
        {
            wordsEnemies = LevelManager.getWords.objects;
            instanceGun = this;
            if (body != null && head != null && healthSprite != null)
            {
                addChild(body);
                addChild(head);
                addChild(healthSprite);
            }
            x = MainConstants.SCRN_WIDTH_HALF;

            if (healthSprite[GunConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                textFieldGun = healthSprite[GunConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
            y = MainConstants.SCR_HEIGHT - this.height * GunConstants.COEF_HEIGHT_GUN_ON_THE_SCREEN;
            head.rotation = GunConstants.GUN_ROTATION; //Разворачиваем пушку, т.к изначально она стоит дулом вправо (0 deg)

            isFree = false;

            universe.guns.add(this); //Добавляем в контейнер пушку (ObjectController)
            universe.addChild(this);
        }

        public function update(delta:Number):void
        {
            textFieldGun.text = GunConstants.HEALTH_TEXT + health.toString();
            if (health <= 0)
            {
                universe.endGame();
            }
        }

        public function free():void
        {
            if (body && contains(body))
            {
                removeChild(body);
            }
            if (head && contains(head))
            {
                removeChild(head);
            }
            universe.removeChild(this);
        }

        //Функция-обработчик события нажатия на кнопку
        public function keyDownHandler(event:KeyboardEvent):void
        {
            if(event.ctrlKey)
            {
                return;
            }
            key = String.fromCharCode(event.keyCode);
            var minDistance:Number = Number.MAX_VALUE;
            var wordWithMinDistance:WordBase;
            var wordsWithSameStartChars:Array = [];
            if (isAttackedWord == false)
            {
                wordsWithSameStartChars = selectWordsWithSameStartChars();
                for(var j:int = wordsWithSameStartChars.length - 1; j >= 0; --j)
                {
                    var distance:Number = distanceBetweenTwoPoints(wordsWithSameStartChars[j].x, this.x,
                            wordsWithSameStartChars[j].y, this.y);
                    if(distance < minDistance) {
                        minDistance = distance;
                        wordWithMinDistance = wordsWithSameStartChars[j];
                    }
                }
                for (var i:int = wordsEnemies.length - 1; i >= 0; --i)
                {
                    word = wordsEnemies[i];
                    if (isTarget(word.wordSplitChars[0]))
                    {
                        if(wordWithMinDistance != null) {
                            wordTarget = wordWithMinDistance;
                            break;
                        }
                        wordTarget = word;
                        break;
                    }
                }
            }
            if (event.keyCode == GunConstants.SPACE_CODE)
            {
                isAttackedWord = false;
                if(wordTarget != null) {
                    wordTarget.unselectWord();
                }
                if (bullet != null && bullet.getIsFree()) 
                {
                    wordTarget.unatackedWord();
                }
                return;
            }
            if (wordTarget == null) {
                return;
            }
            if (wordTarget.y >= MainConstants.SCR_HEIGHT)
            {
                isAttackedWord = false;
                wordTarget = null;
                return;

            }
            else if (wordTarget.isDead == true)
            {
                isAttackedWord = false;
                wordTarget = null;
                return;
            }
            if (key != wordTarget.wordSplitChars[0]) {
                if(wordTarget.isAttacked)
                {
                    wordTarget.boost();
                    universe.getScore.resetFactor();
                }
                return;
            }
            wordTarget.isAttacked = true;
            wordTarget.isSelected = true;
            if (wordTarget.isAttacked == true) {
                isAttackedWord = true;
            }

            //update our player location parameters
            var playerX:Number = this.x;
            var playerY:Number = this.y;

            //calculate player_mc rotation
            var rotationDirection:Number = Math.round(Amath.STRAIGHT_ANGLE - ((Math.atan2(wordTarget.x - playerX,
                            wordTarget.y - playerY)) * Amath.STRAIGHT_ANGLE / Math.PI));

            //set rotation
            this.rotation = rotationDirection;

            wordTarget.damage();
            shoot(wordTarget);
        }

        private function selectWordsWithSameStartChars():Array {
            var wordsWithSameStartChars:Array = [];
            for (var k:int = wordsEnemies.length - 1; k >= 0; --k) {
                word = wordsEnemies[k];
                if (isTarget(word.wordSplitChars[0])) {
                    wordsWithSameStartChars.push(word);
                }
            }
            return wordsWithSameStartChars;
        }

        private function isTarget(char:String):Boolean {
            return key == char && word.stage &&
                    word.y > GunConstants.OFFSET_PX_TO_START_OF_SCENE;
        }

        private function shoot(wordTarget:WordBase):void
        {
            bullet = new BulletSimple();
            bullet.init(this.x, this.y, bulletSpeed, this.rotation, wordTarget);
            universe.getScore.inc();
        }

        private function distanceBetweenTwoPoints(x1:Number, x2:Number, y1:Number, y2:Number):Number {
            var dx:Number = x1-x2;
            var dy:Number = y1-y2;
            return Math.sqrt(dx * dx + dy * dy);
        }

        public static function getInstance():GunBase
        {
            return instanceGun;
        }

        public function set setHealth(value:Number):void
        {
            health -= value;
        }

        public function get getHealth():int
        {
            return health;
        }

    }
}