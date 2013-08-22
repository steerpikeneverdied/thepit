package com.icoplay.pit
{
	import flash.display.Sprite;

	[SWF(width=836, height=836, frameRate=60)]

	public class Bootstrap extends Sprite
	{
		private var _pitGame:PitGame;

	    public function Bootstrap()
	    {
			initialiseGame();
	    }

		private function initialiseGame():void
		{
			_pitGame = new PitGame();
			addChild(_pitGame);
		}

		public function destroy() : void
		{
			if(_pitGame)
			{
				if(_pitGame.parent)
				{
					_pitGame.parent.removeChild(_pitGame);
				}

				_pitGame.destroy();
				_pitGame = null;
			}
		}
	}
}
