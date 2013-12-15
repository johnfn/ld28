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

class MovingPlatform extends FancySprite {
	var vx:Int;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/moving.png");
		this.vx = 100;
		this.immovable = true;

		Reg.movingplatforms.add(this);
	}

	public override function update() {
		super.update();
		this.velocity.x = vx;

		this.immovable = false; //im sure there's a better way to do this lolz
		Reg.map.collideWithLevel(this);
		this.immovable = true;

		if (this.isTouching(flixel.FlxObject.LEFT) || this.isTouching(flixel.FlxObject.RIGHT)) {
			this.vx *= -1;
		}
	}
}