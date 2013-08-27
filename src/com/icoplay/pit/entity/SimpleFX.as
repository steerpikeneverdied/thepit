package com.icoplay.pit.entity
{
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxAnim;

	public class SimpleFX extends FlxSprite
	{
		public static const SINGLE:String = 'onePlayAnim';

		private var _currentFrame:uint = 0;

		public function SimpleFX()
		{
			super();
			addAnimationCallback(onFrameChange);
		}

		override public function update() : void
		{
			super.update();

			var currFlxAnim:FlxAnim = getFlxAnim();

			if (currFlxAnim !== null && _currentFrame >= currFlxAnim.frames.length-1)
			{
				this.kill();
			}
		}

		private function onFrameChange(animationName:String, currentFrame:uint, currentFrameIndex:uint):void
		{
			currentFrameIndex;

			if(animationName == SINGLE)
			{
				_currentFrame = currentFrame;
			}
		}

		public function getFlxAnim():FlxAnim
		{
			if (_curAnim)
				return (_curAnim)
			else
				return null ;
		}

	}
}
