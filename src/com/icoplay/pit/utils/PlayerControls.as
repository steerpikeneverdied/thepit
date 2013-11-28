package com.icoplay.pit.utils
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import flash.utils.getTimer;

	public class PlayerControls
	{
		//	Used by the FlxControl plugin
		public var enabled:Boolean = false;

		private var entity:FlxSprite = null;

		private var bounds:Rectangle;

		private var up:Boolean;
		private var down:Boolean;
		private var left:Boolean;
		private var right:Boolean;
		private var fire:Boolean;
		private var jump:Boolean;
		private var xFacing:Boolean;
		private var yFacing:Boolean;

		private var upMoveSpeed:int;
		private var downMoveSpeed:int;
		private var leftMoveSpeed:int;
		private var rightMoveSpeed:int;

		private var gravityX:int = 0;
		private var gravityY:int = 0;

		private var fireRate:int; 			// The ms delay between firing when the key is held down
		private var nextFireTime:int; 		// The internal time when they can next fire
		private var lastFiredTime:int; 		// The internal time of when when they last fired
		private var fireKeyMode:uint;		// The fire key mode
		private var fireCallback:Function;	// A function to call every time they fire

		private var jumpHeight:int; 		// The pixel height amount they jump (drag and gravity also both influence this)
		private var jumpRate:int; 			// The ms delay between jumping when the key is held down
		private var nextJumpTime:int; 		// The internal time when they can next jump
		private var lastJumpTime:int; 		// The internal time of when when they last jumped
		private var jumpFromFallTime:int; 	// A short window of opportunity for them to jump having just fallen off the edge of a surface
		private var extraSurfaceTime:int; 	// Internal time of when they last collided with a valid jumpSurface
		private var jumpSurface:uint; 		// The surfaces from FlxObject they can jump from (i.e. FlxObject.FLOOR)
		private var jumpCallback:Function;	// A function to call every time they jump

		private var movement:int;
		private var stopping:int;
		private var capVelocity:Boolean;

		private var upKey:String;
		private var downKey:String;
		private var leftKey:String;
		private var rightKey:String;
		private var fireKey:String;
		private var jumpKey:String;

		//	Sounds
		private var jumpSound:FlxSound = null;
		private var fireSound:FlxSound = null;
		private var walkSound:FlxSound = null;

		//	Helpers
		public var isPressedUp:Boolean = false;
		public var isPressedDown:Boolean = false;
		public var isPressedLeft:Boolean = false;
		public var isPressedRight:Boolean = false;

		/**
		 * Sets the FlxSprite to be controlled by this class, and defines the initial movement and stopping types.<br>
		 * After creating an instance of this class you should call setMovementSpeed, and one of the enableXControl functions if you need more than basic cursors.
		 *
		 * @param	source			The FlxSprite you want this class to control. It can only control one FlxSprite at once.
		 * @param	movementType	Set to either MOVEMENT_INSTANT or MOVEMENT_ACCELERATES
		 * @param	stoppingType	Set to STOPPING_INSTANT, STOPPING_DECELERATES or STOPPING_NEVER
		 * @param	updateFacing	If true it sets the FlxSprite.facing value to the direction pressed (default false)
		 *
		 * @see		setMovementSpeed
		 */
		public function FlxControlHandler(source:FlxSprite, movementType:int, stoppingType:int, updateFacing:Boolean = false)
		{
			entity = source;

			movement = movementType;
			stopping = stoppingType;

			xFacing = updateFacing;
			yFacing = updateFacing;

			up = false;
			down = false;
			left = false;
			right = false;

			enabled = true;
		}

		/**
		 * Set the speed at which the sprite will move when a direction key is pressed.<br>
		 * All values are given in pixels per second. So an xSpeed of 100 would move the sprite 100 pixels in 1 second (1000ms)<br>
		 * Due to the nature of the internal Flash timer this amount is not 100% accurate and will vary above/below the desired distance by a few pixels.<br>
		 *
		 * If you need different speed values for left/right or up/down then use setAdvancedMovementSpeed
		 *
		 * @param	xSpeed			The speed in pixels per second in which the sprite will move/accelerate horizontally
		 * @param	ySpeed			The speed in pixels per second in which the sprite will move/accelerate vertically
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 * @param	xDeceleration	A deceleration speed in pixels per second to apply to the sprites horizontal movement (default 0)
		 * @param	yDeceleration	A deceleration speed in pixels per second to apply to the sprites vertical movement (default 0)
		 */
		public function setMovementSpeed(xSpeed:uint, ySpeed:uint, xSpeedMax:uint, ySpeedMax:uint, xDeceleration:uint = 0, yDeceleration:uint = 0):void
		{
			leftMoveSpeed = -xSpeed;
			rightMoveSpeed = xSpeed;
			upMoveSpeed = -ySpeed;
			downMoveSpeed = ySpeed;

			setMaximumSpeed(xSpeedMax, ySpeedMax);
			setDeceleration(xDeceleration, yDeceleration);
		}

		/**
		 * Sets the maximum speed (in pixels per second) that the FlxSprite can move. You can set the horizontal and vertical speeds independantly.<br>
		 * When the FlxSprite is accelerating (movement type MOVEMENT_ACCELERATES) its speed won't increase above this value.<br>
		 * However Flixel allows the velocity of an FlxSprite to be set to anything. So if you'd like to check the value and restrain it, then enable "limitVelocity".
		 *
		 * @param	xSpeed			The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeed			The maximum speed in pixels per second in which the sprite can move vertically
		 * @param	limitVelocity	If true the velocity of the FlxSprite will be checked and kept within the limit. If false it can be set to anything.
		 */
		public function setMaximumSpeed(xSpeed:uint, ySpeed:uint, limitVelocity:Boolean = true):void
		{
			entity.maxVelocity.x = xSpeed;
			entity.maxVelocity.y = ySpeed;

			capVelocity = limitVelocity;
		}

		/**
		 * Deceleration is a speed (in pixels per second) that is applied to the sprite if stopping type is "DECELERATES" and if no acceleration is taking place.<br>
		 * The velocity of the sprite will be reduced until it reaches zero, and can be configured separately per axis.
		 *
		 * @param	xSpeed		The speed in pixels per second at which the sprite will have its horizontal speed decreased
		 * @param	ySpeed		The speed in pixels per second at which the sprite will have its vertical speed decreased
		 */
		public function setDeceleration(xSpeed:uint, ySpeed:uint):void
		{
			entity.drag.x = xSpeed;
			entity.drag.y = ySpeed;
		}

		/**
		 * Set sound effects for the movement events jumping, firing, walking and thrust.
		 *
		 * @param	jump	The FlxSound to play when the user jumps
		 * @param	fire	The FlxSound to play when the user fires
		 * @param	walk	The FlxSound to play when the user walks
		 * @param	thrust	The FlxSound to play when the user thrusts
		 */
		public function setSounds(jump:FlxSound = null, fire:FlxSound = null, walk:FlxSound = null, thrust:FlxSound = null):void
		{
			if (jump)
			{
				jumpSound = jump;
			}

			if (fire)
			{
				fireSound = fire;
			}

			if (walk)
			{
				walkSound = walk;
			}
		}

		/**
		 * Enable a fire button
		 *
		 * @param	key				The key to use as the fire button (String from org.flixel.system.input.Keyboard, i.e. "SPACE", "CONTROL")
		 * @param	keymode			The FlxControlHandler KEYMODE value (KEYMODE_PRESSED, KEYMODE_JUST_DOWN, KEYMODE_RELEASED)
		 * @param	repeatDelay		Time delay in ms between which the fire action can repeat (0 means instant, 250 would allow it to fire approx. 4 times per second)
		 * @param	callback		A user defined function to call when it fires
		 */
		public function setFireButton(key:String, keymode:uint, repeatDelay:uint, callback:Function):void
		{
			fireKey = key;
			fireKeyMode = keymode;
			fireRate = repeatDelay;
			fireCallback = callback;

			fire = true;
		}

		/**
		 * Enable a jump button
		 *
		 * @param	key				The key to use as the jump button (String from org.flixel.system.input.Keyboard, i.e. "SPACE", "CONTROL")
		 * @param	height			The height in pixels/sec that the Sprite will attempt to jump (gravity and acceleration can influence this actual height obtained)
		 * @param	surface			A bitwise combination of all valid surfaces the Sprite can jump off (from FlxObject, such as FlxObject.FLOOR)
		 * @param	repeatDelay		Time delay in ms between which the jumping can repeat (250 would be 4 times per second)
		 * @param	jumpFromFall	A time in ms that allows the Sprite to still jump even if it's just fallen off a platform, if still within ths time limit
		 * @param	callback		A user defined function to call when the Sprite jumps
		 */
		public function setJumpButton(key:String, height:int, surface:int, repeatDelay:uint = 250, jumpFromFall:int = 0, callback:Function = null):void
		{
			jumpKey = key;
			jumpHeight = height;
			jumpSurface = surface;
			jumpRate = repeatDelay;
			jumpFromFallTime = jumpFromFall;
			jumpCallback = callback;

			jump = true;
		}

		/**
		 * Limits the sprite to only be allowed within this rectangle. If its x/y coordinates go outside it will be repositioned back inside.<br>
		 * Coordinates should be given in GAME WORLD pixel values (not screen value, although often they are the two same things)
		 *
		 * @param	x		The x coordinate of the top left corner of the area (in game world pixels)
		 * @param	y		The y coordinate of the top left corner of the area (in game world pixels)
		 * @param	width	The width of the area (in pixels)
		 * @param	height	The height of the area (in pixels)
		 */
		public function setBounds(x:int, y:int, width:uint, height:uint):void
		{
			bounds = new Rectangle(x, y, width, height);
		}

		/**
		 * Clears any previously set sprite bounds
		 */
		public function removeBounds():void
		{
			bounds = null;
		}

		private function moveUp():Boolean
		{
			var move:Boolean = false;

			if (FlxG.keys.pressed(upKey))
			{
				move = true;
				isPressedUp = true;

				if(yFacing)
				{
					entity.facing = FlxObject.UP;
				}

				entity.acceleration.y = upMoveSpeed;

				if(bounds && entity.y < bounds.top)
				{
					entity.y = bounds.top;
				}
			}

			return move;
		}

		private function moveDown():Boolean
		{
			var move:Boolean = false;

			if (FlxG.keys.pressed(downKey))
			{
				move = true;
				isPressedDown = true;

				if (yFacing)
				{
					entity.facing = FlxObject.DOWN;
				}

				entity.acceleration.y = downMoveSpeed;

				if (bounds && entity.y > bounds.bottom)
				{
					entity.y = bounds.bottom;
				}

			}

			return move;
		}

		private function moveLeft():Boolean
		{
			var move:Boolean = false;

			if (FlxG.keys.pressed(leftKey))
			{
				move = true;
				isPressedLeft = true;

				if (xFacing)
				{
					entity.facing = FlxObject.LEFT;
				}

				entity.acceleration.x = leftMoveSpeed;

				if (bounds && entity.x < bounds.x)
				{
					entity.x = bounds.x;
				}
			}

			return move;
		}

		private function moveRight():Boolean
		{
			var move:Boolean = false;

			if (FlxG.keys.pressed(rightKey))
			{
				move = true;
				isPressedRight = true;

				if (xFacing)
				{
					entity.facing = FlxObject.RIGHT;
				}

				entity.acceleration.x = rightMoveSpeed;

				if (bounds && entity.x > bounds.right)
				{
					entity.x = bounds.right;
				}
			}

			return move;
		}

		private function runFire():Boolean
		{
			var fired:Boolean = false;

			//	0 = Pressed
			//	1 = Just Released
			if ((fireKeyMode == 0 && FlxG.keys.pressed(fireKey)) || (fireKeyMode == 1 && FlxG.keys.justReleased(fireKey)))
			{
				if (fireRate > 0)
				{
					if (getTimer() > nextFireTime)
					{
						lastFiredTime = getTimer();

						fireCallback.call();

						fired = true;

						nextFireTime = lastFiredTime + fireRate;
					}
				}
				else
				{
					lastFiredTime = getTimer();

					fireCallback.call();

					fired = true;
				}
			}

			if (fired && fireSound)
			{
				fireSound.play(true);
			}

			return fired;
		}

		private function runJump():Boolean
		{
			var jumped:Boolean = false;

			//	This should be called regardless if they've pressed jump or not
			if (entity.isTouching(jumpSurface))
			{
				extraSurfaceTime = getTimer() + jumpFromFallTime;
			}

			if (FlxG.keys.pressed(jumpKey))
			{
				//	Sprite not touching a valid jump surface
				if (entity.isTouching(jumpSurface) == false)
				{
					//	They've run out of time to jump
					if (getTimer() > extraSurfaceTime)
					{
						return jumped;
					}
					else
					{
						//	Still within the fall-jump window of time, but have jumped recently
						if (lastJumpTime > (extraSurfaceTime - jumpFromFallTime))
						{
							return jumped;
						}
					}

					//	If there is a jump repeat rate set and we're still less than it then return
					if (getTimer() < nextJumpTime)
					{
						return jumped;
					}
				}
				else
				{
					//	If there is a jump repeat rate set and we're still less than it then return
					if (getTimer() < nextJumpTime)
					{
						return jumped;
					}
				}

				if (gravityY > 0)
				{
					//	Gravity is pulling them down to earth, so they are jumping up (negative)
					entity.velocity.y = -jumpHeight;
				}
				else
				{
					//	Gravity is pulling them up, so they are jumping down (positive)
					entity.velocity.y = jumpHeight;
				}

				if (jumpCallback is Function)
				{
					jumpCallback.call();
				}

				lastJumpTime = getTimer();
				nextJumpTime = lastJumpTime + jumpRate;

				jumped = true;
			}

			if (jumped && jumpSound)
			{
				jumpSound.play(true);
			}

			return jumped;
		}

		/**
		 * Called by the FlxControl plugin
		 */
		public function update():void
		{
			if (entity == null)
			{
				return;
			}

			//	Reset the helper booleans
			isPressedUp = false;
			isPressedDown = false;
			isPressedLeft = false;
			isPressedRight = false;

			//	By default these are zero anyway, so it's safe to set like this
			entity.acceleration.x = gravityX;
			entity.acceleration.y = gravityY;

			if (fire)
			{
				runFire();
			}

			if (jump)
			{
				runJump();
			}

			if (capVelocity)
			{
				if (entity.velocity.x > entity.maxVelocity.x)
				{
					entity.velocity.x = entity.maxVelocity.x;
				}

				if (entity.velocity.y > entity.maxVelocity.y)
				{
					entity.velocity.y = entity.maxVelocity.y;
				}
			}

			if (walkSound)
			{
				if (entity.acceleration.x != 0)
				{
					walkSound.play(false);
				}
				else
				{
					walkSound.stop();
				}
			}
		}
	}
}