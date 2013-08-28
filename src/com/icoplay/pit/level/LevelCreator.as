package com.icoplay.pit.level
{
	import com.icoplay.pit.entity.QBox;
	import com.icoplay.pit.entity.Target;
	import com.icoplay.pit.level.dame.BaseLevel;
	import com.icoplay.pit.level.dame.Marker;
	import com.icoplay.pit.level.dame.MarkerLevel;
	import com.icoplay.pit.level.list.Level_1;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	public class LevelCreator
	{
		private const _kLevelsPerGame : int = 5;

		private var _levelList : Vector.<Class> = new Vector.<Class>();
		public var levelWidth : int;
		public var levelHeight : int;

		private var TOP : Point      = new Point(1,0);
		private var LEFT : Point     = new Point(0,1);
		private var CENTRE : Point   = new Point(1,1);
		private var RIGHT : Point    = new Point(2,1);
		private var BOTTOM : Point   = new Point(1,2);
		private var COORDS : Vector.<Point> = new <Point>[TOP,LEFT,CENTRE,RIGHT,BOTTOM];

		private var CLASSES : Vector.<Class> = new <Class>[QBox, Target];

		private var _railPoints : Vector.<Point> = new Vector.<Point>();
		private var _objectGroup : FlxGroup;


		public function LevelCreator()
		{
			populateLevelList();
		}

		private function populateLevelList():void
		{
			_levelList.push(Level_1);
			_levelList.push(Level_1);
			_levelList.push(Level_1);
			_levelList.push(Level_1);
			_levelList.push(Level_1);
		}

		public function createLevelMap(levelGroup:FlxGroup, objectGroup:FlxGroup):void
		{
			_objectGroup = objectGroup;

			var levelList : Vector.<Class> = returnLevelSelection();

			for(var i : int = 0; i<levelList.length; i++)
			{
				createLevel(levelGroup, levelList[i], COORDS[i]);
			}
		}

		public function returnLevelSelection() : Vector.<Class>
		{
			var tempList : Vector.<Class> = new Vector.<Class>();

			for(var i : int = 0; i<_kLevelsPerGame; i++)
			{
				tempList.push(_levelList[Math.floor(Math.random()*_levelList.length)]);
			}

			return tempList;
		}

		private function createLevel(levelGroup : FlxGroup, levelToLoad:Class, offset : Point):void
		{
			var level : MarkerLevel = new levelToLoad(true, onObjectAdded, levelGroup);


			var tm : FlxTilemap = level.getTilemap();
			tm.x = offset.x * tm.width;
			tm.y = offset.y * tm.height;
			_railPoints.push(new Point(tm.x + tm.width/2, tm.y + tm.height/2));


			var objs : FlxGroup = level.getObjects();

			for(var i:int = 0; i<objs.members.length-1; i++)
			{
				var obj : FlxObject = objs.members[i];
				obj.x += tm.x + MarkerLevel.SPRITE_OFFSET_X;
				obj.y += tm.y + MarkerLevel.SPRITE_OFFSET_Y;

				if(Class(getDefinitionByName(getQualifiedClassName(obj))) == Marker)
				{
					var repItem : FlxSprite = new ((CLASSES[(obj as Marker).repKey]));
					repItem.x = obj.x;
					repItem.y = obj.y;

					_objectGroup.add(repItem);
					objs.remove(obj);
				}
			}

			setDefaultDimensions(tm);
		}

		private function onObjectAdded(data:Object, layer:FlxGroup, level:BaseLevel, scrollX:Number, scrollY:Number, properties : Array):void
		{
			if(Class(getDefinitionByName(getQualifiedClassName(data))) == Marker)
			{
				(data as Marker).repKey = properties[0];
			}
		}

		private function setDefaultDimensions(levelMap:FlxTilemap):void
		{
			levelWidth = levelMap.width;
			levelHeight = levelMap.height;
		}

		private static function getBitmapData(levelToLoad:Class):BitmapData
		{
			var bitmap : Bitmap = new levelToLoad() as Bitmap;
			var levelBitmapData : BitmapData = bitmap.bitmapData.clone();

			bitmap.bitmapData = null;
			bitmap = null;

			return levelBitmapData;
		}

		public function get railPoints():Vector.<Point>
		{
			return _railPoints;
		}

		public function destroy() : void
		{
			var i : int;

			if(_levelList)
			{
				for(i = 0; i<_levelList.length; i++)
				{
					_levelList[i] = null;
				}

				_levelList.length = 0;
				_levelList = null;
			}

			if(COORDS)
			{
				for(i = 0; i<COORDS.length; i++)
				{
					COORDS[i] = null;
				}

				COORDS.length = 0;
				COORDS = null;
			}

			if(_railPoints)
			{
				for(i = 0; i<_railPoints.length; i++)
				{
					_railPoints[i] = null;
				}

				_railPoints.length = 0;
				_railPoints = null;
			}
		}
	}
}
