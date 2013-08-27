package com.icoplay.pit.utils
{
	import org.flixel.FlxObject;
	import org.flixel.FlxU;

	public class FlxSort
	{
		public static function sortCollision(Object1:FlxObject,Object2:FlxObject, targ : String, secTarg : String = null) : Array
		{
			var nameList : Array = [getClassName(Object1), getClassName(Object2)];
			nameList.sort();

			var targList : Array = [targ, secTarg];
			targList.sort();

			if(getClassName(Object1) == targ && getClassName(Object2) == secTarg || getClassName(Object2) == targ && getClassName(Object1) == secTarg)
			{
				if(getClassName(Object1) == targ)
				{
					return [Object1, Object2, true];
				}

				if(getClassName(Object2) == targ)
				{
					return [Object2, Object1, true];
				}
			}

			return [null, null, false];
		}

		public static function getClassName(object : FlxObject) : String
		{
			var className : String = FlxU.getClassName(object);
			className = (className.substr(className.lastIndexOf('.'))).substr(1);

			return className;
		}
	}
}
