package com.wartype.explosions
{
	import flash.display.DisplayObjectContainer;
	
	public class MediumExplosion extends AbstractExplosion
	{
		public function MediumExplosion(container:DisplayObjectContainer)
		{
			super(container);
		}

		override protected function setProps():void
		{
			numberOfFireballs = 10;
			explosionRange = 35;
			growScale = Math.random() * 100 * .01;
			growSpeed = .1;
			growAlpha = Math.random() * 200 * .01;
			fadeSpeed = .15;
			randomRangeX = Math.random() * explosionRange - explosionRange * .5;
			randomRangeY = Math.random() * explosionRange - explosionRange * .5;
			randomNumber = Math.round(Math.random());
			speedX = 0;
			speedY = 0;
			randomBlur = 0;
		}

		override protected function createLight(targetX:Number, targetY:Number):void
		{
			tempParticle = new Particle(new fireballLight_mc());

			tempParticle.x = targetX;
			tempParticle.y = targetY;
			tempParticle.scaleX = 2;
			tempParticle.scaleY = 2;
			tempParticle.alpha = .5;
			tempParticle.setGrowSpeed = .5;
			tempParticle.setFadeSpeed = .1;
			tempParticle.setVx = 0;
			tempParticle.setVy = 0;

			container.addChild(tempParticle);

			particles.push(tempParticle);
		}
	}
}