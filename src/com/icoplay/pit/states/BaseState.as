package com.icoplay.pit.states
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;

	public class BaseState extends FlxState
	{
		private const _kbgColor : int = 0xFFFFFFFF;

		public override function create(): void
		{
			changeBGColor();
		}

		private function changeBGColor():void
		{
			FlxG.bgColor = _kbgColor;
		}
	}
}
