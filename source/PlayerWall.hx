package;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.dynamics.InteractionFilter;
import org.flixel.FlxG;
import nape.phys.MassMode;

class PlayerWall extends FlxPhysSprite
{
	public var cost:Int;
	public var hover:Bool;
	
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx, by);
		hover = false;
		cost = 4;
		//Graphics
		loadGraphic("assets/wall.png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Set interaction filters
		//var wallFilter:InteractionFilter = new InteractionFilter();
		//wallFilter.collisionGroup = 4;
		//wallFilter.collisionMask = 2;
		//Physics Body
		createRectangularBody();
		//body.setShapeFilters(wallFilter);
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
		//body.allowMovement = false;
		//body.allowRotation = false;
		//body.shapes.add(new Polygon(Polygon.box(18, 86)));
		body.shapes.add(new Polygon([  Vec2.weak( -9, -43)   ,  Vec2.weak( -9, 43)   ,  Vec2.weak(9, 43)   ,  Vec2.weak(9, -43)  ]));
		var mats:Material = new Material(Math.POSITIVE_INFINITY, 0, 0, 1, 0);
		body.setShapeMaterials(mats);
		body.space = FlxPhysState.space;
		//body.rotation = angle;
		//body.mass = 10;
		//body.massMode = MassMode.FIXED;
	}
}