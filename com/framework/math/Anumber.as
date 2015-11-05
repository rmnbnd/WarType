package com.framework.math
{
	
	public class Anumber
	{

		public static function toFixedNumber(number:Number, decPlaces:Number, sign:String, value:Number):Number
		{
			var resultNumber:Number = number;
			if("plus" == sign)
			{
				resultNumber += value;
				return Number(resultNumber.toFixed(decPlaces));
			}
			else if("minus" == sign)
			{
				resultNumber -= value;
				return Number(resultNumber.toFixed(decPlaces));
			}
			return 0;
		}

	}

}