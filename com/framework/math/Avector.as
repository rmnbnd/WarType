package com.framework.math
{
	
	public class Avector extends Object
	{
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		public var x:Number = 0;
		public var y:Number = 0;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function Avector(ax:Number = 0, ay:Number = 0)
		{
			x = ax;
			y = ay;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Копирует параметры переданного вектора
		 * 
		 * @param v - вектор параметры которого будут скопированы
		 */
		public function copy(v:Avector):void
		{
			x = v.x;
			y = v.y;
		}
		
		/**
		 * Устанавливает новые значения вектора
		 */
		public function set(ax:Number = 0, ay:Number = 0):void
		{
			x = ax;
			y = ay;
		}
		
		/**
		 * Складывает значения указанного вектора с текущими
		 * 
		 * @param v - вектор значения которого будут сложены
		 */
		public function add(v:Avector):void
		{
			x += v.x;
			y += v.y;
		}
		
		/**
		 * Сравнивает указанный вектор с текущим с определенной погрешностью
		 * 
		 * @param v - вектор с которым производится сравнение
		 * @param diff - допустимая погрешность
		 * 
		 * @return возвращает true если векторы равны, или false если не равны
		 */
		public function equal(v:Avector, diff:Number = 0.00001):Boolean
		{
			return (Amath.equal(x, v.x, diff) && Amath.equal(y, v.y, diff));
		}
		
		/**
		 * Устанавливает значения вектора как векторную скорость
		 * 
		 * @param speed - скорость
		 * @param angle - угол движения в радианах
		 */
		public function asSpeed(speed:Number, angle:Number):void
		{
			x = speed * Math.cos(angle);
			y = speed * Math.sin(angle);
		}
		
		/**
		 * @public
		 */
		public function toString():String
		{
			return "{Avector: " + x.toString() + ", " + y.toString() + "}";
		}
	}

}