package com.wartype
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.KeyboardEvent;

    public class Game extends Sprite
    {
        private var universe:Universe;
        private var currentSpeed:int;

        public function Game(stage:Stage)
        {
            trace("Game class is created!");

            universe = new Universe();
            addChild(universe);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, getMoreSpeed); //Dev only, get more speed for words
            stage.addEventListener(KeyboardEvent.KEY_UP, getBackToNormSpeed); //Dev only, get more speed for words
        }

        private function getMoreSpeed(event:KeyboardEvent):void
        {
            if(universe.word != null && String.fromCharCode(event.keyCode) == "(")
            {
                currentSpeed = universe.word.speedY;
                universe.word.speedY = 500;
            }
        }

        private function getBackToNormSpeed(event:KeyboardEvent):void
        {
            if(universe.word != null && String.fromCharCode(event.keyCode) == "(")
            {
                universe.word.speedY = currentSpeed;
            }
        }

        private static function get universe():Universe
        {
            return universe;
        }
    }
}