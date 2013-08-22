package com.icoplay.pit.states
{
	import com.icoplay.pit.camera.LevelCam;
	import com.icoplay.pit.level.LevelCreator;
	import com.icoplay.pit.entity.Player;

	import flash.geom.Point;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;

	public class PlayState extends BaseState
	{
		private var _playerGroup:FlxGroup;
		private var _levelGroup:FlxGroup;
		private var _collectibleGroup:FlxGroup;
		private var _levelCreator:LevelCreator;
		private var _camera:LevelCam;
		private var _player:Player;

		public override function create():void
		{
			super.create();

			createGroups();
			createLevelSelection();
			createPlayer();
			createCamera();
		}

		private function createGroups():void
		{
			_playerGroup = new FlxGroup();
			_levelGroup = new FlxGroup();
			_collectibleGroup = new FlxGroup();

			add(_playerGroup);
			add(_levelGroup);
			add(_collectibleGroup);
		}

		private function createLevelSelection():void
		{
			_levelCreator = new LevelCreator();
			_levelCreator.createLevelMap(_levelGroup);
		}

		private function createPlayer():void
		{
			_player = new Player();
			_player.x = _levelCreator.levelWidth*1.5;
			_playerGroup.add(_player);
		}

		private function createCamera():void
		{
			_camera = new LevelCam();
			_camera.setBounds(0,0,_levelCreator.levelWidth*3,_levelCreator.levelHeight*3, true);
			_camera.railPoints = _levelCreator.railPoints;
			checkCameraLocation();
		}

		public override function update() : void
		{
			checkCollisionGroups();
			checkCameraLocation();
			super.update();
		}

		private function checkCameraLocation() : void
		{
			_camera.checkCameraLocation(_player.x, _player.y);
		}

		private function checkCollisionGroups():void
		{
			FlxG.collide(_playerGroup, _levelGroup);
		}

		public override function destroy() : void
		{
			super.destroy();

			if(_levelGroup)
			{
				for each(var level : FlxTilemap in _levelGroup)
				{
					level.destroy();
					level = null;
				}
			}

			if(_levelCreator)
			{
				_levelCreator.destroy();
				_levelCreator = null;
			}
		}
	}
}
