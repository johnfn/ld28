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

class Spike extends FancySprite {
	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/spike.png");

		Reg.spikes.add(this);
		this.immovable = true;
	}

	public override function update() {
		super.update();
	}
}