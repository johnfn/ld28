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

class Bullet extends FancySprite {
	var vx:Int = 0;
	public static var BULLET_SPEED:Int = 300;

	public function new(x:Int, y:Int, vx:Int) {
		super(x, y);

		this.loadGraphic("images/cannonball.png");

		this.vx = vx;
	}

	public override function update() {
		super.update();

		this.velocity.x = BULLET_SPEED * (vx > 0 ? 1 : -1);

		if (!this.onScreen(FlxG.camera)) {
			this.destroy();
		}
	}
}