package com.wartype.menu {

import com.wartype.App;

import flash.events.MouseEvent;

public class MainMenu extends BaseMenu {

    public function MainMenu(appRef:App = null) {
        super(appRef);

        btnPlay.addEventListener(MouseEvent.MOUSE_DOWN, playGame, false, 0, true);
        btnCredits.addEventListener(MouseEvent.MOUSE_DOWN, credits, false, 0, true);
    }

    private function playGame(e:MouseEvent):void {
        this.appRef.createGame(this);
    }

    private function credits(e:MouseEvent):void {
        this.appRef.createCreditsMenu(this);
    }

}
}