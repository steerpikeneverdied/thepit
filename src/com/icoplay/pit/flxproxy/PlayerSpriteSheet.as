package com.icoplay.pit.flxproxy
{
	import com.icoplay.pit.assets.playerSprite;

	import flash.display.Bitmap;

	public class PlayerSpriteSheet extends Bitmap
	{
		public function PlayerSpriteSheet()
		{
			this.bitmapData = new playerSprite();
		}
	}
}
