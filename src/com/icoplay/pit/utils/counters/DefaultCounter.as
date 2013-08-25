package com.icoplay.pit.utils.counters
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;

	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;

	public class DefaultCounter extends FlxBitmapFont
	{
		private var _cam:FlxCamera;
		private var _countTween : TweenMax;
		private var _pulseTween : TweenMax;
		private const _kPulseScale : Number = 1.5;
		private const _kPulseDuration : Number = 0.5;
		public var _counterTotal:int;
		private var _dangerTime:int;
		private var _kDangerZone:Number = 0.3;

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
			_dangerTime = counterTotal * _kDangerZone;

			setText(counterTotal.toString());
		}

		private function createCustomCam(xPos:int, yPos:int, cs:CounterSettings):void
		{
			var scWidth : Number = width*_kPulseScale;
			var scHeight : Number = height*_kPulseScale;

			_cam = new FlxCamera(xPos - (scWidth*cs.magnification), yPos, scWidth, scHeight, cs.magnification);
			_cam.bgColor = 0x0;
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
				_cam.fill(0xFFFFFFFF, false);
				_cam.fill(0x0, false);
				var time : int = int(_counterTotal);

				if(time.toString() !== text && time < (_dangerTime))
				{
					this.color = 0xFFFF0000;
					pulseNumber(time);
				}
				setText(time.toString());
			}
		}

		private function pulseNumber(time : Number):void
		{
			var params : Object = {};
			params.y = params.x = 1 + ((_kPulseScale-1) * (1-(time/_dangerTime)));
			params.onComplete = resetScale;
			params.ease = Elastic.easeOut;

			_pulseTween = new TweenMax(this.scale, _kPulseDuration, params);
		}

		private function resetScale():void
		{
			if(_pulseTween)
			{
				_pulseTween.kill();
			}

			scale.x = 1;
			scale.y = 1;
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
