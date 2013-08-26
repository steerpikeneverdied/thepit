package com.icoplay.pit.entity
{
	import com.icoplay.pit.asset.RefLib;
	import org.flixel.FlxSprite;

	public class Target extends FlxSprite
	{
		public static const NAME : String = 'Target';

		public function Target()
		{
			super();
			loadSpriteSheet();

			centerOffsets(true);
		}

		private function loadSpriteSheet():void
		{
			loadGraphic(RefLib.TargetG,true,true,17,17);
			addAnimation("spin", [1,2,3,4,5,6,7,8,9,10], 12, true);

			this.play("spin");
		}
	}
}
