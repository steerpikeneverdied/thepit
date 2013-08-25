package com.icoplay.pit.utils.counters
{
	import com.icoplay.pit.flxproxy.CountdownNumerals;

	public class CounterSettings
	{
		public static const DEFAULT : CounterSettings = new CounterSettings(CountdownNumerals, 14, 14, "0123456789", 10, 4);

		private var _font:Class;
		private var _width:int;
		private var _height:int;
		private var _glyphs:String;
		private var _charsPerRow:int;
		private var _magnification:int;

		public function CounterSettings(font:Class, width:int, height:int, glyphs:String, cpr:int, mag:int)
		{
			_font = font;
			_width = width;
			_height = height;
			_glyphs = glyphs;
			_charsPerRow = cpr;
			_magnification = mag;
		}

		public function get font():Class
		{
			return _font;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}

		public function get glyphs():String
		{
			return _glyphs;
		}

		public function get charsPerRow():int
		{
			return _charsPerRow;
		}

		public function get magnification():int
		{
			return _magnification;
		}
	}
}
