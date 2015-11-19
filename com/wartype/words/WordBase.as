package com.wartype.words
{
	import com.wartype.MainConstants;
	import com.wartype.Universe;
	import com.wartype.guns.GunBase;
	import com.wartype.interfaces.IObject;
	import com.wartype.levels.LevelManager;

	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class WordBase extends Sprite implements IObject
	{
		public var isAttacked:Boolean;
		public var isSelected:Boolean;
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

		private var speedY:int;
		
		public function WordBase()
		{}
		
		public function init():void
		{
			this.x = ((MainConstants.SCR_WIDTH - 50) - 50) * Math.random() + 50;
			if (sprite != null && textClip != null)
			{
				addChild(sprite);
				addChild(textClip);
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
				textLabel.text = wordIntoTextField.toString();
				if(isSelected) {
					setTextFormat();
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
			wordsArrayLength--;
			if (wordsArrayLength <= 0 && wordSplitChars.length <= 0)
			{
				free();
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
		
		public function stop():void
		{
			setSpeedY = 0;
			sprite.stop();
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
	}
}