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

class FollowText extends FlxText {
	private var target:FlxSprite = null;
	private var timeLeft:Int = 0;

	public function new(target:FlxSprite, text:String) {
		super(target.x - 50, target.y - target.height - 10, 150, text, 14);

		this.target = target;
	}

	public function removeText() {
		FlxG.state.remove(this);
		this.destroy();
	}

	public override function update() {
		super.update();

		this.x = target.x - this.width / 2;
		this.y = target.y - target.height - 10;

		if (this.x < FlxG.camera.x) this.x = FlxG.camera.x;
		if (this.x > FlxG.camera.x + FlxG.camera.width - this.width) this.x = FlxG.camera.x + FlxG.camera.width - this.width;

		trace(this.x);
	}
}