package com.icoplay.pit
{
	import com.greensock.TweenMax;
	import com.icoplay.pit.states.PlayState;
	import com.icoplay.pit.utils.BaseDefs;

	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	public class PitGame extends FlxGame
	{
		private const _kGameWidth : int = 836;
		private const _kGameHeight : int = 836;

		public function PitGame()
		{
			super(_kGameWidth/BaseDefs._kMagnification,_kGameHeight/BaseDefs._kMagnification,PlayState,BaseDefs._kMagnification, 60, 60, true);

			if(BaseDefs._kFlxDebug == true)
			{
				FlxG.debug = true;
				FlxG.visualDebug = true;
			}
		}

		public function destroy():void
		{
		}
	}
}
