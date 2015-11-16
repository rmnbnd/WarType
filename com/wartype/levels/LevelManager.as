package com.wartype.levels
{
	import com.wartype.controllers.ObjectController;
	import com.wartype.levels.LevelsConstants;
	import com.wartype.words.WordBase;
	import com.wartype.words.WordL1;
	import com.wartype.words.WordL2;
	import com.wartype.words.WordL3;
	import com.wartype.words.WordL4;

	public class LevelManager
	{
		private var wordsArray:Array;
		private var speedY:int = LevelsConstants.WORD_SPEED;
		private var randomWordsArrayToOneLevel:Array;
		private var wordObject:String; //Слово в стринг для передачи в конструктор WordBase
		private var wordToAddToStage:WordBase;
		private var allWords:Array;
		private var timeToThrowWordFirstLevel:int;
		private var timeToThrowWordSecondLevel:int;
		private var timeToThrowWordThirdLevel:int;
		private var timeToThrowWordFourthLevel:int;

		private static var words:ObjectController = new ObjectController();

		public function LevelManager(wordsFromFile:Array)
		{
			allWords = wordsFromFile;
			randomWordsArrayToOneLevel = [];
		}
		
		public function createLevel(typingSpeed:int, firstLevelBorder:Number, secondLevelBorder:Number,
									 thirdLevelBorder:Number, fourthLevelBorder:Number):void
		{
			var charsPerFirstLevelWords:int = typingSpeed * firstLevelBorder;
			trace("Chars 1 lvl: " + charsPerFirstLevelWords);
			var charsPerSecondLevelWords:int = typingSpeed * secondLevelBorder;
			trace("Chars 2 lvl: " + charsPerSecondLevelWords);
			var charsPerThirdLevelWords:int = typingSpeed * thirdLevelBorder;
			trace("Chars 3 lvl: " + charsPerThirdLevelWords);
			var charsPerFourthLevelWords:int = typingSpeed * fourthLevelBorder;
			trace("Chars 4 lvl: " + charsPerFourthLevelWords);
			var numberOfWordsFirstLvl:int = charsPerFirstLevelWords / LevelsConstants.FIRST_DIFFICULTY_LETTERS;
			trace("Number of words 1 lvl: " + numberOfWordsFirstLvl);
			var numberOfWordsSecondLvl:int = charsPerSecondLevelWords / LevelsConstants.SECOND_DIFFICULTY_LETTERS;
			trace("Number of words 2 lvl: " + numberOfWordsSecondLvl);
			var numberOfWordsThirdLvl:int = charsPerThirdLevelWords / LevelsConstants.THIRD_DIFFICULTY_LETTERS;
			trace("Number of words 3 lvl: " + numberOfWordsThirdLvl);
			var numberOfWordsFourthLvl:int = charsPerFourthLevelWords / LevelsConstants.FOURTH_DIFFICULTY_LETTERS;
			trace("Number of words 4 lvl: " + numberOfWordsFourthLvl);

			timeToThrowWordFirstLevel = ((LevelsConstants.ONE_MINUTE_IN_MILLISECONDS * firstLevelBorder)
					* LevelsConstants.FIRST_DIFFICULTY_LETTERS) / charsPerFirstLevelWords;
			timeToThrowWordSecondLevel = ((LevelsConstants.ONE_MINUTE_IN_MILLISECONDS * secondLevelBorder)
					* LevelsConstants.SECOND_DIFFICULTY_LETTERS) / charsPerSecondLevelWords;
			timeToThrowWordThirdLevel = ((LevelsConstants.ONE_MINUTE_IN_MILLISECONDS * thirdLevelBorder)
					* LevelsConstants.THIRD_DIFFICULTY_LETTERS) / charsPerThirdLevelWords;
			timeToThrowWordFourthLevel = ((LevelsConstants.ONE_MINUTE_IN_MILLISECONDS * fourthLevelBorder)
					* LevelsConstants.FOURTH_DIFFICULTY_LETTERS) / charsPerFourthLevelWords;

			wordsArray = getCurrentWords(LevelsConstants.FIRST_DIFFICULTY_LETTERS);
			createWordsByDifficulty(LevelsConstants.FIRST_DIFFICULTY_LETTERS, numberOfWordsFirstLvl);

			wordsArray = getCurrentWords(LevelsConstants.SECOND_DIFFICULTY_LETTERS);
			createWordsByDifficulty(LevelsConstants.SECOND_DIFFICULTY_LETTERS, numberOfWordsSecondLvl);

			wordsArray = getCurrentWords(LevelsConstants.THIRD_DIFFICULTY_LETTERS);
			createWordsByDifficulty(LevelsConstants.THIRD_DIFFICULTY_LETTERS, numberOfWordsThirdLvl);

			wordsArray = getCurrentWords(LevelsConstants.FOURTH_DIFFICULTY_LETTERS);
			createWordsByDifficulty(LevelsConstants.FOURTH_DIFFICULTY_LETTERS, numberOfWordsFourthLvl);
			randomWordsArrayToOneLevel.sort(randomSort);
		}

		private static function randomSort(firstElement:*, secondElement:*):Number
		{
			if (Math.random() < 0.5) return -1;
			else return 1;
		}

		private function createWordsByDifficulty(difficulty_letters:uint, numberOfWordsByDifficulty:int):void
		{
			while(numberOfWordsByDifficulty > 0)
			{
				createWord(difficulty_letters);
				randomWordsArrayToOneLevel.push(wordToAddToStage);
				numberOfWordsByDifficulty--;
			}
		}
		
		private function getCurrentWords(difficulty:int):Array
		{
			for(var element:Object in allWords) {
				if (allWords[element].difficulty == difficulty) {
					return allWords[element].words as Array;
				}
			}
			return allWords[0].words as Array;
		}

		private function createWord(difficulty:int):void
		{
			var random:int;
			if (wordsArray.length - 1 >= 0)
			{
				random = Math.random() * wordsArray.length;
				wordObject = wordsArray[random];
				wordsArray.splice(random, 1);
				switch(difficulty)
				{
					case LevelsConstants.FIRST_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL1(wordObject, speedY, timeToThrowWordFirstLevel);
						break;
					case LevelsConstants.SECOND_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL2(wordObject, speedY, timeToThrowWordSecondLevel);
						break;
					case LevelsConstants.THIRD_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL3(wordObject, speedY, timeToThrowWordThirdLevel);
						break;
					case LevelsConstants.FOURTH_DIFFICULTY_LETTERS:
						wordToAddToStage = new WordL4(wordObject, speedY, timeToThrowWordFourthLevel);
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