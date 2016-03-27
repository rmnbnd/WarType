package com.wartype.menu.gameover {

import com.wartype.Game;
import com.wartype.MainConstants;
import com.wartype.menu.BaseMenu;

import flash.events.MouseEvent;

public class GameOverMenu extends BaseMenu {

    private var game:Game;

    public function GameOverMenu(game:Game) {
        this.game = game;
        alpha = 0;

        this.x = MainConstants.SCRN_WIDTH_HALF;
        this.y = MainConstants.SCRN_HEIGHT_HALF / 2;

        menuButton.addEventListener(MouseEvent.MOUSE_DOWN, openMainMenu, false, 0, true);
    }

    private function openMainMenu(e:MouseEvent):void {
        game.openMainMenuScreen(this);
    }

}
}