package com.wartype.menu.gameover {

import com.wartype.Game;
import com.wartype.MainConstants;
import com.wartype.menu.BaseMenu;
import com.wartype.menu.MenuConstants;
import com.wartype.words.WordConstants;

import flash.display.Sprite;
import flash.text.TextField;
import flash.events.MouseEvent;

public class GameOverMenu extends BaseMenu {

    private var game:Game;

    public function GameOverMenu(game:Game, score:Number) {
        this.game = game;
        alpha = 0;

        this.x = MainConstants.SCRN_WIDTH_HALF;
        this.y = MainConstants.SCRN_HEIGHT_HALF / 2;

        var scoreSprite:Sprite = new scoreSprite_mc();
        scoreSprite.x = MenuConstants.GAME_OVER_HSCORE_X;
        scoreSprite.y = MenuConstants.GAME_OVER_HSCORE_Y;
        var textFieldScore:TextField = scoreSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
        textFieldScore.text = String(score);
        addChild(scoreSprite);

        menuButton.addEventListener(MouseEvent.MOUSE_DOWN, openMainMenu, false, 0, true);
        playAgainButton.addEventListener(MouseEvent.MOUSE_DOWN, playAgain, false, 0, true);
    }

    private function openMainMenu(e:MouseEvent):void {
        game.openMainMenuScreen(this);
    }

    private function playAgain(e:MouseEvent):void {
        game.removeMenuAndCreateGame(this);
    }

}
}