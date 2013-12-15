package game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;

class MapAwareSprite extends FlxSprite {
        public function onCurrentMap() {
                return (this.x >= Reg.mapX * Reg.mapWidth && this.x <= (Reg.mapX + 1) * Reg.mapWidth && 
                        this.y >= Reg.mapY * Reg.mapHeight && this.y <= (Reg.mapY + 1) * Reg.mapHeight);
        }
}