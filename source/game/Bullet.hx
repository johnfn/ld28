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

class Bullet extends FancySprite {
	var vx:Int = 0;
	public static var BULLET_SPEED:Int = 300;

	public function new(x:Int, y:Int, vx:Int) {
		super(x, y);

		this.loadGraphic("images/cannonball.png");

		this.vx = vx;
	}

	public function removeBullet() {
		Reg.bullets.remove(this);
		this.destroy();
	}

	public function explode() {
		var explosion:FlxEmitter = new FlxEmitter(this.x, this.y, 70);
		explosion.makeParticles("images/boomparticle.png", 4, 0, 2);
		explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		explosion.start(true, .8);
		FlxG.state.add(explosion);
	}

	public override function update() {
		super.update();

		this.velocity.x = BULLET_SPEED * (vx > 0 ? 1 : -1);

		if (!Reg.withinBoundaries(this.x, this.y)) {
			this.removeBullet();
		}

		if (Reg.map.collideWithLevel(this)) {
			this.explode();
			this.removeBullet();
		}

		if (FlxG.overlap(this, Reg.player)) {
			Reg.player.hitByBullet();
			this.explode();
			this.removeBullet();
		}
	}
}