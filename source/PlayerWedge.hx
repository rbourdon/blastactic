package;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.phys.MassMode;

class PlayerWedge extends FlxPhysSprite
{
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx,by);
		//Graphics
		loadGraphic("assets/wedge.png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Physics Body
		createRectangularBody();
		body.rotation = ang * (Math.PI / 180);
		body.position.x = bx;
		body.position.y = by;
		body.cbTypes.add(Registry.WALL);
		setDrag(0, 0);
	}
	override public function createRectangularBody():Dynamic 
	{
		//super.createRectangularBody();
		
		//Physics Body
		body = new Body(BodyType.KINEMATIC);
		body.shapes.add(new Polygon([  Vec2.weak(-18, 45),   Vec2.weak( 25, 0),  Vec2.weak(-18, -45)   ]));
		var mats:Material = new Material(Math.POSITIVE_INFINITY, 0, 0, 1, 0);
		body.setShapeMaterials(mats);
		body.space = FlxPhysState.space;
		//body.mass = 10;
		//body.massMode = MassMode.FIXED;
	}
}