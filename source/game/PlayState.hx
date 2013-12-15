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
            FlxG.camera.setBounds(Reg.mapX * Reg.mapWidth, Reg.mapY * Reg.mapHeight, Reg.mapWidth, Reg.mapHeight, true);
            scenery.x = FlxG.camera.x;
            scenery.y = FlxG.camera.y;
            Reg.player.safeLocation = null;
        }
    }


	override public function create():Void {
#if debug
		FlxG.autoPause = false;
#end

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

        // add(new DialogBox(["Clever introduction words here"]));

        checkUpdateScreen(true);
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
		scenery.setYSpeed(-50, 50);
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

			for (ent in this.members) {
				if (Std.is(ent, game.MapAwareSprite)) {
					if (!Std.is(ent, GirlBot) || (Std.is(ent, game.GirlBot) && !Reg.player.girlFound)) { // exempt!
			        	ent.active = cast(ent, game.MapAwareSprite).onCurrentMap();
			        }
		        }
			}
        } else if (Reg.mode == Reg.DIALOG_MODE) {
        	game.DialogBox.onlyDialog.update();
        }
	}	
}