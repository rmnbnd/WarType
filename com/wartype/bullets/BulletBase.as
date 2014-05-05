package com.wartype.bullets
{
	import com.wartype.Universe;
	import com.wartype.App;
	import com.wartype.words.WordBase;
	import com.wartype.interfaces.IObject;
	import com.framework.math.*;
	
	import flash.display.Sprite;
	
	public class BulletBase extends Sprite implements IObject
	{
		protected var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		protected var _sprite:Sprite; //Спрайт пули
		protected var _speed:Avector = new Avector(); //Скорость пули
		protected var _isFree:Boolean = true;
	
		private var coef:Number = 0.8; //Коэффициент для плавности поворота в воздухе самонаводящейся пули
		
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
			if (_sprite != null)
			{
				addChild(_sprite);
			}
			
			this.x = ax;
			this.y = ay;
			this.rotation = -90; //Устанавливаем пулю в направлении вверх
			
			
			//////////////////////////////////////////////////САМОНАВОДКА
			
			var rotation:int = angle;
			
			if (Math.abs(rotation - this.rotation) > 180)
			{
				if (rotation > 0 && this.rotation < 0)
				{
					this.rotation -= (360 - rotation + this.rotation) / coef;
				}
				else if (this.rotation > 0 && rotation < 0)
				{
					this.rotation += (360 - rotation + this.rotation) / coef;
				}
			}
			else if (rotation < this.rotation)
			{
				this.rotation -= Math.abs(this.rotation - rotation) / coef;
			}
			else
			{
				this.rotation += Math.abs(rotation - this.rotation) / coef;
			}
			
			_speed.x = speed * (90 - Math.abs(this.rotation)) / 90;
			
			if (this.rotation < 0)
			{
				_speed.y = -speed + Math.abs(_speed.x);//идем вверх.
			}
			else
			{
				_speed.y = speed - Math.abs(_speed.x);//идем вниз.
			}
			
			//////////////////////////////////////////////////САМОНАВОДКА
			
			
			_isFree = false;
			_universe.bullets.add(this);
			_universe.addChild(this);
		}
		
		public function update(delta:Number):void
		{
			var enemyWord:WordBase; //Ссылка на атакуемое слово
			var words:Array = _universe.words.objects; //Массив появившихся на экране слов
			var distance:Number; //Дистанция от пули до слова
			
			this.x += _speed.x * delta;
			this.y += _speed.y * delta;
			
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
				
				distance = Amath.distance(this.x, this.y, enemyWord.x, enemyWord.y);
				if (distance <= this.width / 2 + enemyWord.width / 4)
				{
					if (enemyWord.isAttacked == true)
					{
						enemyWord.destruction(); //Урон пулей
						free(); //Уничтожаем пулю
						break;
					}
				}
			}
		}
	}
}