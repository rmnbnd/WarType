package com.wartype.bullets
{
	import com.wartype.Universe;
	import com.wartype.App;
	import com.wartype.levels.LevelManager;
	import com.wartype.words.WordBase;
	import com.wartype.interfaces.IObject;
	import com.framework.math.*;
	
	import flash.display.Sprite;
	
	public class BulletBase extends Sprite implements IObject
	{
		internal var bulletSpeed:Number = 20; //pixels
		
		internal var xSpeed:Number;
		internal var ySpeed:Number;
		
		protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		protected var _sprite:Sprite; //Спрайт пули
		protected var _isFree:Boolean = true;

		public function BulletBase()
		{
			//nothing
		}
		
		public function free():void
		{
			if (_sprite && contains(_sprite))
			{
				removeChild(_sprite);
			}
			
			_universe.removeChild(this);
			_universe.bullets.remove(this);
		}
		
		public function init(ax:int, ay:int, speed:Number, angle:Number):void
		{
			_sprite.rotation = angle;
			if (_sprite != null)
			{
				addChild(_sprite);
			}


			//position bullet on player
			this.x = ax;
			this.y = ay;

			var bulletLifeTimer = 0;

			//calculate random bullet offset.
			var randomNum = 1;
				
			//set bullet firing angle
			var bulletAngle = ((angle+randomNum-90)*Math.PI/180);
			xSpeed = Math.cos(bulletAngle)*bulletSpeed;
			ySpeed = Math.sin(bulletAngle)*bulletSpeed;
			
			_isFree = false;
			_universe.bullets.add(this);
			_universe.addChild(this);
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
				
				//distance = Amath.distance(this.x, this.y, enemyWord.x, enemyWord.y);
				//if (distance <= this.width / 2 + enemyWord.width / 4)
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