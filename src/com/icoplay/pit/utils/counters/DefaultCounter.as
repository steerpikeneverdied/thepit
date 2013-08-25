package com.icoplay.pit.utils.counters
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;

	public class DefaultCounter extends FlxBitmapFont
	{
		private var _cam:FlxCamera;
		private var _countTween : TweenMax;
		public var _counterTotal:int;

		public function DefaultCounter(xPos:int, yPos:int, counterTotal:int, callback : Function)
		{
			var cs : CounterSettings = CounterSettings.DEFAULT;

			super(cs.font,cs.width,cs.height,cs.glyphs,cs.charsPerRow);

			setInitialValue(counterTotal);
			createCustomCam(xPos, yPos, cs);
			beginCountdown(callback);
		}

		private function setInitialValue(counterTotal:int):void
		{
			_counterTotal = counterTotal;
			setText(counterTotal.toString());
		}

		private function createCustomCam(xPos:int, yPos:int, cs:CounterSettings):void
		{
			_cam = new FlxCamera(xPos - (width*cs.magnification), yPos, width, height, cs.magnification);
			_cam.follow(this);
			FlxG.addCamera(_cam);
		}

		private function beginCountdown(callback:Function):void
		{
			_countTween = new TweenMax(this, _counterTotal, {_counterTotal:0, ease:Linear.easeNone, onComplete:callback});
		}

		public override function update() : void
		{
			if(_cam)
			{
				setText(_counterTotal.toString());
			}
		}

		public override function destroy() : void
		{
			if(_cam)
			{
				FlxG.removeCamera(_cam);
				_cam.visible = false;
				_cam = null;
			}

			if(_countTween)
			{
				_countTween.kill();
				_countTween = null;
			}

			super.destroy();
		}
	}
}
