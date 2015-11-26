package com.framework.math
{
	
	public class Anumber
	{

		public static function toFixedNumber(number:Number, decPlaces:Number, sign:String, value:Number):Number
		{
			switch(sign) {
				case "plus":
					number += value;
					break;
				case "minus":
					number -= value;
					break;
				default: return number;

			}
			return Number(number.toFixed(decPlaces));
		}

		public static function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}

}