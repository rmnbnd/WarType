package com.wartype.menu {

import com.wartype.App;

import flash.events.MouseEvent;

public class CreditsMenu extends BaseMenu {

    public function CreditsMenu(appRef:App = null):void {
        super(appRef);

        btnReturn.addEventListener(MouseEvent.MOUSE_DOWN, returnMainMenu, false, 0, true);
    }

    private function returnMainMenu(e:MouseEvent):void {
        this.appRef.createMainMenuFromExistView(this);
    }

}
}