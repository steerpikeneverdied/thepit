package com.icoplay.pit.states
{
	import com.icoplay.pit.camera.LevelCam;
	import com.icoplay.pit.level.LevelCreator;
	import com.icoplay.pit.entity.Player;
	import com.icoplay.pit.utils.BaseDefs;
	import com.icoplay.pit.utils.counters.DefaultCounter;
	import com.icoplay.pit.weapon.WeaponLibrary;

	import org.flixel.FlxBasic;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;

	public class PlayState extends BaseState
	{
		private var _playerGroup:FlxGroup;
		private var _levelGroup:FlxGroup;
		private var _collectibleGroup:FlxGroup;
		private var _levelCreator:LevelCreator;
		private var _camera:LevelCam;
		private var _player:Player;
		private var _scoreIndicator:DefaultCounter;
		private var _guiGroup:FlxGroup;
		private var _weaponGroup:FlxGroup;
		private var _fxGroup:FlxGroup;

		public override function create():void
		{
			super.create();

			createGroups();
			createLevelSelection();
			createPlayer();
			createCamera();
			createScore();
		}

		private function createGroups():void
		{
			_levelGroup = new FlxGroup();
			_collectibleGroup = new FlxGroup();
			_weaponGroup = new FlxGroup();
			_playerGroup = new FlxGroup();
			_fxGroup = new FlxGroup();
			_guiGroup = new FlxGroup();

			add(_levelGroup);
			add(_collectibleGroup);
			add(_weaponGroup);
			add(_playerGroup);
			add(_fxGroup);
			add(_guiGroup);
		}

		private function createLevelSelection():void
		{
			_levelCreator = new LevelCreator();
			_levelCreator.createLevelMap(_levelGroup);
		}

		private function createPlayer():void
		{
			_player = new Player(_weaponGroup, _levelCreator, WeaponLibrary.getWeapon(WeaponLibrary.RIFLE));
			_player.x = _levelCreator.levelWidth*1.5;
			_playerGroup.add(_player);
		}

		private function createCamera():void
		{
			_camera = new LevelCam();
			_camera.setBounds(0,0,_levelCreator.levelWidth*3,_levelCreator.levelHeight*3, true);
			_camera.railPoints = _levelCreator.railPoints;
			_camera.transitionCameraLocation(_player.x, _player.y, true);
		}

		private function createScore():void
		{
			_scoreIndicator = new DefaultCounter(_levelCreator.levelWidth*BaseDefs._kMagnification, 0, BaseDefs._kLevelTime, onCounterComplete);
			_guiGroup.add(_scoreIndicator)
		}

		private function onCounterComplete():void
		{
			if(_scoreIndicator)
			{
				_guiGroup.remove(_scoreIndicator);
				_scoreIndicator.destroy();
				_scoreIndicator = null;
			}
		}

		public override function update() : void
		{
			checkCollisionGroups();
			checkCameraLocation();
			super.update();
		}

		private function checkCameraLocation() : void
		{
			_camera.transitionCameraLocation(_player.x, _player.y);
		}

		private function checkCollisionGroups():void
		{
			FlxG.collide(_playerGroup, _levelGroup);
		}

		private function destroyGroup(_group:FlxGroup):void
		{
			for each(var flxObj : FlxObject in _group)
			{
				flxObj.destroy();
				_group.remove(flxObj);
			}

			_group.destroy();
		}

		public override function destroy() : void
		{
			if(_levelGroup)
			{
				remove(_levelGroup);
				destroyGroup(_levelGroup);
				_levelGroup = null;
			}

			if(_collectibleGroup)
			{
				remove(_collectibleGroup);
				destroyGroup(_collectibleGroup);
				_collectibleGroup = null;
			}

			if(_weaponGroup)
			{
				remove(_weaponGroup);
				destroyGroup(_weaponGroup);
				_weaponGroup = null;
			}

			if(_playerGroup)
			{
				remove(_playerGroup);
				destroyGroup(_playerGroup);
				_playerGroup = null;
			}

			if(_fxGroup)
			{
				remove(_fxGroup);
				destroyGroup(_fxGroup);
				_fxGroup = null;
			}

			if(_guiGroup)
			{
				remove(_guiGroup);
				destroyGroup(_guiGroup);
				_guiGroup = null;
			}

			if(_levelCreator)
			{
				_levelCreator.destroy();
				_levelCreator = null;
			}

			if(_player)
			{
				_player = null;
			}

			if(_scoreIndicator)
			{
				_scoreIndicator = null;
			}

			if(_camera)
			{
				_camera.destroy();
				_camera = null;
			}

			super.destroy();
		}
	}
}
