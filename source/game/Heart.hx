package game;

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

class Heart extends FlxSprite {
	public var follow:FlxSprite;

    public function new(follow:FlxSprite) {
        super(0, 0);

        this.loadGraphic("images/heart.png");
        this.follow = follow;
    }

    public override function update() {
        super.update();

        this.x = follow.x;
        this.y = follow.y - 25;
    }
}