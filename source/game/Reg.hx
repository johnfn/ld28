package game;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxSave;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg {
	static public function withinBoundaries(x:Float, y:Float):Bool {
        if (x > (Reg.mapX + 1) * Reg.mapWidth) {
        	return false;
        }

        if (x < Reg.mapX * Reg.mapWidth) {
        	return false;
        }

        if (y > (Reg.mapY + 1) * Reg.mapHeight) {
        	return false;
        }

        if (y < Reg.mapY * Reg.mapHeight) {
        	return false;
        }

        return true;
	}

	static public var NORMAL_MODE:Int = 0;
	static public var DIALOG_MODE:Int = 1;

	static public var mode:Int = NORMAL_MODE;

	static public var FPS:Int = 60;

	static public var map:TiledLevel;

	static public var inactives:FlxGroup = new FlxGroup();
	static public var interactors:FlxGroup = new FlxGroup();

	static public var spikes:FlxGroup = new FlxGroup();
	static public var movingplatforms:FlxGroup = new FlxGroup();
	static public var girls:FlxGroup = new FlxGroup();
	static public var boys:FlxGroup = new FlxGroup();
	static public var bullets:FlxGroup = new FlxGroup();
	static public var cannons:FlxGroup = new FlxGroup();

	/** Current game state. */
	static public var state:FlxState; 

	static public var player:Player;
	static public var mapX:Int = 0;	
	static public var mapY:Int = 0;	

	static public var mapWidth:Int = 25 * 30;
	static public var mapHeight:Int = 25 * 30;

	static public var TILE_WIDTH:Int = 25;
	static public var TILE_HEIGHT:Int = 25;

	static public var girlmusic:FlxSound = new FlxSound();
	static public var boymusic:FlxSound = new FlxSound();
}