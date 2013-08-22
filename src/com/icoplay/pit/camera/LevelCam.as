package com.icoplay.pit.camera
{
	import com.greensock.TweenMax;

	import flash.geom.Point;

	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class LevelCam
	{
		private var _camera:FlxCamera;
		private var _railPoints : Vector.<Point>;
		private var _movementTween : TweenMax;
		private var _transitionDelay : int = 1;
		private var _currentCam : int = -1;
		public var targetCoords : FlxPoint = new FlxPoint();

		public function LevelCam()
		{
			this._camera = FlxG.camera;
		}

		public function setBounds(_x:int, _y:int, width:int, height:int, _updateWorld : Boolean) : void
		{
			_camera.setBounds(_x,_y,width,height, _updateWorld);
		}

		public function set railPoints(value:Vector.<Point>):void
		{
			_railPoints = value;
		}

		public function checkCameraLocation(playerX:Number, playerY:Number):void
		{
			var distList : Array = [];

			for(var i : int = 0; i < _railPoints.length; i++)
			{
				var targetPoint : Point = _railPoints[i];
				var diffX : Number = targetPoint.x-playerX;
				var diffY : Number = targetPoint.y-playerY;

				var diffTot : Number = diffX*diffX + diffY*diffY;
				var hyp : Number = Math.sqrt(diffTot);

				distList.push({"value":hyp, "screen":i+1});
			}

			distList.sortOn("value",Array.NUMERIC);

			if(distList[0].screen !== _currentCam)
			{
				transitionToScreen(distList[0].screen);
			}
		}

		public function transitionToScreen(screenNo : int, callback : Function = null, callbackParams : Array = null) : void
		{
			if(_movementTween)
			{
				_movementTween.kill();
			}

			var params : Object = {};
			params.x = _railPoints[screenNo-1].x;
			params.y = _railPoints[screenNo-1].y;
			params.onUpdate = setCamera;
			params.onUpdateParams = [targetCoords];
			params.onComplete = callback;
			params.onCompleteParams = callbackParams;

			_currentCam = screenNo;

			_movementTween = new TweenMax(targetCoords, _transitionDelay, params);
		}

		public function setCamera(targetPoint : FlxPoint) : void
		{
			_camera.focusOn(targetPoint);
		}

		public function followSprite(sprite:FlxSprite):void
		{
			_camera.follow(sprite);
		}
	}
}
