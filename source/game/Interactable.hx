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

class Interactable extends FancySprite {
	public var interact:FlxSprite;
	// public static var targetInteractor:Interactable;
	public static var BOUNCE_SPEED:Int = 30;
	public static var VISIBLE_RANGE:Int = 100;

	private var lowestInteractY:Float;
	private var highestInteractY:Float;
	private var percentage:Float = 0;
	private var direction:Float = 1;

	public var showBouncer:Bool = true;

	public function new(x:Int, y:Int) {
		super(x, y);

		lowestInteractY = 0.5;
		highestInteractY = 1.5;

		interact = new FlxSprite(this.x, this.y - this.height - 12);
		interact.loadGraphic("images/bang.png");
		FlxG.state.add(interact);

		Reg.interactors.add(this);
	}

	public function actionString():String {
		return "";
	}

	public function performAction():Void {

	}

	public static function getInteractor():Interactable {
		for (interactor in Reg.interactors.members) {
			var i:game.Interactable = cast(interactor, Interactable);
			if (FlxMath.distanceBetween(i, Reg.player) <= Interactable.VISIBLE_RANGE) {
				return i;
			}
		}

		return null;
	}

	private function bounceInteract() {
		percentage += direction / BOUNCE_SPEED;
		if (percentage > highestInteractY) {
			percentage = highestInteractY;
			direction *= -1;
		}

		if (percentage < lowestInteractY) {
			percentage = lowestInteractY;
			direction *= -1;
		}

		interact.scale.x = FlxMath.lerp(lowestInteractY, highestInteractY, percentage);
		interact.scale.y = FlxMath.lerp(lowestInteractY, highestInteractY, percentage);
	}

	public override function update() {
		if (FlxMath.distanceBetween(this, Reg.player) <= VISIBLE_RANGE && showBouncer) {
			interact.visible = true;

			bounceInteract();
		} else {
			interact.visible = false;
		}
		super.update();
	}
}