package com.wartype.bullets
{
	import com.wartype.Universe;
	import com.wartype.App;
	import com.wartype.levels.LevelManager;
	import com.wartype.words.WordBase;
	import com.wartype.interfaces.IObject;
	import flash.display.Sprite;
	
	public class BulletBase extends Sprite implements IObject
	{
		private var bulletSpeed:Number = BulletConstants.BULLET_SPEED;
		private var xSpeed:Number;
		private var ySpeed:Number;
		
		protected var universe:Universe = Universe.getInstance();
		protected var sprite:Sprite;
		protected var isFree:Boolean = true;

		public function BulletBase()
		{

		}
		
		public function free():void
		{
			if (sprite && contains(sprite))
			{
				removeChild(sprite);
			}
			
			universe.removeChild(this);
			universe.bullets.remove(this);
		}
		
		public function init(ax:int, ay:int, speed:Number, angle:Number):void
		{
			sprite.rotation = angle;
			if (sprite != null)
			{
				addChild(sprite);
			}

			this.x = ax;
			this.y = ay;

			//calculate random bullet offset.
			var randomNum:int = 1;

			//set bullet firing angle
			var bulletAngle:Number = ((angle+randomNum-90)*Math.PI/180);
			xSpeed = Math.cos(bulletAngle)*bulletSpeed;
			ySpeed = Math.sin(bulletAngle)*bulletSpeed;
			
			isFree = false;
			universe.bullets.add(this);
			universe.addChild(this);
		}
		
		public function update(delta:Number):void
		{
			this.x += xSpeed;
			this.y += ySpeed;

			var enemyWord:WordBase; //Ссылка на атакуемое слово
			var words:Array = LevelManager.getWords.objects; //Массив появившихся на экране слов
			
			//Проверка на выход за пределы сцены
			if (this.x < 0 || this.x > App.SCR_WIDTH || this.y < 0 || this.y > App.SCR_HEIGHT)
			{
				free();
				return;
			}
			
			//Проверка на попадание, нанесение урона
			for (var i:int = 0; i < words.length; i++)
			{
				enemyWord = words[i];
				if(this.hitTestObject(enemyWord))
				{
					if (enemyWord.isAttacked == true)
					{
						enemyWord.destruction(); //Урон пулей
						free(); //Уничтожаем пулю
                        if (!enemyWord.isSelected)
                        {
                            enemyWord.isAttacked = false;
                        }
						break;
					}
				}
			}
		}
	}
}