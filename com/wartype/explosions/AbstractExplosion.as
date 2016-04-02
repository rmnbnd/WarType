package com.wartype.explosions
{
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.GradientGlowFilter;

	public class AbstractExplosion 
	{
		protected var numberOfFireballs:Number;
		protected var explosionRange:Number;
		protected var growScale:Number;
		protected var growSpeed:Number;
		protected var growAlpha:Number;
		protected var fadeSpeed:Number;
		protected var speedY:Number;
		protected var speedX:Number;
		protected var randomRangeX:Number;
		protected var randomRangeY:Number;
		protected var randomNumber:Number;
		protected var randomBlur:Number;

		protected var tempParticle:Particle;
		protected var container:DisplayObjectContainer;
		protected var particles:Array = [];

		protected var blurFilter:BlurFilter;
		protected var gradientGlowFilter:GradientGlowFilter;


		public function AbstractExplosion(container:DisplayObjectContainer)
		{
			this.container = container;
			setProps();
		}

		public function create(targetX:Number, targetY:Number):void
		{
			for (var i:int = 0; i < numberOfFireballs; i++)
			{
				createFireball(targetX, targetY);
			}
			createLight(targetX, targetY);
		}

		public function update():void
		{
			for (var i:int = 0; i < particles.length; i++)
			{
				tempParticle = particles[i] as Particle;
				
				tempParticle.scaleX += tempParticle.getGrowSpeed;
				tempParticle.scaleY += tempParticle.getGrowSpeed;
				tempParticle.alpha -= tempParticle.getFadeSpeed;
				tempParticle.x -= tempParticle.getVx;
				tempParticle.y -= tempParticle.getVy;
				
				if (tempParticle.alpha <= 0)
				{
					destroyParticle(tempParticle);
				}
			}
		}

		public function blurExplosion():void {
			for (var i:int = 0; i < particles.length; i++)
			{
				tempParticle = particles[i] as Particle;
				blurFilter = new BlurFilter();
				blurFilter.blurX = 2.5;
				blurFilter.blurY = 2.5;
				blurFilter.quality = BitmapFilterQuality.HIGH;
				tempParticle.filters = [blurFilter];
			}
		}

		protected function setProps():void
		{

		}

		private function createFireball(targetX:Number, targetY:Number):void
		{
			tempParticle = new Particle(new fireball_mc());

			setProps();

			tempParticle.x = targetX + randomRangeX;
			tempParticle.y = targetY + randomRangeY;
			tempParticle.scaleX = growScale;
			tempParticle.scaleY = growScale;
			tempParticle.alpha = growAlpha;
			tempParticle.setGrowSpeed = growSpeed;
			tempParticle.setFadeSpeed = fadeSpeed;
			tempParticle.setVx = speedX;
			tempParticle.setVy = speedY;

			if (randomNumber == 1)
			{
				setupFilters();
				tempParticle.filters = [blurFilter, gradientGlowFilter];
			}

			container.addChild(tempParticle);
			particles.push(tempParticle);
		}

		protected function createLight(targetX:Number, targetY:Number):void
		{

		}

		protected function setupFilters():void
		{
			blurFilter = new BlurFilter();
			blurFilter.blurX = randomBlur;
			blurFilter.blurY = randomBlur;
			blurFilter.quality = BitmapFilterQuality.MEDIUM;

			gradientGlowFilter = new GradientGlowFilter();
			gradientGlowFilter.distance = 0;
			gradientGlowFilter.angle = 45;
			gradientGlowFilter.colors = [0x000000, 0xFF0000];
			gradientGlowFilter.alphas = [0, 1];
			gradientGlowFilter.ratios = [0, 255];
			gradientGlowFilter.blurX = randomBlur;
			gradientGlowFilter.blurY = randomBlur;
			gradientGlowFilter.strength = 2;
			gradientGlowFilter.quality = BitmapFilterQuality.LOW;
			gradientGlowFilter.type = BitmapFilterType.OUTER;
		}

		private function destroyParticle(particle:Particle):void
		{
			for (var i:int = 0; i < particles.length; i++)
			{
				tempParticle = particles[i] as Particle;
				if (tempParticle == particle)
				{
					particles.splice(i, 1);
					tempParticle.parent.removeChild(particle);
					return;
				}
			}
		}
	}
}