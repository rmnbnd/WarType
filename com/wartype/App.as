package com.wartype {

import com.wartype.menu.MainMenu;
import com.wartype.menu.CreditsMenu;
import com.wartype.menu.BaseMenu;

import caurina.transitions.Tweener;

import flash.display.Sprite;
import flash.display.StageScaleMode;

public class App extends Sprite {

    public function App() {
        trace("App class is created!");
        stage.scaleMode = StageScaleMode.NO_SCALE;
        createMainMenu();
    }

    public function createMainMenuFromExistView(currentMenu:BaseMenu = null):void {
        stage.removeChild(currentMenu);
        createMainMenu();
    }

    public function createCreditsMenu(currentMenu:BaseMenu = null):void {
        stage.removeChild(currentMenu);
        var creditsMenu:BaseMenu = new CreditsMenu(this);
        loadMenu(creditsMenu);
    }

    public function createGame(currentMenu:BaseMenu = null):void {
        stage.removeChild(currentMenu);
        var game:Game = new Game(stage, this);
        stage.addChild(game);
    }

    public function loadMenu(menu:BaseMenu = null):void {
        stage.addChild(menu);
        Tweener.addTween(menu, {
            alpha: 1, y: 0, time: 0.7
        });
    }

    private function createMainMenu():void {
        var menu:BaseMenu = new MainMenu(this);
        loadMenu(menu);
    }
}
}