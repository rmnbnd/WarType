package com.wartype.guns
{
	public class GunSimple extends GunBase
	{
		
		public function GunSimple()
		{
			_bulletSpeed = 800;
			_health = 100;
			_body = new gun_body_mc();
			_head = new gun_head_mc();
			_textSprite = new textlabel_mc();
			
			init(); //Инициализируем пушку
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