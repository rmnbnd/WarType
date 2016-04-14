package com.wartype.levels
{
	import com.framework.math.Anumber;
	import com.wartype.MainConstants;
	import com.wartype.controllers.ObjectController;
	import com.wartype.levels.LevelsConstants;
	import com.wartype.words.WordBase;
	import com.wartype.words.WordL1;
	import com.wartype.words.WordL2;
	import com.wartype.words.WordL3;
	import com.wartype.words.WordL4;

	public class LevelManager
	{
		private static const WORD_SPEED_ITERATION:Number = 10;

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

		private var typingSpeed:int = 70;
		private var levelNumber:uint = 0;

		public var firstLevelBorder:Number = 0.9;
		public var secondLevelBorder:Number = 0.1;
		public var thirdLevelBorder:Number = 0.0;
		public var fourthLevelBorder:Number = 0.0;

		private static var words:ObjectController = new ObjectController();

		public function LevelManager(wordsFromFile:Array)
		{
			allWords = wordsFromFile;
			randomWordsArrayToOneLevel = [];
		}
		
		public function createLevel():void {
			typingSpeed += WORD_SPEED_ITERATION;
			levelNumber++;
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

		public function prepareVariablesToNewLevel():void {
			if (firstLevelBorder < 1 && secondLevelBorder < 1 && thirdLevelBorder < 1 && fourthLevelBorder < 1) {
				if (firstLevelBorder > 0) {
					firstLevelBorder = Anumber.toFixedNumber(firstLevelBorder, 1, MainConstants.MINUS, 0.2);
					secondLevelBorder = Anumber.toFixedNumber(secondLevelBorder, 1, MainConstants.PLUS, 0.1);
					thirdLevelBorder = Anumber.toFixedNumber(thirdLevelBorder, 1, MainConstants.PLUS, 0.1);
				}
				else if (secondLevelBorder > 0) {
					secondLevelBorder = Anumber.toFixedNumber(secondLevelBorder, 1, MainConstants.MINUS, 0.1);
					thirdLevelBorder = 0.5;
					fourthLevelBorder = Anumber.toFixedNumber(fourthLevelBorder, 1, MainConstants.PLUS, 0.1);
				} else {
					thirdLevelBorder = Anumber.toFixedNumber(thirdLevelBorder, 1, MainConstants.MINUS, 0.1);
					fourthLevelBorder = Anumber.toFixedNumber(fourthLevelBorder, 1, MainConstants.PLUS, 0.1);
				}
			}
			traceLevelsBorder();
		}

		public function traceLevelsBorder():void {
			trace("=========");
			trace("FIRST " + firstLevelBorder);
			trace("SECOND " + secondLevelBorder);
			trace("THIRD " + thirdLevelBorder);
			trace("FOURTH " + fourthLevelBorder);
			trace("=========");
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

		public function get getTypingSpeed():int {
			return typingSpeed;
		}

		public function get getLevelNumber():uint {
			return levelNumber;
		}
	}
}