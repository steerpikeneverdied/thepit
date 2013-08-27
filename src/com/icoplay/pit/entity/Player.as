package com.icoplay.pit.entity
{
	import com.icoplay.pit.asset.RefLib;
	import com.icoplay.pit.level.LevelCreator;
	import com.icoplay.pit.utils.BaseDefs;
	import com.icoplay.pit.weapon.Weapon;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxControl;
	import org.flixel.plugin.photonstorm.FlxControlHandler;
	import org.flixel.plugin.photonstorm.FlxWeapon;

	public class Player extends FlxSprite
	{
		private static const _kDefaultHeightOffset:int = 2;
		private var _playerWeapon:FlxWeapon;
		private var _weaponGroup:FlxGroup;
		private var _currentWeapon:Weapon;
		private var _levelCreator:LevelCreator;

		public function Player(weaponGroup : FlxGroup, levelCreator: LevelCreator, weapon : Weapon, offsetX : int = -1)
		{
			super();

			this._weaponGroup = weaponGroup;
			this._levelCreator = levelCreator;
			loadSpriteSheet();
			changeOffset(offsetX);
			setControls();
			setWeapon(weapon);
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
			loadGraphic(RefLib.PlayerSpriteSheet,true,true,22,23);
			addAnimation("walk", [5, 6, 7, 8, 9], 15, true);
			addAnimation("shoot", [0, 1, 2, 3, 4], 30, true);
			addAnimation("jump", [0, 1, 2, 3, 4], 30, true);
			addAnimation("idle", [10, 11, 12, 13, 14], 10, true);
		}

		private function setControls() : void
		{
			activatePlugin();
			setPlayerControls();
		}

		private function setPlayerControls():void
		{
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			FlxControl.player1.setWASDControl(true, false, true, true);
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 200, FlxObject.FLOOR, 250, 200);

			FlxControl.player1.setMovementSpeed(400, 0, 100, 200, 700, 0);

			FlxControl.player1.setGravity(0, BaseDefs._kGravity);
		}

		private function setWeapon(weap : Weapon):void
		{
			_currentWeapon = weap;

			_playerWeapon = new FlxWeapon(weap.name, this, "x", "y");

			_playerWeapon.makeImageBullet(50,weap.imgClass, 0, height/2);
			_playerWeapon.setBulletSpeed(weap.speed);
			_playerWeapon.setBulletRandomFactor(weap.accuracy);
			_playerWeapon.setBulletGravity(weap.gravity.x, weap.gravity.y);
			_playerWeapon.setFireRate(weap.frequency);

			//	This allows bullets to live within the bounds rect (stops them visually falling lower than the road)
			_playerWeapon.setBulletBounds(new FlxRect(0, 0, 1000, 1000));

			_weaponGroup.add(_playerWeapon.group);
		}

		private function activatePlugin():void
		{
			if(FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
		}

		public function getWeaponGroup() : FlxGroup
		{
			return _playerWeapon.group;
		}

		public override function update():void
		{
			updateControlHandler();
			animateSprite();
			if (FlxG.mouse.pressed())
			{
				_playerWeapon.fireAtMouse();
			}
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
				this.play("jump");
			}
		}

		public override function destroy() : void
		{
			if(_weaponGroup)
			{
				_weaponGroup.remove(_playerWeapon.group);
			}

			if(_playerWeapon)
			{
				_playerWeapon.group = null;
				_playerWeapon.bounds = null;
				_playerWeapon = null;
			}

			if(_levelCreator)
			{
				_levelCreator = null;
			}

			FlxControl.clear();
			super.destroy();
		}
	}
}
