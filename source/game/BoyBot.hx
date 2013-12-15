package game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;

class BoyBot extends Bot {
	public function new(x:Int, y:Int) {
		super(x, y);

		this.loadGraphic("images/boyrobot.png", true, false, 25, 25);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);

		Reg.boys.add(this);

		this.animation.play("idle");

		this.scaleBouncer = false;
		this.drag.y = 0;
	}

	public override function update() {
		super.update();

		if (isFollowingPlayer) {
			var sign:Int = Reg.player.x - this.x > 0 ? 1 : -1;

			this.velocity.x = sign * 100;

			// attempt to jump if they did.
			if (this.y - Reg.player.y > 100 && this.isTouching(flixel.FlxObject.FLOOR)) {
				this.velocity.y = -350;
			}
		}
	}

	public override function actionString():String {
		if (isFollowingPlayer) {
			return "Z to be shy (Note: This does nothing.)";
		} else {
			return "Z to talk";
		}
	}

	public override function performAction():Void {
		if (isFollowingPlayer) {
			return;
		}
		var dialog = new game.DialogBox(["BOY: Hello!"]);
		FlxG.state.add(dialog);

		this.showBouncer = false;

		dialog.addDoneCB(function() {
			this.triggerConversation(["1000 HER Hello!", "1000 YOU test"]);
		});
	}
}