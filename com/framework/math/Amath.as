package com.framework.math
{
	
	public class Amath extends Object
	{

		public static var STRAIGHT_ANGLE:Number = 180;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * Рассчитывает дистанцию между двумя точками.
		 * 
		 * @param x1, y1 - координаты первой точки.
		 * @param x2, y2 - коордианты второй точки.
		 * 
		 * @return дистанция.
		 */
		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Возвращает случайное число в диапазоне от lower до upper.
		 * 
		 * @param lower - наименьшее число диапазона.
		 * @param upper - наибольшее число диапазона.
		 * 
		 * @return случайное целое число.
		 */
		public static function random(lower:Number, upper:Number):Number
		{
			return Math.round(Math.random() * (upper - lower)) + lower;
		}
		
		/**
		 * Сравнивает два значения с заданной погрешностью.
		 * 
		 * @param a, b - сравниваемые значения.
		 * @param diff - допустимая погрешность.
		 * 
		 * @return возвращает true если значения равны, или false если не равны.
		 */
		public static function equal(a:Number, b:Number, diff:Number = 0.00001):Boolean
		{
			return (Math.abs(a - b) <= diff);
		}
		
		/**
		 * Возвращает угол между двумя точками радианах.
		 * 
		 * @param x1, y1 - координаты первой точки.
		 * @param x2, y2 - координаты второй точки.
		 * 
		 * @return угол между двумя точками в радианах.
		 */
		public static function getAngle(x1:Number, y1:Number, x2:Number, y2:Number, norm:Boolean = true):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var angle:Number = Math.atan2(dy, dx);
			
			if (norm)
			{
				if (angle < 0)
				{
					angle = Math.PI * 2 + angle;
				}
				else if (angle >= Math.PI * 2)
				{
					angle = angle - Math.PI * 2;
				}
			}
			
			return angle;
		}
		
		/**
		 * Возвращает угол между двумя точками в градусах.
		 * 
		 * @param x1, y1 - координаты первой точки.
		 * @param x2, y2 - координаты второй точки.
		 * 
		 * @return угол между двумя точками в градусах.
		 */
		public static function getAngleDeg(x1:Number, y1:Number, x2:Number, y2:Number, norm:Boolean = true):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var angle:Number = Math.atan2(dy, dx) / Math.PI * 180;
			
			if (norm)
			{
				if (angle < 0)
				{
					angle = 360 + angle;
				}
				else if (angle >= 360)
				{
					angle = angle - 360;
				}
			}
			
			return angle;
		}
		
		/**
		 * Переводит угол из радиан в градусы.
		 * 
		 * @param radians - угол в радианах.
		 * 
		 * @return угол в градусах.
		 */
		public static function toDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Переводит угол из градусов в радианы.
		 * 
		 * @param degrees - угол в градусах.
		 * 
		 * @return угол в радианах.
		 */
		public static function toRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		/**
		 * Возвращает процент значения current от общего значения total.
		 * 
		 * @param current - текущее значение.
		 * @param total - общее значение.
		 * 
		 * @return percent.
		 */
		public static function toPercent(current:Number, total:Number):Number
		{
			return (current / total) * 100;
		}
		
		/**
		 * Возвращает текущее значене исходя из процентного соотношения к общему числу.
		 * 
		 * @param percent - текущий процент.
		 * @param total - общее значение.
		 * 
		 * @return возвращает текущее значение.
		 */
		public static function fromPercent(percent:Number, total:Number):Number
		{
			return (percent * total) / 100;
		}

	}

}