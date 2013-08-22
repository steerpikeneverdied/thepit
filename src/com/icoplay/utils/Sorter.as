package com.icoplay.utils
{
	public class Sorter
	{
		public static function HighToLow(item1 : Number, item2 : Number) : int
		{
			if(item1 > item2)
			{
				return 1;
			} else if (item1<item2) {
				return -1;
			} else {
				return 0;
			}
		}
	}
}
