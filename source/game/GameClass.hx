package game;

import flash.Lib;
import flixel.FlxGame;
	
class GameClass extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / 640;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);

		var fps:Int = Reg.FPS;

#if debug
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), PlayState, ratio, fps, fps);
#else
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MenuState, ratio, fps, fps);
#end
	}
}
