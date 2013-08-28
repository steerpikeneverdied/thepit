//Code generated with DAME. http://www.dambots.com

package com.icoplay.pit.level.list
{
	import com.icoplay.pit.level.dame.Marker;
	import com.icoplay.pit.level.dame.MarkerLevel;

	import org.flixel.*;
	import flash.utils.Dictionary;
	public class Level_1 extends MarkerLevel
	{
		//Embedded media...
		[Embed(source="../../../../../../assets/csv/mapCSV_1_Platforms.csv", mimeType="application/octet-stream")] public var CSV_Platforms:Class;
		[Embed(source="../../../../../../assets/import/platform tiles/soilTiles.png")] public var Img_Platforms:Class;


		public function Level_1(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			tileProperties[2]=generateProperties( { name:"ReplaceKey", value:0 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerPlatforms = addTilemap( CSV_Platforms, Img_Platforms, -169.000, -25.000, 11, 11, 1.000, 1.000, false, 1, 0, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layerPlatforms);
			masterLayer.add(ObjectsGroup);

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
			addSpritesForLayerObjects(onAddCallback);
			generateObjectLinks(onAddCallback);
			if ( parentObject != null )
				parentObject.add(masterLayer);
			else
				FlxG.state.add(masterLayer);
		}

		public function addSpritesForLayerObjects(onAddCallback:Function = null):void
		{
			addSpriteToLayer(null, Marker, ObjectsGroup , -81.000, 26.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"ReplaceKey", value:0 }, null ), onAddCallback );//"Marker"
			addSpriteToLayer(null, Marker, ObjectsGroup , 40.000, 26.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"ReplaceKey", value:0 }, null ), onAddCallback );//"Marker"
			addSpriteToLayer(null, Marker, ObjectsGroup , 51.000, 147.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"ReplaceKey", value:0 }, null ), onAddCallback );//"Marker"
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
		}

	}
}
