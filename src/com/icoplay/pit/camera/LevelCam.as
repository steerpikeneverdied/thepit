package com.icoplay.pit.camera
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.icoplay.pit.entity.Player;

	import flash.geom.Point;

	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class LevelCam
	{
		private var _camera:FlxCamera;
		private var _railPoints : Vector.<Point>;
		private var _transitionDelay : int = 1;
		private var _currentCam : int = -1;
		public var targetCoords : FlxPoint = new FlxPoint();
		private var _transitioning:Boolean;
		private var _movementTimeline:TimelineMax;

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

		public function transitionCameraLocation(player:Player, instantFocus :Boolean = false):void
		{
			var distList : Array = [];

			for(var i : int = 0; i < _railPoints.length; i++)
			{
				var targetPoint : Point = _railPoints[i];
				var diffX : Number = targetPoint.x-player.x;
				var diffY : Number = targetPoint.y-player.y;

				var diffTot : Number = diffX*diffX + diffY*diffY;
				var hyp : Number = Math.sqrt(diffTot);

				distList.push({"value":hyp, "screen":i+1});
			}

			distList.sortOn("value",Array.NUMERIC);

			if(distList[0].screen !== _currentCam && !_transitioning)
			{
				if(instantFocus == false)
				{
					transitionToScreen(distList[0].screen, player);
				} else {
					targetCoords.x = player.x;
					targetCoords.y = player.y;

					setCamera(targetCoords);
					_currentCam = distList[0].screen;
				}
			}
		}

		public function transitionToScreen(screenNo : int, player:Player, callback : Function = null, callbackParams : Array = null) : void
		{
			var params : Object = {};
			params.x = _railPoints[screenNo-1].x;
			params.y = _railPoints[screenNo-1].y;
			params.onUpdate = setCamera;
			params.onUpdateParams = [targetCoords];
			params.onComplete = callback;
			params.onCompleteParams = callbackParams;

			_currentCam = screenNo;

			_movementTimeline = new TimelineMax({onComplete:onTransitionComplete, onCompleteParams:[player]});
			_movementTimeline.append(new TweenMax(targetCoords, _transitionDelay, params));

			_transitioning = true;

			player.pause();
		}

		public function setCamera(targetPoint : FlxPoint) : void
		{
			_camera.focusOn(targetPoint);
		}

		public function onTransitionComplete(player:Player) : void
		{
			_movementTimeline._kill();
			_movementTimeline = null;
			player.unpause();
			_transitioning = false;
		}

		public function followSprite(sprite:FlxSprite):void
		{
			_camera.zoom = 4;
			_camera.follow(sprite);
		}

		public function destroy():void
		{
			if(_camera)
			{
				FlxG.removeCamera(_camera);
				_camera = null;
			}

			if(_railPoints)
			{
				for(var i : int = 0; i<_railPoints.length; i++)
				{
					_railPoints[i] = null;
				}

				_railPoints.length = 0;
				_railPoints = null;
			}

			if(targetCoords)
			{
				targetCoords = null;
			}

			if(_movementTimeline)
			{
				_movementTimeline.kill();
				_movementTimeline = null;
			}
		}
	}
}
