package com.wartype.bullets
{
	public class BulletSimple extends BulletBase
	{
		public function BulletSimple()
		{
			_sprite = new bullet_mc(); //Добавляем спрайт пули
		}
		
		public override function free():void
		{
			super.free();
			_isFree = true;
		}
		
	}
}