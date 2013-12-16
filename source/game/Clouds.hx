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

		restart();
	}

	public function restart() {
		for (cloud in clouds) {
			this.remove(cloud.sprite);
			clouds.remove(cloud);
		}

		for (x in 0...6) {
			newCloud(true);
		}
	}

	public override function update() {
		super.update();

		for (cloud in clouds) {
			cloud.sprite.x += cloud.speed;

			if (cloud.sprite.x + cloud.sprite.width < FlxG.camera.bounds.x && cloud.speed < 0) {
				cloud.sprite.x = FlxG.camera.bounds.x + FlxG.camera.bounds.width + 50;
			}

			if (cloud.sprite.x > FlxG.camera.bounds.x + FlxG.camera.bounds.width && cloud.speed > 0) {
				cloud.sprite.x = FlxG.camera.bounds.x - 50;
			}
		}
	}

	private function newCloud(anywhere:Bool = false) {
		var yPosition = Math.random() * (FlxG.stage.stageHeight + 300) - 100;
		var xPosition = 0;

		var speed = Math.random() + 1;
		if (Math.random() > .5) {
			xPosition = -100;
		} else {
			xPosition = FlxG.stage.stageHeight + 300;
			speed *= -1;
		}

		if (anywhere) {
			xPosition = Std.int(Math.random() * FlxG.width);
		}

		var cloud:FlxSprite = new FlxSprite(xPosition, yPosition);
		cloud.loadGraphic("images/clouds.png", true, false, 300, 200);
		cloud.animation.frameIndex = 0;
		this.add(cloud);

		cloud.alpha = Math.random() / 2 + .1;
		cloud.scale.x = Math.random() + 1;
		cloud.scale.y = Math.random() + 1;

		this.clouds.push({sprite: cloud, speed: speed});
	}
}