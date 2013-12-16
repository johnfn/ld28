package game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;

import flixel.addons.ui.FlxInputText;
import flixel.util.FlxPoint;
import game.Interactable;

class HUD extends FlxObject {
	var zAction:FlxText;

	public function new() {
		super(0, 0);

		zAction = new FlxText(0, 0, 300, "Z: Do absolutely nothing.", 14);
		FlxG.state.add(zAction);
		zAction.scrollFactor.x = 0;
		zAction.scrollFactor.y = 0;
	}

	public override function update() {
		super.update();

		var selectedInteractor:game.Interactable = Interactable.getInteractor();
		zAction.size = 14;

		if (selectedInteractor != null) {
			zAction.text = selectedInteractor.actionString();

			if (zAction.text == "Z to talk") {
				zAction.size = 36;
				if (!flixel.util.FlxSpriteUtil.isFlickering(zAction)) {
					flixel.util.FlxSpriteUtil.flicker(zAction, 99999, .5);
				}
			} else {
				flixel.util.FlxSpriteUtil.stopFlickering(zAction);
			}
		} else {
			flixel.util.FlxSpriteUtil.stopFlickering(zAction);
			if (Spike.endgameExplained) {
				zAction.text = "Press z to be awesome.";
			} else {
				zAction.text = "Press z to do literally nothing.";
			}
		}
	}
}