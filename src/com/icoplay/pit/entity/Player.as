package com.icoplay.pit.entity
{
	import com.icoplay.pit.flxproxy.PlayerSpriteSheet;

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;

	public class Player extends FlxSprite
	{
		protected static const PLAYER_RUN_SPEED:int = 80;
		protected static const GRAVITY_ACCELERATION:Number = 450;
		protected static const JUMP_ACCELERATION:Number = 150;

		private static const _kDefaultHeightOffset:int = 2;

		private var _jump:Number = 0;
		private var _shooting:Boolean;

		public function Player(offsetX : int = -1)
		{
			super();

			loadSpriteSheet();
			changeOffset(offsetX);
			setupVariables();
		}

		private function changeOffset(offsetX:int):void
		{
			if(offsetX == -1)
			{
				offsetX = (Math.ceil(width/4)+1);
			}

			offset.x = offsetX;
			width = width-offsetX*2;
			height = height - _kDefaultHeightOffset;
			centerOffsets();
		}

		private function loadSpriteSheet():void
		{
			loadGraphic(PlayerSpriteSheet,true,true,22,23);
			addAnimation("walking", [5, 6, 7, 8, 9], 12, true);
			addAnimation("shooting", [0, 1, 2, 3, 4], 30, true);
			addAnimation("idle", [10, 11, 12, 13, 14], 12, true);
		}

		private function setupVariables():void
		{
			drag.x = PLAYER_RUN_SPEED * 8;
			acceleration.y = GRAVITY_ACCELERATION;
			maxVelocity.x = PLAYER_RUN_SPEED;
			maxVelocity.y = JUMP_ACCELERATION;
		}

		public override function update():void
		{
			super.update();

			resetValues();
			checkMovement();
			checkJump();
			checkShooting();
			playAnimation();
		}

		private function resetValues():void
		{
			_shooting = false;
			acceleration.x = 0;
		}

		private function checkShooting():void
		{
			if(FlxG.mouse.pressed())
			{
				_shooting = true;

				if (FlxG.mouse.x < this.getMidpoint().x)
				{
					facing = LEFT;
				} else {
					facing = RIGHT;
				}
			}
		}

		private function checkJump():void
		{
			if(_jump >= 0 && (FlxG.keys.W || FlxG.keys.UP || FlxG.keys.SPACE))
			{
				_jump += FlxG.elapsed;
				if(_jump > 0.25)
					_jump = -1;
			} else {
				_jump = -1;
			}
			if(_jump > 0)
			{
				if(_jump < 0.065)
					velocity.y = -JUMP_ACCELERATION/2;
				else
					velocity.y = -maxVelocity.y;
			}

			if(isTouching(FlxObject.DOWN))
			{
				_jump = 0;
			}
		}

		private function playAnimation():void
		{
			if(_shooting)
			{
				play("shooting");
			} else if (velocity.x) {
				play("walking");
			}else if(!velocity.x){
				play("idle");
			}
		}

		private function checkMovement():void
		{
			if(!_shooting || _jump !== 0)
			{
				if(FlxG.keys.LEFT || FlxG.keys.A)
				{
					moveLeft();
				}else if(FlxG.keys.RIGHT || FlxG.keys.D)
				{
					moveRight();
				}
			}
		}

		private function moveRight():void
		{
			facing = RIGHT;
			acceleration.x = drag.x;
		}

		private function moveLeft():void
		{
			facing = LEFT;
			acceleration.x = -drag.x;
		}
	}
}
