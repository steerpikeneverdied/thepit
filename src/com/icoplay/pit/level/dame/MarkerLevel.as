package com.icoplay.pit.level.dame
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;

	public class MarkerLevel extends BaseLevel
	{
		public static const SPRITE_OFFSET_X : int = 169;
		public static const SPRITE_OFFSET_Y : int = 25;

		public var layerPlatforms:FlxTilemap;
		private var _ObjectsGroup:FlxGroup;

		public function MarkerLevel()
		{
		}

		public function getTilemap() : FlxTilemap
		{
			return layerPlatforms;
		}

		public function getObjects() : FlxGroup
		{
			return ObjectsGroup;
		}

		public function get ObjectsGroup():FlxGroup
		{
			if(_ObjectsGroup == null)
			{
				_ObjectsGroup = new FlxGroup();
			}
			return _ObjectsGroup;
		}

		public function set ObjectsGroup(value:FlxGroup):void
		{
			_ObjectsGroup = value;
		}
	}
}
