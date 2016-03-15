package com.wartype.menu.bar {
    import com.wartype.Universe;
    import com.wartype.menu.MenuConstants;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class StatusBar {

        private var statusBarSprite:MovieClip;
        private var menuIcon:MovieClip;
        private var healthSprite:MovieClip;
        private var universe:Universe = Universe.getInstance();

        public function StatusBar() {
            statusBarSprite = new statusBar_mc();
            statusBarSprite.x = MenuConstants.STATUS_BAR_X;
            statusBarSprite.y = MenuConstants.STATUS_BAR_Y;
            if(statusBarSprite)
            {
                universe.addChild(statusBarSprite);
            }

            menuIcon = new barMenuIcon_mc();
            menuIcon.x = MenuConstants.MENU_ICON_X;
            menuIcon.y = MenuConstants.MENU_ICON_Y;
            menuIcon.addEventListener(MouseEvent.CLICK, openStatusBarMenu);
            if(menuIcon)
            {
                universe.addChild(menuIcon);
            }

            healthSprite = new healthSprite_mc();
            healthSprite.x = MenuConstants.HEALTH_ICON_X;
            healthSprite.y = MenuConstants.HEALTH_ICON_Y;
            healthSprite.addEventListener(MouseEvent.CLICK, openStatusBarMenu);
            if(healthSprite)
            {
                universe.addChild(healthSprite);
            }
        }

        private function openStatusBarMenu(event:MouseEvent):void
        {
            if(universe.getIsStopGame)
            {
                universe.resetGame();
            }
            else
            {
                universe.stopGame();
            }
        }


    }

}
