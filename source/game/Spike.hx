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

class Spike extends FancySprite {
	public static var endgame:Bool = false;
	public static var endgameExplained:Bool = false;
	public static var endgameExplained2:Bool = false;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/spike.png");

		Reg.spikes.add(this);
		this.immovable = true;
	}

	public function blowup() {
		var explosion:FlxEmitter = new FlxEmitter(this.x, this.y, 70);
		explosion.makeParticles("images/boomparticle.png", 4, 0, 2);
		explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		explosion.start(true, .8);
		FlxG.state.add(explosion);

		this.destroy();

		Reg.spikes.remove(this);
		Reg.state.remove(this);
	}

	public override function update() {
		super.update();
	}
}