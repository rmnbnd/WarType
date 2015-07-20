package com.wartype.words
{
	import com.wartype.interfaces.IObject;
	import com.wartype.App;
	import com.wartype.bullets.GunSimple;
	
	public class WordSimple extends WordBase implements IObject
	{
		
		public function WordSimple(wordObject:String, speed:int)
		{
			_sprite = new word_mc(); //Спрайт для слова
			textClip = new textlabel_mc(); //Клип для TextLabel
			
			_wordObjText = wordObject; //Записываем слово, передаваемое в конструктор, в переменную
			wordsArray = wordObject.split(''); //Разделяем слово по буквам
			_wordsArrayLenght = wordsArray.length; //Записываем размерность массива в переменную
			trace(wordsArray);
			
			speedY = speed; //Устанавливаем скорость
			_go = true; //Флаг движения (потом понадобится)
			isDead = false; //Флаг "смерти" слова
		    isAttacked = false; //Флаг атакуемости слова
			
			init();
		}
		
		override public function init():void
		{
			super.init();
		}
		
		override public function update(delta:Number):void
		{
			if (_go)
			{
				this.y += speedY * delta;
				_textLabel.text = _wordObjText.toString();
			}
			
			if (this.y >= App.SCR_HEIGHT - 20)
			{
				_gun.setHealth = 10;
				free();
			}
		}
		
		override public function damage():void
		{
			//Выводим слово после нанесения урона
			_wordObjText = '';
			wordsArray.shift();
			for (var i:int = 0; i < wordsArray.length; i++)
			{
				_wordObjText += wordsArray[i].toString();
			}
			
			if (wordsArray.length <= 0 || this.y >= App.SCR_HEIGHT)
			{
				_textLabel.visible = false;
				isDead = true;
				GunSimple.isAttackedFlag = false;
			}
		}
		
		override public function destruction():void
		{
			_wordsArrayLenght--;
			
			if (_wordsArrayLenght <= 0 && wordsArray.length <=0)
			{
				free();
			}
		}
		
		override public function free():void
		{
			super.free();
		}
		
		override public function stop():void
		{
			super.stop();
		}
	
	}
}