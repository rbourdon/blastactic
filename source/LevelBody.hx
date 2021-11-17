package;

import nape.phys.Material;
import nme.display.Bitmap;
import org.flixel.FlxG;
import nme.display.BitmapData;
import nme.Lib;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxCollision;
import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nme.display.DisplayObject;
import nape.dynamics.InteractionFilter;
import nme.Assets;
import nme.geom.ColorTransform;
import nme.geom.Rectangle;
import nme.display.BitmapDataChannel;
import nme.geom.Point;

//@:bitmap("assets/shell1.png") class LBit extends flash.display.BitmapData {}

class LevelBody extends FlxSprite
{
	public var levelBody:Body;
	
	public function new(x:Int,y:Int)
	{
		super(x, y);
		var bgString:String = "assets/levelblock" + Std.string(Registry.levelNumber) + ".png";
		//var bgStr:String = "assets/shelltest.png";
		var maskBmp:BitmapData = Assets.getBitmapData(bgString, false);
		var invertBmp:BitmapData = Assets.getBitmapData("assets/levelbg.png", false);
		invertBmp.threshold(maskBmp, new Rectangle(0, 0, 1281, 721), new Point(), "==", 0xFF000000, 0x00FFFFFF, 0xFF000000, false);
		
		//maskBmp.draw(Assets.getBitmapData(bgStr,false));
		//invertBmp.copyChannel(maskBmp, new Rectangle(0, 0, 1280, 721), new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
		//maskBmp.colorTransform(new Rectangle(0, 0, 1280, 721), new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0));
		pixels = invertBmp;
		//loadGraphic(bgStr);
		
		//Create Level Physics Body
		//var levelBits = Assets.getBitmapData(bgString);
		var levelIso = new BitmapDataIso(invertBmp, 0x80);
		
		levelBody = IsoBody.run(levelIso, levelIso.bounds, Vec2.weak(2, 2), 5, 1);
        levelBody.position.setxy(0, 0);
        levelBody.space = FlxPhysState.space;
		levelBody.type = BodyType.STATIC;
		//var graphic:DisplayObject = levelIso.graphic();
		//levelBody.userData.graphic = graphic;
		var mats:Material = new Material(Math.POSITIVE_INFINITY, 0, 0, 1, 0);
		levelBody.setShapeMaterials(mats);
		//Set interaction filters
		var lvlFilter:InteractionFilter = new InteractionFilter();
		lvlFilter.collisionGroup = 1;
		lvlFilter.collisionMask = 2;
		levelBody.setShapeFilters(lvlFilter);
		levelBody.cbTypes.add(Registry.WALL);
	}
}