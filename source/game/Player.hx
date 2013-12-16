package game;

import flash.display.Bitmap;
import flash.events.Event;
import flash.net.URLRequest;
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
import flixel.FlxObject;

import flash.display.Loader;

class Player extends FlxSprite {
	/** test */
	public var tweakable:Array<String>;

	public var cannonRebound:Bool = false;
	public var onGround:Bool = false;

	public var menuVisible = false;

	public var girlFound:Bool = false;

	private var debuggingMenu:FlxSprite;
	private var debuggingItems:Array<DebugVariable>;

	public var lastPositions:Array<FlxPoint>;

	public function new(x:Int, y:Int) {
		super(x, y);

		this.lastPositions = [];
		this.tweakable = ["x", "y", "velocity", "drag"];

		this.loadGraphic("images/robot.png", true, true, Reg.TILE_WIDTH, Reg.TILE_HEIGHT);

		this.animation.add("idle", [0, 1, 2, 3, 4, 5], 8, true);
		this.animation.play("idle");

		this.drag.x = 2000;

		buildDebuggingMenu();

		this.width = 20;
		this.health = 20;
	}	

	public function buildDebuggingMenu() {
		var currentHeight:Float = this.y;
		var inspectedObject = this;
		var menu:FlxSprite = new FlxSprite(this.x + this.width + 15, this.y - 5);

		this.debuggingMenu = menu;
		this.debuggingItems = [];

		FlxG.state.add(menu);

		for (fieldName in this.tweakable) {
			// Determine the type of the field.
			var value:Dynamic = Reflect.field(inspectedObject, fieldName);
			var variableType = Type.getClassName(Type.getClass(value));
			if (variableType == null) {
				variableType = Std.string(Type.typeof(value));
			}

			var dbg:DebugVariable;

			if (variableType.indexOf("Int") != -1 || variableType.indexOf("String") != -1) {
				 dbg = new DebugNumber(this.x + this.width + 20, currentHeight, fieldName, inspectedObject);
			} else if (variableType.indexOf("FlxPoint") != -1) {
				 dbg = new DebugPoint(this.x + this.width + 20, currentHeight, fieldName, inspectedObject);
			} else {
				continue;
				dbg = null; // catchall for the compiler's sake
			}

			this.debuggingItems.push(dbg);

			currentHeight += dbg.height + 10;
		}	

		menu.makeGraphic(Std.int(this.width + 70 + 50), Std.int(currentHeight), 0x66444444);

		hideDebuggingMenu();
	}

	public function hideDebuggingMenu() {
		for (item in this.debuggingItems) {
			item.hide();
		}

		this.debuggingMenu.visible = false;
		this.menuVisible = false;
	}

	public function showDebuggingMenu() {
		// reposition to be in the correct place

		for (dbg in debuggingItems) {
			dbg.reorientTo(this, debuggingMenu);
			dbg.show();
		}

		// update menu last, since the other items currently need to refer to its old position. 
		debuggingMenu.x = this.x + this.width + 15;
		debuggingMenu.y = this.y - 5;

		this.updateDebuggingMenu();

		this.debuggingMenu.visible = true;
		this.menuVisible = true;
	}

	public function updateDebuggingMenu() {
		for (item in this.debuggingItems) {
			item.updateValues();
		}
	}

	public function reloadGraphic() {
		var loader:Loader = new Loader();
		var sprite:Player = this;

		function loadComplete(e:Event) {
		    var loadedBitmap:Bitmap = cast(e.currentTarget.loader.content, Bitmap);
		    sprite.loadGraphic(loadedBitmap.bitmapData);
		}

		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		loader.load(new URLRequest("../../../../../../../assets/images/tileset.png"));
	}

	public var safeLocation:FlxPoint = null;
	private function createRespawnPoint() {
		if (safeLocation == null) {
			safeLocation = new FlxPoint(this.x, this.y);
		}
	}

	public function hitByBullet() {
		this.respawn();
	}

	private function explode() {
		var explosion:FlxEmitter = new FlxEmitter(this.x, this.y, 70);
		explosion.makeParticles("images/boomparticle.png", 20, 0, 2);
		explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		explosion.start(true, 2);
		FlxG.state.add(explosion);
	}

	public function respawn() {
		this.x = safeLocation.x;
		this.y = safeLocation.y;

		flixel.util.FlxSpriteUtil.flicker(this, 1.0);

		Reg.youdieSound.play(true);
	}

	private function touchingMap(o1:FlxObject, o2:FlxObject): Void {
		if (this.isTouching(FlxObject.FLOOR)) {
			createRespawnPoint();
		}
	}

	private function updateFollowTrail() {
		if (this.lastPositions.length > 50) {
			this.lastPositions.splice(0, 1);
		}

		this.lastPositions.push(new FlxPoint(this.x, this.y));
	}

	public override function update() {
		super.update();

		updateFollowTrail();

		if (FlxMath.distanceBetween(this, GirlBot.onlyGirl) > 200) {
			Reg.boymusic.volume = 0;
		} else {
			Reg.boymusic.volume = Math.min( (200 - FlxMath.distanceBetween(this, GirlBot.onlyGirl)) / 200 , 1);
		}

		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) {
			this.velocity.x = -200;
			this.facing = FlxObject.LEFT;
		} 
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) {
			this.velocity.x = 200;
			this.facing = FlxObject.RIGHT;
		}

		if (FlxG.keys.justPressed.Z) {
			var i:game.Interactable = game.Interactable.getInteractor();
			if (i != null) {
				// this is to stop the dialog from also eating the z key, meaning no one ever gets to see it. <_>
				FlxG.keyboard.reset();
				i.performAction();
				this.lastPositions = [];
			}
		}

		var that:Player = this;

		FlxG.collide(this, Reg.cannons, function(o1:Player, o2:Cannon) {
			if (!that.isTouching(FlxObject.FLOOR)) return;
			o2.destroy();

			if (this.girlFound) {
				GirlBot.onlyGirl.wow();
			}
			// that.cannonRebound = true; //?
		}); 

		if (this.cannonRebound && this.isTouching(FlxObject.FLOOR)) {
			this.cannonRebound = false;
		}

		FlxG.collide(this, Reg.movingplatforms);

		Reg.map.collideWithLevel(this, touchingMap);

		if (this.isTouching(FlxObject.FLOOR)) {
			if (!this.onGround) {
				this.onGround = true;
			}
		} else {
			this.onGround = false;
		}

		FlxG.collide(this, Reg.crates);

		var done:Bool = false;
		FlxG.overlap(this, Reg.spikes, function(p:FlxSprite, sp:Spike) {
			if (Spike.endgame) {
				if (!done) {
					if (Spike.endgameExplained && !Spike.endgameExplained2) {
						Spike.endgameExplained2 = true;
						new game.DialogBox(["Well, I guess this is pretty cool, too."]);
					}
					if (!Spike.endgameExplained) {
						new game.DialogBox(["You die, cold, alone and unloved.", ":(", "...", "Hey... wait a minute."]);
						Spike.endgameExplained = true;
					}
				}

				sp.blowup();
			} else {
				respawn();

				if (this.girlFound && !game.GirlBot.onlyGirl.followToggledOff) {
					game.GirlBot.onlyGirl.respawn();
				}
			}

			done = true;
		});

		this.velocity.y += 10;
		if ((FlxG.keys.pressed.W  || FlxG.keys.pressed.UP || FlxG.keys.pressed.X)) {
			if (this.isTouching(FlxObject.FLOOR)) {
				if (Spike.endgameExplained) {
					Reg.awesomejumpSound.play(true);
				} else {
					Reg.jumpSound.play(true);
				}
				this.velocity.y = -350;
			}
		} else {
			if (this.velocity.y < 0 && !cannonRebound) {
				this.velocity.y = 0;
			}
		}

#if debug
		if (this.menuVisible) {
			updateDebuggingMenu();
		}

		if (FlxG.mouse.justPressed){
			if (this.overlapsPoint(FlxG.mouse)) {
				showDebuggingMenu();
			} else if (!this.debuggingMenu.overlapsPoint(FlxG.mouse)) {
				hideDebuggingMenu();
			}
		}
#end
		// this.acceleration.y = 100;
	}
}
