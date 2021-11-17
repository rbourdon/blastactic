package;

import org.flixel.FlxBasic;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.Material;
import org.flixel.plugin.photonstorm.FlxMouseControl;
import nme.events.MouseEvent;

class PlayerTray extends FlxGroup
{
	public var wallIcon:FlxSprite;
	
	public function new(x:Int, y:Int)
	{
		super();
		
		//wall.enableMouseDrag(false, true);
		//wall.enableMouseClicks(false, true);
		//wall.mousePressedCallback = wallClick;
		
	}
	override function update()
	{
		super.update();
	}
	public function wallClick(obj:FlxExtendedSprite, ox:Int, oy:Int)
	{
		trace("wall clicked");
	}
	
}