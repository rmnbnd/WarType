package com.wartype
{
import com.wartype.words.WordBase;

import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.KeyboardEvent;

    public class Game extends Sprite
    {
        private var universe:Universe;
        private var currentSpeed:int;
        private var wordOnScene:WordBase = Universe.getInstance().getWordOnScene;

        public function Game(stage:Stage)
        {
            trace("Game class is created!");

            universe = new Universe();
            addChild(universe);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, getMoreSpeed); //Dev only, get more speed for words
            stage.addEventListener(KeyboardEvent.KEY_UP, getBackToNormSpeed); //Dev only, get more speed for words
                                                                              //use Arrow-down key
        }

        private function getMoreSpeed(event:KeyboardEvent):void
        {
            if(wordOnScene != null && String.fromCharCode(event.keyCode) == "(")
            {
                currentSpeed = wordOnScene.speedY;
                wordOnScene.speedY = 500;
            }
        }

        private function getBackToNormSpeed(event:KeyboardEvent):void
        {
            if(wordOnScene != null && String.fromCharCode(event.keyCode) == "(")
            {
                wordOnScene.speedY = currentSpeed;
            }
        }
    }
}