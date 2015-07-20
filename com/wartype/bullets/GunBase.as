package com.wartype.bullets
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    import com.wartype.Universe;
    import com.wartype.App;
    import com.wartype.words.WordBase;
    import com.wartype.interfaces.IObject;

    import flash.text.TextField;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;

    public class GunBase extends Sprite implements IObject
    {
        protected var _body:MovieClip; //Постамент пушки
        protected var _head:MovieClip; //Дуло пушки
        protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
        protected var _wordTarget:WordBase; //Ссылка на слово-цель
        protected var _bulletSpeed:Number = 100;
        protected var _isFree:Boolean = true;
        protected var _health:uint = 100;
        protected var _textFieldGun:TextField;
        protected var _textSprite:Sprite;


        public function GunBase()
        {
            //nothing
        }

        //Инициализируем пушку
        public function init():void
        {
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
            y = App.SCR_HEIGHT - this.height * 1.5;

            _isFree = false;

            _universe.guns.add(this); //Добавляем в контейнер пушку (ObjectController)
            _universe.addChild(this);
        }

        public function update(delta:Number):void
        {
            _textFieldGun.text = "HP:" + _health.toString();
            if (_health <= 0)
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

    }
}