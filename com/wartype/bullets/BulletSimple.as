package com.wartype.bullets
{
	public class BulletSimple extends BulletBase
	{
		public function BulletSimple()
		{
			sprite = new bullet_mc();
		}
		
		public override function free():void
		{
			super.free();
			isFree = true;
		}
		
	}
}