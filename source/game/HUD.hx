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

		if (selectedInteractor != null) {
			zAction.text = selectedInteractor.actionString();
		} else {
			if (Spike.endgameExplained) {
				zAction.text = "Press z to be awesome.";
			} else {
				zAction.text = "Press z to do literally nothing.";
			}
		}
	}
}