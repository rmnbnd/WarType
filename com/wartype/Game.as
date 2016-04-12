package com.wartype {

import com.wartype.menu.BaseMenu;
import com.wartype.words.WordBase;
import com.wartype.menu.gameover.GameOverMenu;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.KeyboardEvent;

public class Game extends Sprite {

    private var app:App;
    private var universe:Universe;
    private var currentSpeed:int;

    public function Game(stage:Stage, app:App) {
        trace("Game class is created!");
        this.app = app;
        universe = new Universe(this);
        addChild(universe);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownAction); //Dev only, get more speed for words
        stage.addEventListener(KeyboardEvent.KEY_UP, getBackToNormSpeed); //Dev only, get more speed for words//use Arrow-down key
    }

    public function openGameOverScreen(score:Number):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownAction);
        MainConstants.LEVEL_NUMBER = 1;
        app.loadMenu(new GameOverMenu(this, score));
    }

    public function openMainMenuScreen(menuView:BaseMenu):void {
        removeChild(universe);
        app.createMainMenuFromExistView(menuView);
    }

    public function removeMenuAndCreateGame(menuView:BaseMenu):void {
        removeChild(universe);
        app.createGame(menuView);
    }

    private function keyDownAction(event:KeyboardEvent):void {
        var wordOnScene:WordBase = Universe.getInstance().getWordOnScene;
        if (wordOnScene != null && String.fromCharCode(event.keyCode) == "(") {
            currentSpeed = wordOnScene.getSpeedY;
            wordOnScene.setSpeedY = 500;
        }
        if (event.ctrlKey) {
            if (!universe.getIsStopGame) {
                universe.stopGame();
            }
            else {
                universe.resetGame();
            }
        }
    }

    private function getBackToNormSpeed(event:KeyboardEvent):void {
        var wordOnScene:WordBase = Universe.getInstance().getWordOnScene;
        if (wordOnScene != null && String.fromCharCode(event.keyCode) == "(") {
            wordOnScene.setSpeedY = currentSpeed;
        }
    }
}
}