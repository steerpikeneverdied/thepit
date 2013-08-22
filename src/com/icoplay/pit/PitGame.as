package com.icoplay.pit
{
	import com.icoplay.pit.states.PlayState;
	import com.icoplay.pit.test.TestFlags;

	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	public class PitGame extends FlxGame
	{
		private const _kGameWidth : int = 836;
		private const _kGameHeight : int = 836;

		public function PitGame()
		{
			super(_kGameWidth/TestFlags._kMagnification,_kGameHeight/TestFlags._kMagnification,PlayState,TestFlags._kMagnification, 60, 60, true);

			if(TestFlags._kFlxDebug == true)
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
