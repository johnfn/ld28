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

class Torch extends FancySprite {
        public function new(x:Int, y:Int) {
                super(x, y);

                this.loadGraphic("images/torch.png", true, false, 50, 50);
                this.animation.add("idle", [0, 1, 2, 3, 4], 10);

                this.animation.play("idle");
        }

        public override function update() {
                super.update();
        }
}