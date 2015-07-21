package com.wartype.guns
{
	public class GunSimple extends GunBase
	{
		private static var _instance: GunSimple;
		
		public function GunSimple()
		{
			_bulletSpeed = 800;
			_health = 100;
			_body = new gun_body_mc();
			_head = new gun_head_mc();
			_textSprite = new textlabel_mc();
			_instance = this;
			
			init(); //Инициализируем пушку
		}
		
		public static function getInstance():GunSimple
		{
			return _instance;
		}
		
		public function set setHealth(value:Number):void
		{
			_health -= value;
		}
		
		public function get getHealth():int
		{
			return _health;
		}
		
		override public function free():void
		{
			if (!_isFree)
			{
				super.free();
				_isFree = true;
			}
		}

	}
}