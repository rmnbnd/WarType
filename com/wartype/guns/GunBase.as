package com.wartype.guns
{

    import com.wartype.App;
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
        protected var _body:MovieClip; //Постамент пушки
        protected var _head:MovieClip; //Дуло пушки
        protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
        protected var _wordTarget:WordBase; //Ссылка на слово-цель
        protected var _bulletSpeed:Number;
        protected var _isFree:Boolean = true;
        protected var _health:uint;
        protected var _textFieldGun:TextField;
        protected var _textSprite:Sprite;
        private var _word:WordBase; //Ссылка на слово
        internal var _key:String; //Нажатая кнопка
        public static var isAttackedWord:Boolean; //Флаг, указывающий,
        //было ли атаковано слово (для захвата ссылки на объект)
        private static var _instanceGun:GunBase;
        private static var wordsEnemies:Array;

        private static const OFFSET_PX_TO_START_OF_SCENE:uint = 50;
		private static const SPACE_CODE:int = 32;

        public function GunBase()
        {}

        //Инициализируем пушку
        public function init():void
        {
            wordsEnemies = LevelManager.getWords.objects;
            _instanceGun = this;
            if (_body != null && _head != null && _textSprite != null)
            {
                addChild(_body);
                addChild(_head);
                addChild(_textSprite);
            }
            if (_textSprite["text"] != null)
            {
                _textFieldGun = _textSprite["text"] as TextField;
            }

            x = App.SCRN_WIDTH_HALF;
            y = App.SCR_HEIGHT - this.height * 1.1;
            _head.rotation = 270; //Разворачиваем пушку, т.к изначально она стоит дулом вправо (0 deg)

            _isFree = false;

            _universe.guns.add(this); //Добавляем в контейнер пушку (ObjectController)
            _universe.addChild(this);
        }

        public function update(delta:Number):void
        {
            _textFieldGun.text = "HP:" + _health.toString();
            if (_health <= 0 || wordsEnemies.length == 0)
            {
                _universe.endGame();
            }
        }

        public function free():void
        {
            if (_body && contains(_body))
            {
                removeChild(_body);
            }
            if (_head && contains(_head))
            {
                removeChild(_head);
            }
            _universe.removeChild(this);
        }

        //Функция-обработчик события нажатия на кнопку
        public function keyDownHandler(event:KeyboardEvent):void
        {
            _key = String.fromCharCode(event.keyCode);
            if (isAttackedWord == false)
            {
                for (var i:int = wordsEnemies.length - 1; i >= 0; --i)
                {
                    _word = wordsEnemies[i];

                    if (_key == _word.wordSplitChars[0] && _word.stage &&
                            _word.y > OFFSET_PX_TO_START_OF_SCENE)
                    {
                        _wordTarget = _word;
                    }
                }
            }
            if (event.keyCode == SPACE_CODE)
            {
                isAttackedWord = false;
                _wordTarget.unselectWord();
                return;
            }
            if (_wordTarget == null) {
                return;
            }
            if (_wordTarget.y >= App.SCR_HEIGHT)
            {
                isAttackedWord = false;
                _wordTarget = null;
                return;

            }
            else if (_wordTarget.isDead == true)
            {
                isAttackedWord = false;
                _wordTarget = null;
                return;
            }
            if (_key != _wordTarget.wordSplitChars[0]) {
                return;
            }
            _wordTarget.isAttacked = true;
            _wordTarget.isSelected = true;
            if (_wordTarget.isAttacked == true) {
                isAttackedWord = true;
            }

            //update our player location parameters
            var playerX:Number = this.x;
            var playerY:Number = this.y;

            //calculate player_mc rotation
            var rotationDirection:Number = Math.round(180 - ((Math.atan2(_wordTarget.x - playerX,
                            _wordTarget.y - playerY)) * 180 / Math.PI));

            //set rotation
            this.rotation = rotationDirection;

            _wordTarget.damage();
            shoot();
        }

        //Функция выстрела
        private function shoot():void
        {
            var bullet:BulletSimple = new BulletSimple();
            bullet.init(this.x, this.y, _bulletSpeed, this.rotation);
        }

        public static function getInstance():GunBase
        {
            return _instanceGun;
        }

        public function set setHealth(value:Number):void
        {
            _health -= value;
        }

        public function get getHealth():int
        {
            return _health;
        }

    }
}