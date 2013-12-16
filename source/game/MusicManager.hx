package game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;

class MusicManager extends FlxObject {
	public function new() {super(); }

	public static function firstTheme():Void {
        Reg.boymusic = new FlxSound();
#if flash
        Reg.boymusic.loadEmbedded("music/boythemefinal.mp3", true);
#else
        Reg.boymusic.loadEmbedded("music/boythemefinal.ogg", true);
#end 
        Reg.boymusic.volume = 0;

        Reg.girlmusic = new FlxSound();
#if flash
        Reg.girlmusic.loadEmbedded("music/girlthemefinal.mp3", true);
#else
        Reg.girlmusic.loadEmbedded("music/girlthemefinal.ogg", true);
#end 
        Reg.girlmusic.volume = 0;

        Reg.girlmusic.play();
        Reg.boymusic.play();
	}
}