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

class GirlBot extends Bot {
	public function new(x:Int, y:Int) {
		super(x, y);

		this.conversations = [ [ "1000 HER Someday my true love will come!"
		                  , "1000 YOU Yawn."
		                  ] 
		                  , 
						  [ "1000 HER Be careful!"
		                  ]
						 ];

		this.loadGraphic("images/cutenpc.png", true, false, 25, 25);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);

		Reg.girls.add(this);

		this.animation.play("idle");

		this.scaleBouncer = false;
		this.drag.y = 0;
	}

	private function respawn() {
		this.x = Reg.player.safeLocation.x;
		this.y = Reg.player.safeLocation.y;

		// TODO smooth scroll camera back

		flixel.util.FlxSpriteUtil.flicker(this, 1.0);

		this.triggerConversation(["1000 HER OWwwwww :(", "1000 YOU Sorry."]);
	}

	public override function update() {
		super.update();

		FlxG.collide(this, Reg.movingplatforms);

		if (FlxG.overlap(this, Reg.spikes)) {
			respawn();
		}

		if (isFollowingPlayer) {
			var sign:Int = Reg.player.x - this.x > 0 ? 1 : -1;

			if (Math.abs(Reg.player.x - this.x) > 30) {
				this.velocity.x = sign * 170;
			} else {
				this.x = Reg.player.x;
			}

			// attempt to jump if they did.
			if (this.y - Reg.player.y > 50 && this.isTouching(flixel.FlxObject.FLOOR)) {
				this.velocity.y = -350;
			}

			var b:BoyBot = cast(Reg.boys.getFirstAlive(), BoyBot);
			Reg.boymusic.volume = Math.min( Math.pow((2000 - FlxMath.distanceBetween(this, b)), 2) / (2000.0 * 2000), 1);
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
		var dialog = new game.DialogBox(["GIRL: Hello!"]);
		FlxG.state.add(dialog);

		isFollowingPlayer = true;
		this.showBouncer = false;

		game.MusicManager.firstTheme();

		Reg.girlmusic.volume = 1;

		dialog.addDoneCB(function() {
			this.triggerConversation(["1000 HER Hello!", "1000 YOU Um... Hi."]);
		});
	}
}