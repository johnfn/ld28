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

class Star extends FancySprite {
	public function new(x:Float, y:Float) {
		super(Std.int(x), Std.int(y));

		this.loadGraphic("images/star.png", true, false, 25, 25);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 11, 12, 13, 14, 15], 10);

		this.animation.play("idle");
	}

	public override function update() {
		super.update();
	}
}