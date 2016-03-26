package com.wartype.menu {

import com.wartype.App;

import flash.display.MovieClip;

public class BaseMenu extends MovieClip {

    public var appRef:App;

    public function BaseMenu(appRef:App = null) {
        this.appRef = appRef;
        alpha = 0;
        y = 400;
    }

}
}