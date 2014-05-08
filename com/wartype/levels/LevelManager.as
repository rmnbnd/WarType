package com.wartype.levels
{
	
	public class LevelManager
	{
		public static const TOTAL_LEVELS:int = 8; //Общее количество уровней
		
		private var _completedLvl:int = 1; //Пройденных уровней
		
		public function LevelManager()
		{
		
		}
		
		public function getLevel(lvlId:int):LevelBase
		{
			if (lvlId > TOTAL_LEVELS || lvlId < 0)
			{
				trace("Level" + lvlId + " does not exist!");
			}
			
			switch (lvlId)
			{
				case 1: 
					return new Level1();
					break;
				case 2: 
					return new Level2();
					break;
				case 3: 
					return new Level3();
					break;
				case 4: 
					return new Level4();
					break;
				case 5: 
					return new Level5();
					break;	
				case 6: 
					return new Level6();
					break;	
				case 7: 
					return new Level7();
					break;
				case 8: 
					return new Level8();
					break;
				default: 
					return null;
					break;
			}
		}
	}
}