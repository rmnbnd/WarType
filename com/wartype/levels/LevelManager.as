package com.wartype.levels
{
	import com.wartype.Universe;
	import com.wartype.controllers.ObjectController;
	import com.wartype.words.WordBase;
	import com.wartype.words.WordL1;
	import com.wartype.words.WordL2;

	public class LevelManager
	{
		private var universe:Universe = Universe.getInstance();
		private var wordsArray:Array = ['AIR', 'ADD', 'AGE', 'CITY', 'HELP', 'LIFE', 'ASK', 'AWAY', 'BABY',
			'PEN', 'BED', 'BEAR', 'KIND', 'AS', 'HOW', 'ZERO', 'ICE', 'BITE', 'SKY', 'BOX', 'NOW', 'GIRL',
			'LOW', 'BY', 'BUY', 'CAN', 'CAR', 'CAT', 'CALL', 'HEAD', 'GAME', 'CUT', 'DAY', 'DO', 'OLD',
			'DRY', 'JUST', 'ROCK', 'EGG', 'EYE', 'FAR', 'RED', 'FILL', 'FEW', 'FIT', 'MAP', 'FIVE', 'MILK'];
		private var speedY:int = 50;
		private var timerWord:uint = 5000;
		private var randomWordsArrayToOneLevel:Array;
		private var numberOfWordsToCreate:uint;
		private var wordObject:String; //Слово в стринг для передачи в конструктор WordBase
		private var wordToAddToStage:WordBase;

		private static var words:ObjectController;


		public function LevelManager()
		{
			words = new ObjectController();
			randomWordsArrayToOneLevel = [];
		}
		
		public function createLevel(numberOfWords:int)
		{
			universe.timer = timerWord;
			numberOfWordsToCreate = numberOfWords;
			while(numberOfWordsToCreate > 0)
			{
				createWord();
				getRandomWordsArrayToOneLevel.push(wordToAddToStage);
				numberOfWordsToCreate--;
			}
		}

		private function createWord():void
		{
			var random:int;
			if (wordsArray.length - 1 >= 0)
			{
				random = Math.random() * wordsArray.length;
				wordObject = wordsArray[random];
				wordsArray.splice(random, 1);  //удаляет элемент из массива
				randomBoolean() == 1
						? wordToAddToStage = new WordL1(wordObject, speedY)
						: wordToAddToStage = new WordL2(wordObject, speedY);
			}
		}

		internal static function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
		}

		public static function get getWords():ObjectController
		{
			return words;
		}

		public function get getRandomWordsArrayToOneLevel():Array
		{
			return randomWordsArrayToOneLevel;
		}

		public function get getWordToAddToStage():WordBase
		{
			return wordToAddToStage;
		}
	}
}