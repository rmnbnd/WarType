package com.wartype.explosions
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class Particle extends Sprite
	{
		private var graphic:DisplayObjectContainer;
		private var growSpeed:Number;
		private var fadeSpeed:Number;
		private var vx:Number;
		private var vy:Number;

		public function Particle(graphic:DisplayObjectContainer) 
		{
			this.graphic = graphic;
			addChild(graphic);
		}
		
		public function get getGrowSpeed():Number
		{
			return growSpeed;
		}
		
		public function set setGrowSpeed(value:Number):void
		{
			growSpeed = value;
		}
		
		public function get getFadeSpeed():Number
		{
			return fadeSpeed;
		}
		
		public function set setFadeSpeed(value:Number):void
		{
			fadeSpeed = value;
		}
		
		public function get getVx():Number
		{
			return vx;
		}
		
		public function set setVx(value:Number):void
		{
			vx = value;
		}
		
		public function get getVy():Number
		{
			return vy;
		}
		
		public function set setVy(value:Number):void
		{
			vy = value;
		}
		
	}

}