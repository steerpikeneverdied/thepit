package com.icoplay.pit.weapon
{
	import flash.geom.Point;
	public class Weapon
	{
		private var _name : String;
		private var _speed : Number;
		private var _frequency : Number;
		private var _accuracy : Number;
		private var _gravity : Point;
		private var _imgClass : Class;

		public function Weapon(name:String, speed:Number, freq:Number, acc:Number, grav:Point, img:Class)
		{
			_name = name;
			_speed = speed;
			_frequency = freq;
			_accuracy = acc;
			_gravity = grav;
			_imgClass = img;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get frequency():Number
		{
			return _frequency;
		}

		public function set frequency(value:Number):void
		{
			_frequency = value;
		}

		public function get accuracy():Number
		{
			return _accuracy;
		}

		public function set accuracy(value:Number):void
		{
			_accuracy = value;
		}

		public function get gravity():Point
		{
			return _gravity;
		}

		public function set gravity(value:Point):void
		{
			_gravity = value;
		}

		public function get imgClass():Class
		{
			return _imgClass;
		}

		public function set imgClass(value:Class):void
		{
			_imgClass = value;
		}
	}
}
