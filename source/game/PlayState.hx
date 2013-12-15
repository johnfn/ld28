package game;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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

    public function checkUpdateScreen() {
        var change:Bool = false;

        if (Reg.player.x > (Reg.mapX + 1) * Reg.mapWidth) {
                Reg.mapX++;
                change = true;
        }

        if (Reg.player.x < Reg.mapX * Reg.mapWidth) {
                Reg.mapX--;
                change = true;
        }

        if (Reg.player.y > (Reg.mapY + 1) * Reg.mapHeight) {
                Reg.mapY++;
                change = true;
        }

        if (Reg.player.y < Reg.mapY * Reg.mapHeight) {
                Reg.mapY--;
                change = true;
        }

        if (change) {
            FlxG.camera.setBounds(Reg.mapX * Reg.mapWidth, Reg.mapY * Reg.mapHeight, Reg.mapWidth, Reg.mapHeight, true);
        }
    }


	override public function create():Void {
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
        add(level.foregroundTiles);
        add(level.backgroundTiles);
        level.loadObjects(this);

		var p:Player = new Player(50, 50);
		this.add(p);

        Reg.map = level;

        Reg.player = p;

        FlxG.camera.follow(Reg.player, FlxCamera.STYLE_PLATFORMER);

        Reg.mode = Reg.DIALOG_MODE;

        add(new HUD());

        add(new DialogBox(["You are the slowest programmer in the world.", "It's true."]));
	}

	private function addRandomThings() {
		var explosion:FlxEmitter = new FlxEmitter(0, 0);
		explosion.width = FlxG.width;
		explosion.height = FlxG.height;
		explosion.makeParticles("images/boomparticle.png", 100, 0, true);
		explosion.startAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds(.4, .5);
		explosion.endAlpha = new flixel.effects.particles.FlxTypedEmitter.Bounds<Float>(0.0, 0.1);
		explosion.start(false, 2, 0.1, 0, 8);
		explosion.setXSpeed(-50, 50);
		explosion.setYSpeed(-50, 50);
		FlxG.state.add(explosion);
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

	        Reg.inactives.setAll("active", true);
	        Reg.inactives.update();
	        Reg.inactives.setAll("active", false);
        } else if (Reg.mode == Reg.DIALOG_MODE) {
        	game.DialogBox.onlyDialog.update();
        }

	}	
}