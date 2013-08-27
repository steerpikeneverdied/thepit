package com.icoplay.pit.level
{
	import com.icoplay.pit.asset.RefLib;
	import com.icoplay.pit.level.dame.BaseLevel;
	import com.icoplay.pit.level.list.Level_Group1;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.FlxGroup;
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

		private var _railPoints : Vector.<Point> = new Vector.<Point>();


		public function LevelCreator()
		{
			populateLevelList();
		}

		private function populateLevelList():void
		{
			_levelList.push(Level_Group1);
			_levelList.push(Level_Group1);
			_levelList.push(Level_Group1);
			_levelList.push(Level_Group1);
			_levelList.push(Level_Group1);
//			_levelList.push(RefLib.Level2);
//			_levelList.push(RefLib.Level3);
//			_levelList.push(RefLib.Level4);
//			_levelList.push(RefLib.Level5);
		}

		public function createLevelMap(levelGroup:FlxGroup):void
		{
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
			var level : BaseLevel = new levelToLoad(true, null, levelGroup);

			var levelMap : FlxTilemap = level.masterLayer.getFirstExtant() as FlxTilemap;

			levelMap.x = offset.x * levelMap.width;
			levelMap.y = offset.y * levelMap.height;

			_railPoints.push(new Point(levelMap.x + levelMap.width/2, levelMap.y + levelMap.height/2));

			setDefaultDimensions(levelMap);
		}

		private function onLevelAdded():void
		{

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
