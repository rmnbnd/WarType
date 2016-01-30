package com.wartype.menu
{
import com.wartype.Game;

	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	public class MainMenu extends BaseMenu
	{
		private var game:Game;

		public function MainMenu(stageRef:Stage = null, game:Game = null)
		{
			this.game = game;
			this.stageRef = stageRef;
			btnPlay.addEventListener(MouseEvent.MOUSE_DOWN, playGame, false, 0, true);
			btnCredits.addEventListener(MouseEvent.MOUSE_DOWN, credits,  false, 0, true);
		}
		
		private function playGame(e:MouseEvent) : void
		{
			addChild(game);
		}
		
		private function credits(e:MouseEvent) : void
		{
			unload(new CreditsMenu(stageRef, game));
		}
		
	}
	
}