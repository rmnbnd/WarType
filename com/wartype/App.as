package com.wartype
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    public class App extends Sprite
    {
        public static const SCR_WIDTH:int = 600;
        public static const SCR_HEIGHT:int = 800;
        public static const SCRN_WIDTH_HALF:int = SCR_WIDTH / 2;
        public static const SCRN_HEIGHT_HALF:int = SCR_HEIGHT / 2;

        public function App()
        {
            trace("App class is created!");

            stage.scaleMode = StageScaleMode.NO_SCALE;
            var _game:Game = new Game(stage);
            addChild(_game);
        }
    }
}