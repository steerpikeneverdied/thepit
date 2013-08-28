package com.icoplay.pit.level.dame
{
	import org.flixel.FlxSprite;

	public class Marker extends FlxSprite
	{
		private var _repKey:int;

		public function Marker(x:Number, y:Number)
		{
			super(x,y);
		}

		public function get repKey():int
		{
			return _repKey;
		}

		public function set repKey(value:int):void
		{
			_repKey = value;
		}
	}
}
