package game;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;

class Clouds extends FlxSpriteGroup {
	private var clouds:Array<{sprite: FlxSprite, speed: Float}>;
	public function new(x:Int, y:Int) {
		super();
		this.clouds = [];
	}

	public override function update() {
		super.update();

		for (cloud in clouds) {
			cloud.sprite.x += cloud.speed;

			if (!cloud.sprite.onScreen(FlxG.camera)) {
				clouds.remove(cloud);
			}
		}

		if (Math.random() * 1000 > 999) {
			newCloud();
		}
	}

	private function newCloud() {
		var yPosition = Math.random() * (FlxG.stage.stageHeight + 300) - 100;
		var xPosition = 0;
		var speed = Math.random() / 3;
		if (Math.random() > .5) {
			xPosition = -100;
		} else {
			xPosition = FlxG.stage.stageHeight + 300;
			speed *= -1;
		}

		var cloud:FlxSprite = new FlxSprite(xPosition, yPosition);
		cloud.loadGraphic("images/clouds.png", true, false, 300, 200);
		cloud.animation.randomFrame(); // choose random cloud
		this.add(cloud);

		this.clouds.push({sprite: cloud, speed: speed});
	}
}