package game;

import flixel.effects.particles.FlxEmitter;
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

class Crate extends FancySprite {
	public var down:Bool = false;

	public var presses:Int = 0;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/crate.png", true, false, 25, 25);
		this.animation.add("off", [1]);
		this.animation.add("on",  [0]);

		this.immovable = true;

		Reg.crates.add(this);
	}

	public function switchTo(s:Bool) {
		if (s == true) {
			presses--;

			if (presses == 0) {
				this.animation.play("on");
			}
		} else {
			presses++;

			if (presses > 0) {
				this.animation.play("off");
			}
		}

		this.solid = presses == 0;
	}

	public override function update() {
		super.update();
	}
}