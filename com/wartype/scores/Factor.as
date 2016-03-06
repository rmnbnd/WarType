package com.wartype.scores {
    import flash.display.MovieClip;

    public class Factor {

        private var _count:Number;
        private var _factorSprite:MovieClip;

        public function Factor() {
            _count = 1;
            resetFactor();
        }

        public function resetFactor():void {
            _factorSprite = new factorX1_mc();
            _factorSprite.x = ScoreConstants.FACTOR_SPRITE_X;
            _factorSprite.y = ScoreConstants.FACTOR_SPRITE_Y;
            _factorSprite.alpha = 0;
        }

        public function get count():Number {
            return _count;
        }

        public function set count(value:Number):void {
            _count = value;
        }

        public function get factorSprite():MovieClip {
            return _factorSprite;
        }

        public function set factorSprite(value:MovieClip):void {
            _factorSprite = value;
        }
    }
}
