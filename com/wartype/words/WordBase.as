package com.wartype.words
{
	import com.framework.math.Anumber;
	import com.wartype.MainConstants;
	import com.wartype.Universe;
	import com.wartype.guns.GunBase;
	import com.wartype.interfaces.IObject;
	import com.wartype.levels.LevelManager;
	import com.wartype.scores.ScoreWord;

	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class WordBase extends Sprite implements IObject
	{
		public var isAttacked:Boolean;
		private var _isSelected:Boolean;
		public var wordSplitChars:Array = []; //Массив букв слова
		public var isDead:Boolean;

		protected var wordsArrayLength:int; //Размерность массива
		protected var textLabel:TextField; //Текстовое поле для вывода текста слова на экран
		protected var textClip:Sprite; //Спрайт для вывода текста слова на экран
		protected var wordIntoTextField:String; //Собственно, само слово
		protected var sprite:MovieClip; //Спрайт слова
		protected var go:Boolean; //Движется ли слово
		protected var universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		protected var throwTimeWord:uint;
		protected var highFlameFirstFrame:MovieClip;
		protected var highlight:MovieClip;
		private var currentSpeed:Number;
		private var speedY:int;
		private var blurFilter:BlurFilter;
		private var highlightVisible:Boolean = true;
		private var scoreWord:ScoreWord;
		private var scoreWordArray:Array = [];

		private var count:int = 0;
		
		public function WordBase()
		{}
		
		public function init():void
		{
			highlight.alpha = 0;
			blurFilter = new BlurFilter();
			blurFilter.blurX = 1.15;
			blurFilter.blurY = 1.15;
			blurFilter.quality = BitmapFilterQuality.HIGH;

			currentSpeed = getSpeedY;
			this.x = ((MainConstants.SCR_WIDTH - 50) - 50) * Math.random() + 50;
			sprite.filters = [blurFilter];
			if (sprite != null && textClip != null)
			{
				addChild(sprite);
				addChildAt(textClip, 0);
			}
			
			if (textClip[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
			{
				textLabel = textClip[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
			}
			LevelManager.getWords.add(this);
		}

		public function update(delta:Number):void
		{
			if (go && this.stage)
			{
				this.y += getSpeedY * delta;
				textLabel.text = wordIntoTextField.toString().toLowerCase();
				if(_isSelected) {
					setTextFormat();
				}
			}
			if(highlightVisible && highlight.alpha <= 1 && this._isSelected)
			{
				highlight.alpha += 0.1;
			}
			if(!highlightVisible && highlight.alpha > 0)
			{
				highlight.alpha -= 0.1;
			}
			if(scoreWordArray.length != 0)
			{
				for (var i:int = scoreWordArray.length - 1; i >= 0; i--)
				{
					scoreWordArray[i].update(this);
				}
			}
		}
		
		//Фукнция нанесения урона слову по нажатию на клавишу
		public function damage():void
		{
			//Выводим слово после нанесения урона
			wordIntoTextField = '';
			wordSplitChars.shift();
			for (var i:int = 0; i < wordSplitChars.length; i++)
			{
				wordIntoTextField += wordSplitChars[i].toString();
			}

			if (wordSplitChars.length <= 0 || this.y >= MainConstants.SCR_HEIGHT)
			{
				textLabel.visible = false;
				isDead = true;
				GunBase.isAttackedWord = false;
			}
		}
		
		//Нанесение урона пулей
		public function destruction():void
		{
			universe.getMediumExplosion.create(Anumber.randRange(this.x - 10, this.x + 10),
											Anumber.randRange(this.y - 10, this.y + 10));
			wordsArrayLength--;
			createScoreForWord();
		}

		private function createScoreForWord():void
		{
			var nameWord:String = "word #" + ++count;
			scoreWordArray.push(new ScoreWord(this, nameWord));
		}

		public function removeScoreWord(obj:ScoreWord):void
		{
			for (var i:int = 0; i < scoreWordArray.length; i++)
			{
				if (scoreWordArray[i] == obj)
				{
					scoreWordArray[i] = null;
					scoreWordArray.splice(i, 1);
					break;
				}
			}
			if (wordsArrayLength <= 0 && wordSplitChars.length <= 0 && scoreWordArray.length <= 0)
			{
				free();
				universe.getScore.incDamagedEnemies();
			}
		}
		
		public function free():void
		{
			go = false;
			isDead = true;

			if (sprite && contains(sprite))
			{
				removeChild(sprite);
			}

		    universe.removeChild(this);
			LevelManager.getWords.remove(this);
		}

		public function boost():void
		{

		}
		
		public function stop():void
		{
			setSpeedY = 0;
			sprite.stop();
		}

		public function start():void
		{
			setSpeedY = currentSpeed;
			sprite.play();
		}

		public function set setSpeedY(value:int):void
		{
			speedY = value;
		}

		public function get getSpeedY():int
		{
			return speedY;
		}

		private function setTextFormat():void
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = WordConstants.RED_COLOR_16BIT;
			textFormat.size = WordConstants.TEXT_SIZE;
			if(wordSplitChars.length != 0)
			{
				textLabel.setTextFormat(textFormat, 0, 1);
			}
		}

		public function get getThrowTimeWord():uint
		{
			return throwTimeWord;
		}

		public function unselectWord():void
		{
			isSelected = false;
		}

        public function unatackedWord():void
        {
            isAttacked = false;
        }

		public function get getCurrentSpeed():Number
		{
			return currentSpeed;
		}

		public function set setCurrentSpeed(speed:Number):void
		{
			currentSpeed = speed;
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			if(highlight != null)
			{
				if(value)
				{
					addChildAt(highlight, 0);
					highlightVisible = true;
				}
				else
				{
					highlightVisible = false;
				}
			}
			_isSelected = value;
		}

	}
}