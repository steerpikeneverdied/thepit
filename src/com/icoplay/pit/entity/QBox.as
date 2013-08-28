package com.icoplay.pit.entity
{
	import com.icoplay.pit.asset.RefLib;

	import org.flixel.FlxSprite;

	public class QBox extends FlxSprite
	{
		public static const NAME : String = 'QBox';
		public static const BONUSES : Array = ['Triple', 'Speed'];

		public function QBox()
		{
			super();
			loadSpriteSheet();

			centerOffsets(true);
		}

		private function loadSpriteSheet():void
		{
			loadGraphic(RefLib.QBoxG,true,true,10,10);
			addAnimation("spin", [1,2,3,4,5,6,7,8], 12, true);

			this.play("spin");
		}

		public function getBonus():int
		{
			return Math.floor(Math.random()*BONUSES.length);
		}
	}
}
