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

        public function Game(stage:Stage)
        {
            trace("Game class is created!");

            universe = new Universe();
            addChild(universe);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownAction); //Dev only, get more speed for words
            stage.addEventListener(KeyboardEvent.KEY_UP, getBackToNormSpeed); //Dev only, get more speed for words
                                                                              //use Arrow-down key
        }

        private function keyDownAction(event:KeyboardEvent):void
        {
            var wordOnScene:WordBase = Universe.getInstance().getWordOnScene;
            if(wordOnScene != null && String.fromCharCode(event.keyCode) == "(")
            {
                currentSpeed = wordOnScene.getSpeedY;
                wordOnScene.setSpeedY = 500;
            }
            if(event.ctrlKey)
            {
                if(!universe.getIsStopGame)
                {
                    universe.stopGame();
                }
                else
                {
                    universe.resetGame();
                }
            }
        }

        private function getBackToNormSpeed(event:KeyboardEvent):void
        {
            var wordOnScene:WordBase = Universe.getInstance().getWordOnScene;
            if(wordOnScene != null && String.fromCharCode(event.keyCode) == "(")
            {
                wordOnScene.setSpeedY = currentSpeed;
            }
        }
    }
}