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

class Bot extends game.Interactable {
	private var conversations:Array<Array<String>>;
	public var isFollowingPlayer:Bool = false;

	public function new(x:Int, y:Int) {
		super(x, y);

		conversations = [];
		this.scaleBouncer = false;
		this.drag.y = 0;
	}

	public function triggerConversation(conversation:Array<String>) {
		var parts:Array<String> = conversation.splice(0, 1)[0].split(" ");
		var delay:Int = Std.parseInt(parts.splice(0, 1)[0]);
		var who:String = parts.splice(0, 1)[0];
		var content = parts.join(" ");
		var target:FlxSprite;

		if (who == "HER") {
			target = this;
		} else {
			target = Reg.player;
		}

		var text:game.FollowText = new game.FollowText(target, content);

		if (who == "HER") {
			text.color = 0xcc7777;
		}

		FlxG.state.add(text);
		haxe.Timer.delay(function() {
			if (conversation.length > 0) {
				triggerConversation(conversation); // was spliced before.
			}
			text.removeText();
		}, 1000);
	}

	public override function update() {
		super.update();

		this.velocity.y += 10;
		Reg.map.collideWithLevel(this);

		// jump up and down constantly
		if (this.isTouching(flixel.FlxObject.FLOOR) && game.Interactable.getInteractor() == this && !isFollowingPlayer) {
			this.velocity.y = -100;
		}
	}

	public override function actionString():String {
		return "Z to be an incredibly generic bot.";
	}
}