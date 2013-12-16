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
	public static var onlyGirl:GirlBot;

	public var followToggledOff:Bool = false;

	var currentRandomChoice:String = "be shy";
	public function new(x:Int, y:Int) {
		super(x, y);

		this.conversations = [ [ "1000 HER You are so good at jumping on cannons!"
			                  , "1000 YOU Um... thanks."
			                  ] 
			                  , 
							  [ "1000 HER Be careful!"
			                  ]
			                  , 
							  [ "4000 HER I've never seen someone jump on a cannon before."
			                  ]
			                  , 
							  [ "1000 HER I'm hungry."
							  , "2000 YOU How can you be hungry? You're a robot."
							  , "1000 HER *cough*"
			                  ]
			                  , 
							  [ "1000 YOU So... nice weather we're having eh?"
							  , "3000 HER Yes, a beautiful day in Robot World."
			                  ]
			                  , 
							  [ "1000 YOU You have very nice..."
							  , "1000 YOU Um..."
							  , "1000 YOU Robot eyes."
							  , "3000 HER *blush*"
			                  ]
			                  , 
							  [ "1000 YOU What's your favorite novel?"
							  , "4000 HER Oh, definitely Infinite Jest by David Foster Wallace."
							  , "3000 YOU Oh... I haven't read that one."
			                  ]
							 ];

		this.loadGraphic("images/cutenpc.png", true, false, 25, 25);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8);

		Reg.girls.add(this);

		this.animation.play("idle");

		this.scaleBouncer = false;
		this.drag.y = 0;
		GirlBot.onlyGirl = this;
	}

	public function triggerRandomConversation() {
		this.triggerConversation(this.conversations[Std.int(Math.random() * this.conversations.length)]);
	}

	public function respawn() {
		this.x = Reg.player.safeLocation.x;
		this.y = Reg.player.safeLocation.y;

		// TODO smooth scroll camera back

		flixel.util.FlxSpriteUtil.flicker(this, 1.0);

		var thingsToSay:Array<Array<String>> = [["1000 HER OWwwwww :(", "1000 YOU Sorry."]
			                                   ,["1000 HER That hurt :( :(", "2000 YOU Why did you do it then?"]
			                                   ,["1000 HER :( :(", "1000 YOU :?"]
			                                   ,["2000 HER Thank goodness I can respawn!", "2000 YOU It is indeed good to be a robot."]
			                                   ,["2000 HER Can you stop making me die?", "2000 YOU ..."]
			                                   ];

		this.triggerConversation(thingsToSay[Std.int(Math.random() * thingsToSay.length)]);
	}

	public override function update() {
		super.update();

		FlxG.collide(this, Reg.movingplatforms);

		if (FlxG.keys.justPressed.C) {
			followToggledOff = !followToggledOff;

			if (followToggledOff && Math.random() > .7) {
				var things:Array<Array<String>> = [["2000 HER Come back soon!"], ["2000 HER See you in a bit!"], ["2000 HER I'll just wait here for now."], ["2000 HER Bye!"]];
				this.triggerConversation(things[Std.int(Math.random() * things.length)]);
			}

			if (!followToggledOff && Math.random() > .7) {
				var things:Array<Array<String>> = [["2000 HER Coming!"], ["2000 HER Yay!"]];
				this.triggerConversation(things[Std.int(Math.random() * things.length)]);
			}
		}

		if (followToggledOff) {
			this.alpha = 0.5;
		} else {
			this.alpha = 1.0;
		}

		if (isFollowingPlayer && !followToggledOff) {
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

			Reg.map.collideWithLevel(this);

			if (Math.random() > .9996) {
				this.triggerRandomConversation();
			}
		}

		if (FlxG.overlap(this, Reg.spikes)) {
			respawn();
			Reg.player.respawn();	
		}

	}

	public override function actionString():String {
		if (isFollowingPlayer) {
			var randomThings:Array<String> = ["be shy", "be bashful", "stare awkwardly at your feet", "talk about the weather", "mumble something"];
			if (Math.random() > .999) {
				currentRandomChoice = randomThings[Std.int(Math.random() * randomThings.length)];
			}
			return "Z to " + currentRandomChoice + " (Note: This does nothing.)";
		} else {
			return "Z to talk";
		}
	}

	public override function performAction():Void {
		if (isFollowingPlayer) {
			return;
		}
		var dialog = new game.DialogBox(["This is a girl robot.", "You can tell because she has a bow.", "All girls have bows.", "GIRL: Hello!", "YOU: Umm... hi.", "You are not quite sure what to say, as you have never seen a girl robot before.", "And YOU ONLY GET ONE chance at true love, so you better not mess this up!", "YOU: Would you like to see me jump on a cannon?", "HER: ...Um, ok."]);
		FlxG.state.add(dialog);

		isFollowingPlayer = true;
		this.showBouncer = false;
		Reg.player.girlFound = true;

		dialog.addDoneCB(function() {
			this.triggerConversation(["1000 HER Yay!"]);
		});
	}
}