package com.wartype.bullets
{
	import com.wartype.MainConstants;
	import com.wartype.Universe;
	import com.wartype.interfaces.IObject;
	import com.wartype.words.WordBase;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class BulletBase extends Sprite implements IObject
	{
		private var bulletSpeed:Number = BulletConstants.BULLET_SPEED;
		private var xSpeed:Number;
		private var ySpeed:Number;
		private var currentXSpeed:Number;
		private var currentYSpeed:Number;

		protected var universe:Universe = Universe.getInstance();
		protected var sprite:MovieClip;
		protected var isFree:Boolean = true;
        protected var target:WordBase;
        
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
		
		public function init(ax:int, ay:int, speed:Number, angle:Number, wordTarget:WordBase):void
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
            target = wordTarget;
			universe.bullets.add(this);
			universe.addChild(this);
		}
		
		public function update(delta:Number):void
		{
			this.x += xSpeed;
			this.y += ySpeed;
			
			//Проверка на выход за пределы сцены
			if (this.x < 0 || this.x > MainConstants.SCR_WIDTH || this.y < 0 || this.y > MainConstants.SCR_HEIGHT)
			{
				free();
				return;
			}
            
            if(this.hitTestObject(target))
            {
                if (target.isAttacked == true)
                {
                    target.destruction(); //Урон пулей
                    free(); //Уничтожаем пулю
                    if (!target.isSelected && !getIsFree())
                    {
                        target.isAttacked = false;
                    }
                }
            }
		}

		public function start():void
		{
			ySpeed = currentYSpeed;
			xSpeed = currentXSpeed;
			sprite.play();
		}

		public function stop():void
		{
			currentXSpeed = xSpeed;
			currentYSpeed = ySpeed;
			ySpeed = 0;
			xSpeed = 0;
			sprite.stop();
		}
        
        public function getIsFree():Boolean
        {
            return this.isFree;
        }
	}
}