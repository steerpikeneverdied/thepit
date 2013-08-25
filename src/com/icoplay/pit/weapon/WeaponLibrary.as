package com.icoplay.pit.weapon
{
	import com.icoplay.pit.flxproxy.RifleBullet;
	import flash.geom.Point;

	public class WeaponLibrary
	{
		public static const RIFLE : Array = ['Rifle', 180, 180, 100, new Point(0,60), RifleBullet];

		public static function getWeapon(wtype : Array) : Weapon
		{
			return new Weapon(wtype[0],wtype[1],wtype[2],wtype[3],wtype[4],wtype[5]);
		}
	}
}
