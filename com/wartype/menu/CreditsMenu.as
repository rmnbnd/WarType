package com.wartype.menu
{
	import com.wartype.Game;

	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class CreditsMenu extends BaseMenu
		{
			private var game:Game;

			public function CreditsMenu(stageRef:Stage = null, game:Game = null):void
			{
				this.game = game;
				this.stageRef = stageRef;
				btnReturn.addEventListener(MouseEvent.MOUSE_DOWN, returnMainMenu,  false, 0, true);
			}

			private function returnMainMenu(e:MouseEvent) : void
			{
				unload(new MainMenu(stageRef, game));
			}

		}
	
}