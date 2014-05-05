package com.wartype.controllers
{
	import com.wartype.Universe;
	import com.wartype.interfaces.IObject;
	
	public class ObjectController extends Object
	{
		private var _universe:Universe = Universe.getInstance(); //Ссылка на игровой мир
		
		public var objects:Array = []; //Массив объектов
		
		
		public function ObjectController()
		{
			
		}
		
		//Добавление объекта в массив
		public function add(obj:IObject):void
		{
			objects[objects.length] = obj;
		}
		
		//Удаление объекта из массива
		public function remove(obj:IObject):void
		{
			for (var i:int = 0; i < objects.length; i++)
			{
				if (objects[i] == obj)
				{
					objects[i] = null;
					objects.splice(i, 1);
					break;
				}
			}
		}
		
		//Очистить массив объектов
		public function clear():void
		{
			while (objects.length > 0)
			{
				objects[0].free();
			}
		}
		
		//Обновление всех объектов в массиве
		public function update(delta:Number):void
		{
			for (var i:int = objects.length - 1; i >= 0; i--)
			{
				objects[i].update(delta);
			}
		}
	}
}