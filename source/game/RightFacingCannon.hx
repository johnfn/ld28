package game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;

class RightFacingCannon extends Cannon {
	public function new(x:Int, y:Int) {
		super(x, y);

		this.bulletDX = 1;
		this.facing = flixel.FlxObject.RIGHT;
	}
}