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

class Cannon extends FancySprite {
	private var maxCooldown:Int = 120;
	private var cooldown:Int = 120;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/cannonleft.png", true, true, 25, 25);

		this.animation.add("idle", [0, 1], 2);
		this.animation.add("fire", [2, 3, 4, 5, 5], 6, false);

		this.immovable = true;

		this.animation.play("idle");
	}

	public override function update() {
		super.update();
		if (this.animation.curAnim != null) {
			trace(this.animation.curAnim.finished);
		}

		if (this.animation.curAnim != null && this.animation.curAnim.name == "fire" && this.animation.curAnim.curFrame == 4) {
			this.animation.play("idle");
			this.explode();
		} 

		cooldown--;
		if (cooldown < 0) {
			cooldown = this.maxCooldown;
			this.animation.play("fire");
		}
	}

	public function explode() {
		var explosion:FlxEmitter = new FlxEmitter(this.x, this.y, 70);
		explosion.makeParticles("images/boomparticle.png", 8, 0, 2);
		explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		explosion.start(true, .8);
		FlxG.state.add(explosion);
	}
}