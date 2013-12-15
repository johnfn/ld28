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

class GirlBot extends game.Interactable {
	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/cutenpc.png", true, false, 25, 25);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);

		Reg.girls.add(this);

		this.animation.play("idle");
	}

	public override function update() {
		super.update();
	}

	public override function actionString():String {
		return "Z to talk";
	}

	public override function performAction():Void {
		new game.DialogBox(["GIRL: Hello!"]);
	}
}