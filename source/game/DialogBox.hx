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

class DialogBox extends FlxObject {
	var box:FlxSprite;
	var textbox:FlxText;
	var text:Array<String>;

	public static var onlyDialog:DialogBox;

	public function new(text:Array<String>) {
		super(125, 300);

		box = new FlxSprite(125, 300);
		textbox = new FlxText(150, 325, 350, text[0], 14);
		textbox.setBorderStyle(FlxText.BORDER_SHADOW, 0, 3);
		box.loadGraphic("images/dialogbox.png");

		text.splice(0, 1);

		this.text = text;

		Reg.state.add(box);
		Reg.state.add(textbox);

        Reg.mode = Reg.DIALOG_MODE;
		DialogBox.onlyDialog = this;
	}

	private function advanceDialog() {
		if (text.length > 0) {
			textbox.text = text.splice(0, 1)[0];
		} else {
			Reg.mode = Reg.NORMAL_MODE;
			textbox.visible = false;
			box.visible = false;

			FlxG.state.remove(this);
		}
	}

	public override function update() {
		super.update();

		trace(Math.random());

		if (FlxG.keys.justPressed.Z) {
			advanceDialog();
		}
	}
}