package com.icoplay.pit.entity
{
	import com.icoplay.pit.asset.RefLib;
	import com.icoplay.pit.utils.BaseDefs;

	public class Explosion extends SimpleFX
	{
		public static const LARGE:Class = RefLib.ExplosionL;

		public function Explosion(type:Class)
		{
			super();
			loadSpriteSheet(type);
			this.play(SINGLE);
		}

		private function loadSpriteSheet(type:Class):void
		{
			loadGraphic(type,true,true,88,76);
			addAnimation(SimpleFX.SINGLE, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15], BaseDefs._kFXFrameRate, false);
		}
	}
}
