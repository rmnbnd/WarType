package com.wartype.levels
{
	import com.wartype.Universe;
	import com.wartype.controllers.ObjectController;
	import com.wartype.words.WordBase;
	import com.wartype.words.WordL1;
	import com.wartype.words.WordL2;
	import com.wartype.words.WordL3;
	import com.wartype.words.WordL4;

	public class LevelManager
	{
		private var universe:Universe = Universe.getInstance();
		private var wordsArray:Array;
		private var speedY:int = 50;
		private var timerWord:uint = 5000;
		private var randomWordsArrayToOneLevel:Array;
		private var wordObject:String; //Слово в стринг для передачи в конструктор WordBase
		private var wordToAddToStage:WordBase;
		private var allWords:Array;

		private static var words:ObjectController = new ObjectController();

		private static const FIRST_DIFFICULTY_LETTERS:uint = 4;
		private static const SECOND_DIFFICULTY_LETTERS:uint = 6;
		private static const THIRD_DIFFICULTY_LETTERS:uint = 8;
		private static const FOURTH_DIFFICULTY_LETTERS:uint = 11;


		public function LevelManager(wordsFromFile:Array)
		{
			allWords = wordsFromFile;
			randomWordsArrayToOneLevel = [];
		}
		
		public function createLevel(typingSpeed:int, firstLevelBorder:Number, secondLevelBorder:Number,
									 thirdLevelBorder:Number, fourthLevelBorder:Number):void
		{
			var charsPerFirstLevelWords:int = typingSpeed * firstLevelBorder;
			var charsPerSecondLevelWords:int = typingSpeed * secondLevelBorder;
			var charsPerThirdLevelWords:int = typingSpeed * thirdLevelBorder;
			var charsPerFourthLevelWords:int = typingSpeed * fourthLevelBorder;
			var numberOfWordsFirstLvl:int = charsPerFirstLevelWords / FIRST_DIFFICULTY_LETTERS;
			var numberOfWordsSecondLvl:int = charsPerSecondLevelWords / SECOND_DIFFICULTY_LETTERS;
			var numberOfWordsThirdLvl:int = charsPerThirdLevelWords / THIRD_DIFFICULTY_LETTERS;
			var numberOfWordsFourthLvl:int = charsPerFourthLevelWords / FOURTH_DIFFICULTY_LETTERS;

			universe.timer = timerWord;

			wordsArray = getCurrentWords(FIRST_DIFFICULTY_LETTERS);
			while(numberOfWordsFirstLvl > 0)
			{
				createWord(FIRST_DIFFICULTY_LETTERS);
				randomWordsArrayToOneLevel.push(wordToAddToStage);
				numberOfWordsFirstLvl--;
			}

			wordsArray = getCurrentWords(SECOND_DIFFICULTY_LETTERS);
			while(numberOfWordsSecondLvl > 0)
			{
				createWord(SECOND_DIFFICULTY_LETTERS);
				randomWordsArrayToOneLevel.push(wordToAddToStage);
				numberOfWordsSecondLvl--;
			}

			wordsArray = getCurrentWords(THIRD_DIFFICULTY_LETTERS);
			while(numberOfWordsThirdLvl > 0)
			{
				createWord(THIRD_DIFFICULTY_LETTERS);
				randomWordsArrayToOneLevel.push(wordToAddToStage);
				numberOfWordsThirdLvl--;
			}

			wordsArray = getCurrentWords(FOURTH_DIFFICULTY_LETTERS);
			while(numberOfWordsFourthLvl > 0)
			{
				createWord(FOURTH_DIFFICULTY_LETTERS);
				randomWordsArrayToOneLevel.push(wordToAddToStage);
				numberOfWordsFourthLvl--;
			}
		}
		
		private function getCurrentWords(difficulty:int):Array
		{
			for(var element:Object in allWords) {
				if (allWords[element].difficulty == difficulty) {
					return allWords[element].words;
				}
			}
			return allWords[0].words;
		}

		private function createWord(difficulty:int):void
		{
			var random:int;
			if (wordsArray.length - 1 >= 0)
			{
				random = Math.random() * wordsArray.length;
				wordObject = wordsArray[random];
				wordsArray.splice(random, 1);  //удаляет элемент из массива
				switch(difficulty)
				{
					case FIRST_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL1(wordObject, speedY);
						break;
					case SECOND_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL2(wordObject, speedY);
						break;
					case THIRD_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL3(wordObject, speedY);
						break;
					case FOURTH_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL4(wordObject, speedY);
						break;
				}
			}
		}

		public static function get getWords():ObjectController
		{
			return words;
		}

		public function get getRandomWordsArrayToOneLevel():Array
		{
			return randomWordsArrayToOneLevel;
		}
	}
}