package game;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import flixel.FlxCamera;


// ctrl-i generate import statement.

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	public var level:TiledLevel;

	public var scenery:FlxEmitter;

    public function checkUpdateScreen(forceUpdate:Bool = false) {
        var change:Bool = false;
        var canLeave:Bool = !Reg.player.girlFound || Math.abs(Reg.player.x - cast(Reg.girls.getFirstAlive(), FlxSprite).x) < 100;
        var triedToLeave:Bool = false;

        if (Reg.player.x > (Reg.mapX + 1) * Reg.mapWidth) {
    		if (!canLeave) {
    			Reg.player.x = (Reg.mapX + 1) * Reg.mapWidth - Reg.player.width;
    			triedToLeave = true;
    		} else {
	            Reg.mapX++;
	            change = true;
	        }
        }

        if (Reg.player.x < Reg.mapX * Reg.mapWidth) {
    		if (!canLeave) {
    			Reg.player.x = Reg.mapX * Reg.mapWidth;
    			triedToLeave = true;
    		} else {
                Reg.mapX--;
                change = true;
            }
        }

        if (Reg.player.y > (Reg.mapY + 1) * Reg.mapHeight) {
                Reg.mapY++;
                change = true;
        }

        if (Reg.player.y < Reg.mapY * Reg.mapHeight) {
                Reg.mapY--;
                change = true;
        }

        if (triedToLeave && !canLeave) {
	        add(new DialogBox(["You can't leave without the girl robot!"]));
	    }

        if (change || forceUpdate) {
        	triggerDialog();

            FlxG.camera.setBounds(Reg.mapX * Reg.mapWidth, Reg.mapY * Reg.mapHeight, Reg.mapWidth, Reg.mapHeight, true);
            scenery.x = FlxG.camera.bounds.x;
            scenery.y = FlxG.camera.bounds.y;
            Reg.player.safeLocation = null;
        }
    }

    var kv:Map<String, Array<String>>;
    private function initializeDialog() {
    	kv = [ "0,0" => ["Although you are strong enough to destroy cannons simply by jumping on top of them, you have never obtained what you truly desire from life:", "TRUE LOVE.", "But somewhere out there is the girl for you!", "Well, the girl robot.", "You know, because you're a robot and all."]
	    	 , "1,0" => ["Unfortunately, you are not strong enough to destroy spikes simply by jumping on them.", "You're still working on that one."]
    	     , "2,0" => ["It would be pretty cool though.", "Destroying spikes.", "...", "Also finding true love.", "You've certainly got your priorities straight."]
    	     , "3,0" => ["But finding true love would require a LEAP of faith...", "...", "a LEAP...", "...", "Hint: You may have to take a leap here."]
    	     , "0,1" => ["You notice that if the girl gets hurt, somehow you do too.", "Is this what true love feels like?"]
    	     , "1,1" => ["You calculate (because you're a robot) that if you stomp on 5 cannons, you will win the heart of the girl.", "Like I said, you haven't really done this before."]
    	     , "2,1" => ["Sometimes you may have to those you love behind behind.", "Toggle whether she follows you with C."]
    	     , "4,2" => ["You win :)"]
    	     ];
    }

    private function triggerDialog() {
    	var key:String = "" + Reg.mapX + "," + Reg.mapY;
    	if (key == "4,2") {
    		if (Reg.player.girlFound) {
    			for (s in Reg.spikes.members) {
    				s.destroy();
    			}
    		} else {
    			Spike.endgame = true;
    			kv.remove(key);
    		}
    	}
    	
    	if (kv.exists(key)) {
    		var dialog = kv.get(key);
    		add (new game.DialogBox(dialog));
    		kv.remove(key);
    	}

    	if (Reg.mapY == 2) {
			finalScreenSetup();
    	}
    }

	public function finalScreenSetup() {
		Reg.background.loadGraphic("images/starringskyunderlay.png");

		add(new game.Heart(Reg.player));
		add(new game.Heart(game.GirlBot.onlyGirl));
	}

	override public function create():Void {
		FlxG.log.redirectTraces = false;
#if debug
		FlxG.autoPause = false;
#end
		
		initializeDialog();
		
		Reg.background = new FlxSprite(0, 0);
		Reg.background.scrollFactor.x = 0;
		Reg.background.scrollFactor.y = 0;

		Reg.background.loadGraphic("images/bg.png");
		Reg.background.scale.x = 2;
		Reg.background.scale.y = 2;
		add(Reg.background);

		// Set a background color
		FlxG.cameras.bgColor = 0xff364964;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE30
		FlxG.mouse.show();
		#end

		super.create();

		var b:Block = new Block();
		this.add(b);

		Reg.state = this;

        this.addRandomThings();
		this.add(new Clouds(0, 0));

        level = new TiledLevel("data/map.tmx", "images/tileset.png", 25);
        add(level.backgroundTiles);
        add(level.foregroundTiles);
        level.loadObjects(this);

		var p:Player = new Player(50, 50);
		this.add(p);

        Reg.map = level;

        Reg.player = p;

        FlxG.camera.follow(Reg.player, FlxCamera.STYLE_PLATFORMER);

        add(new HUD());

#if debug
        Reg.mapX = 4;
        Reg.mapY = 0;
#end

        p.y = 450;
        p.x = 150;

        p.x += Reg.mapX * Reg.mapWidth;
        p.y += Reg.mapY * Reg.mapHeight;

        /*
#if debug
		game.GirlBot.onlyGirl.isFollowingPlayer = true;
        game.GirlBot.onlyGirl.x = p.x;
        game.GirlBot.onlyGirl.y = p.y;
#end
		*/

        checkUpdateScreen(true);

		game.MusicManager.firstTheme();

		Reg.girlmusic.volume = 1;

		Reg.jumpSound.loadEmbedded("sounds/jump." + #if flash "mp3" #else "ogg" #end);
		Reg.landSound.loadEmbedded("sounds/land." + #if flash "mp3" #else "ogg" #end);
		Reg.landSound.volume = .4;

		Reg.shootSound.loadEmbedded("sounds/shoot." + #if flash "mp3" #else "ogg" #end);
		Reg.blowupSound.loadEmbedded("sounds/blowup." + #if flash "mp3" #else "ogg" #end);

		Reg.youdieSound.loadEmbedded("sounds/youdie." + #if flash "mp3" #else "ogg" #end);
		Reg.shediesSound.loadEmbedded("sounds/shedies." + #if flash "mp3" #else "ogg" #end);
	}

	private function addRandomThings() {
		scenery = new FlxEmitter(0, 0);
		scenery.width = FlxG.width;
		scenery.height = FlxG.height;
		scenery.makeParticles("images/driftparticle.png", 100, 0, true);
		scenery.startAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds(.4, .5);
		scenery.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		scenery.start(false, 2, 0.1, 0, 8);
		scenery.setXSpeed(-50, 50);
		scenery.setYSpeed(12, 50);
		FlxG.state.add(scenery);
	}

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		if (Reg.mode == Reg.NORMAL_MODE) {
			for (ent in this.members) {
				if (Std.is(ent, game.MapAwareSprite)) {
					if (!Std.is(ent, GirlBot) || (Std.is(ent, game.GirlBot) && !Reg.player.girlFound)) { // exempt!
						var fs:FlxSprite = cast(ent, FlxSprite);
			        	ent.active = Reg.withinBoundaries(fs.x, fs.y);
			        }
		        }
			}

			super.update();

			checkUpdateScreen();

#if debug
			if (FlxG.keys.justPressed.R) {
				this.remove(level.foregroundTiles);
				this.remove(level.backgroundTiles);

		        level = new TiledLevel("data/map.tmx", "images/tileset.png", 25);
		        add(level.foregroundTiles);
		        add(level.backgroundTiles);
		        level.loadObjects(this);
			}
#end

        } else if (Reg.mode == Reg.DIALOG_MODE) {
        	game.DialogBox.onlyDialog.update();
        }
	}	
}