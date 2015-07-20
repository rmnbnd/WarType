package com.wartype.bullets
{
	import com.wartype.App;
	import com.wartype.words.WordBase;

	import flash.events.KeyboardEvent;

	public class GunSimple extends GunBase
	{
		private var _word:WordBase; //Ссылка на слово
		
		internal var _key:String; //Нажатая кнопка
		
		public static var isAttackedFlag:Boolean; //Флаг, указывающий, 
		                                          //было ли атаковано слово (для захвата ссылки на объект)
		private static var _instance: GunSimple;
		
		
		public function GunSimple()
		{
			_bulletSpeed = 800;
			_health = 100;
			_body = new gun_body_mc();
			_head = new gun_head_mc();
			_textSprite = new textlabel_mc();
			_head.rotation = 270; //Разворачиваем пушку, т.к изначально она стоит дулом вправо (0 deg)
			
			init(); //Инициализируем пушку
		}
		
		public static function getInstance():GunSimple
		{
			return _instance;
		}
		
		override public function init():void
		{
			_instance = this;
			super.init();
		}
		
		public function set setHealth(value:Number):void
		{
			_health -= value;
		}
		
		public function get getHealth():int
		{
			return _health;
		}
		
		//Функция-обработчик события нажатия на кнопку
		public function keyDownHandler(event:KeyboardEvent):void
		{
			_key = String.fromCharCode(event.keyCode);
			//trace(key);
			var words_enemies:Array = _universe.words.objects;
			
			if (isAttackedFlag == false)
			{
				for (var i:int = words_enemies.length - 1; i >= 0; --i)
				{
					_word = words_enemies[i];
						
					if (_key == _word.wordsArray[0])
					{
						_wordTarget = _word;
					} 			
				}
			}
			
			if (_wordTarget != null)
			{
				if (_wordTarget.y >= App.SCR_HEIGHT)
				{
					isAttackedFlag = false;
					_wordTarget = null;
					
				}
				else if (_wordTarget.isDead == true)
				{
					isAttackedFlag = false;
					_wordTarget = null;
				}
				else
				{
					if (_key == _wordTarget.wordsArray[0])
					{
						_wordTarget.isAttacked = true;
						if (_wordTarget.isAttacked == true)
						{
							isAttackedFlag = true;
						}
						
						//update our player location parameters
						var playerX = this.x;
						var playerY = this.y;
	
						//calculate player_mc rotation, based on player position & mouse position 
						var rotationDirection = Math.round(180 - ((Math.atan2(_wordTarget.x - playerX, _wordTarget.y - playerY)) * 180/Math.PI));
	
						//set rotation
						this.rotation = rotationDirection;	
						
						//_head.rotation = Amath.getAngleDeg(_head.x, _head.y, _wordTarget.x, _wordTarget.y);
						_wordTarget.damage();
						shoot();
					}
				}
			}
		}
		
		override public function free():void
		{
			if (!_isFree)
			{
				super.free();
				_isFree = true;
			}
		}
		
		override public function update(delta:Number):void
		{
			super.update(delta);
		}
		
		//Функция выстрела
		private function shoot():void
		{
			var bullet:BulletSimple = new BulletSimple();
			bullet.init(this.x, this.y, _bulletSpeed, this.rotation);
		}

	}
}