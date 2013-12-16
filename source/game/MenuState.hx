package game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	// poor man's scrolling background
	private var scroll1:FlxSprite;
	private var scroll2:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		Reg.background = new FlxSprite(0, 0);
		Reg.background.scrollFactor.x = 0;
		Reg.background.scrollFactor.y = 0;

		Reg.background.loadGraphic("images/titlescreenunderlay.png");
		Reg.background.scale.x = 1;
		Reg.background.scale.y = 1;
		add(Reg.background);

		scroll1 = new FlxSprite(0, 0);
		scroll1.loadGraphic("images/titlescreenoverlay.png");
		scroll1.x = 0;
		scroll1.y = 0;

		scroll2 = new FlxSprite(0, 0);
		scroll2.loadGraphic("images/titlescreenoverlay.png");
		scroll2.x = scroll1.width;
		scroll2.y = 0;

		add(scroll1);
		add(scroll2);

		var titleText:FlxText = new FlxText(100, 50, 500, "Only One Shot", 48);
		titleText.setBorderStyle(FlxText.BORDER_SHADOW, 0, 3);
		add(titleText);

		var pressXText:FlxText = new FlxText(200, 400, 500, "Press X to continue.", 16);
		pressXText.setBorderStyle(FlxText.BORDER_SHADOW, 0, 3);
		add(pressXText);

		flixel.util.FlxSpriteUtil.flicker(pressXText, 99999, .5);

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		scroll1.x -= .3;
		scroll2.x -= .3;

		if (scroll1.x + scroll1.width < 0) {
			scroll1.x = scroll2.x + scroll2.width;
		}

		if (scroll2.x + scroll2.width < 0) {
			scroll2.x = scroll1.x + scroll1.width;
		}

		if (FlxG.keys.justPressed.X) {
			FlxG.switchState(new game.PlayState());
		}
	}	
}