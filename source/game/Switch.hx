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

class Switch extends FancySprite {
	public var down:Bool = false;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/switch.png", true, false, 25, 25);
		this.animation.add("off", [0]);
		this.animation.add("on",  [1]);

		Reg.switches.add(this);
	}

	public override function update() {
		super.update();

		if (FlxG.overlap(this, Reg.player) || (Reg.player.girlFound && FlxG.overlap(this, GirlBot.onlyGirl))) {
			this.animation.play("on");

			if (!down) {
				for (c in Reg.crates.members) {
					var crate:Crate = cast(c, Crate);

					if (Reg.withinBoundaries(crate.x, crate.y)) {
						crate.switchTo(false);
					}
				}
			}

			down = true;
		} else {
			this.animation.play("off");

			if (down) {
				for (c in Reg.crates.members) {
					var crate:Crate = cast(c, Crate);

					if (Reg.withinBoundaries(crate.x, crate.y)) {
						crate.switchTo(true);
					}
				}
			}

			down = false;
		}
	}
}