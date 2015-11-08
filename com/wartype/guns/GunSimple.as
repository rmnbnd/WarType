package com.wartype.guns
{
	public class GunSimple extends GunBase
	{
		public function GunSimple()
		{
			bulletSpeed = GunConstants.BULLET_SPEED;
			health = GunConstants.GUN_HEALTH;
			body = new gun_body_mc();
			head = new gun_head_mc();
			healthSprite = new gunHealth_mc();
			
			init();
		}
		
		override public function free():void
		{
			if (!isFree)
			{
				super.free();
				isFree = true;
			}
		}
	}
}