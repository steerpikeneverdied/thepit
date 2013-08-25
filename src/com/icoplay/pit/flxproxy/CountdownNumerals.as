package com.icoplay.pit.flxproxy
{
	import com.icoplay.pit.assets.countdownNumerals;

	import flash.display.Bitmap;

	public class CountdownNumerals extends Bitmap
	{
		public function CountdownNumerals()
		{
			this.bitmapData = new countdownNumerals();
		}
	}
}
