package com.icoplay.pit.states
{
	import com.icoplay.pit.camera.LevelCam;
	import com.icoplay.pit.level.LevelCreator;
	import com.icoplay.pit.entity.Player;
	import com.icoplay.pit.utils.BaseDefs;
	import com.icoplay.pit.utils.BaseDefs;
	import com.icoplay.pit.utils.counters.DefaultCounter;

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
			_playerGroup = new FlxGroup();
			_levelGroup = new FlxGroup();
			_collectibleGroup = new FlxGroup();
			_guiGroup = new FlxGroup();

			add(_playerGroup);
			add(_levelGroup);
			add(_collectibleGroup);
			add(_guiGroup);
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
			var obj : FlxObject;

			for each(obj in _group)
			{
				obj.destroy();
				obj = null;
			}
		}

		public override function destroy() : void
		{
			super.destroy();

			if(_levelGroup)
			{
				destroyGroup(_levelGroup);
				_levelGroup = null;
			}

			if(_playerGroup)
			{
				destroyGroup(_playerGroup);
				_playerGroup = null;
			}

			if(_collectibleGroup)
			{
				destroyGroup(_collectibleGroup);
				_collectibleGroup = null;
			}

			if(_guiGroup)
			{
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
				_player.destroy();
				_player = null;
			}

			if(_scoreIndicator)
			{
				_scoreIndicator.destroy();
				_scoreIndicator = null;
			}

			if(_camera)
			{
				_camera.destroy();
				_camera = null;
			}
		}
	}
}
