package;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.phys.Material;

class SuperWedge extends FlxPhysSprite
{
	public var cost:Int;
	public var hover:Bool;
	
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx, by);
		hover = false;
		cost = 10;
		//Graphics
		loadGraphic("assets/superwedge.png");
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
		body.shapes.add(new Polygon([  Vec2.weak(-30, 16),  Vec2.weak(-20, 16),  Vec2.weak( 41, 0),  Vec2.weak(-20, -17),  Vec2.weak(-30, -17),  Vec2.weak(-41, -7),  Vec2.weak(-41, 7)   ]));
		var mats:Material = new Material(Math.POSITIVE_INFINITY, 0, 0, 1, 0);
		body.setShapeMaterials(mats);
		body.space = FlxPhysState.space;
		//body.mass = 10;
		//body.massMode = MassMode.FIXED;
	}
}
