package com.icoplay.pit.entity
{
	import com.icoplay.pit.flxproxy.PlayerSpriteSheet;

	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxControl;
	import org.flixel.plugin.photonstorm.FlxControlHandler;
	import org.flixel.plugin.photonstorm.FlxWeapon;

	public class Player extends FlxSprite
	{
		private static const _kDefaultHeightOffset:int = 2;

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
			addAnimation("walk", [5, 6, 7, 8, 9], 12, true);
			addAnimation("shooting", [0, 1, 2, 3, 4], 30, true);
			addAnimation("idle", [10, 11, 12, 13, 14], 12, true);
		}

		private function setupVariables() : void
		{
			activatePlugin();
			setPlayerControls();
		}

		private function setPlayerControls():void
		{
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			FlxControl.player1.setWASDControl(true, false, true, true);
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 200, FlxObject.FLOOR, 250, 200);

			FlxControl.player1.setMovementSpeed(400, 0, 100, 200, 400, 0);

			FlxControl.player1.setGravity(0, 400);
		}

		private function activatePlugin():void
		{
			if(FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
		}

		public override function update():void
		{
			updateControlHandler();
			animateSprite();
			super.update();
		}

		private function updateControlHandler():void
		{
			FlxControl.player1.update();
		}

		private function animateSprite():void
		{
			if(this.touching == FlxObject.FLOOR)
			{
				if(velocity.x != 0)
				{
					this.play("walk");
				}
				else
				{
					this.play("idle");
				}
			}
			else if(velocity.y < 0)
			{
				this.play("shooting");
			}
		}

		public override function destroy() : void
		{
			FlxControl.clear();
			super.destroy();
		}
	}
}
