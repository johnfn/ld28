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
	var allDialog:Array<String>;
	var doneCB:Void -> Void;

	public static var onlyDialog:DialogBox;

	public function new(allDialog:Array<String>) {
		super(125, 300);

		box = new FlxSprite(125, 300);
		textbox = new FlxText(150, 325, 350, "", 14);
		textbox.setBorderStyle(FlxText.BORDER_SHADOW, 0, 3);
		box.loadGraphic("images/dialogbox.png");

		this.allDialog = allDialog;

		Reg.state.add(box);
		Reg.state.add(textbox);

        Reg.mode = Reg.DIALOG_MODE;
		DialogBox.onlyDialog = this;
	}

	public function addDoneCB(cb:Void -> Void) {
		this.doneCB = cb;
	}

	private function advanceDialog() {
		allDialog.splice(0, 1);
		
		if (allDialog.length > 0) {
			textbox.text = "";
		} else {
			Reg.mode = Reg.NORMAL_MODE;
			textbox.visible = false;
			box.visible = false;

			FlxG.state.remove(this);

			this.doneCB();
		}
	}

	public override function update() {
		super.update();

		if (textbox.text.length != allDialog[0].length) {
			if (FlxG.keys.justPressed.Z) {
				textbox.text = allDialog[0];
			} else {
				textbox.text = allDialog[0].substr(0, textbox.text.length + 1);
			}
		} else {
			if (FlxG.keys.justPressed.Z) {
				advanceDialog();
			}
		}
	}
}