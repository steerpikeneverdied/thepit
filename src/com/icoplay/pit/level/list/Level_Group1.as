//Code generated with DAME. http://www.dambots.com

package com.icoplay.pit.level.list
{
	import com.icoplay.pit.level.dame.BaseLevel;

	import org.flixel.*;
	import flash.utils.Dictionary;
	public class Level_Group1 extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../../../../../assets/csv/mapCSV_Group1_Map1.csv", mimeType="application/octet-stream")] public var CSV_Map1:Class;
		[Embed(source="../../../../../../assets/import/platform tiles/soilTiles.png")] public var Img_Map1:Class;

		//Tilemaps
		public var layerMap1:FlxTilemap;

		//Properties


		public function Level_Group1(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			layerMap1 = addTilemap( CSV_Map1, Img_Map1, -169.000, -25.000, 11, 11, 1.000, 1.000, false, 1, 0, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layerMap1);

			if ( addToStage )
				createObjects(onAddCallback, parentObject);

			boundsMinX = -169;
			boundsMinY = -25;
			boundsMaxX = 161;
			boundsMaxY = 305;
			boundsMin = new FlxPoint(-169, -25);
			boundsMax = new FlxPoint(161, 305);
			bgColor = 0xff777777;
		}

		override public function createObjects(onAddCallback:Function = null, parentObject:Object = null):void
		{
			generateObjectLinks(onAddCallback);
			if ( parentObject != null )
				parentObject.add(masterLayer);
			else
				FlxG.state.add(masterLayer);
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
		}

	}
}
