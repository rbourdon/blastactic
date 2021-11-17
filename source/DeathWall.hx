package;

import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.Body;
import org.flixel.FlxG;
import nape.dynamics.InteractionFilter;

class DeathWall extends FlxPhysSprite
{
	public function new(bx:Float, by:Float, ang:Float, size:String)
	{
		super(bx,by);
		//Graphics
		//FlxG.log(size);
		loadGraphic("assets/" + size + ".png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Physics Body
		createBody(size, bx, by, ang);
		var dWallFilter:InteractionFilter = new InteractionFilter();
		dWallFilter.collisionGroup = 1;
		dWallFilter.collisionMask = 2;
		body.setShapeFilters(dWallFilter);
		body.cbTypes.add(Registry.DEATHWALL);
		setDrag(0, 0);
	}
	private function createBody(size:String,bx:Float,by:Float,ang:Float):Dynamic 
	{
		//super.createRectangularBody();
		
		//Physics Body
		body = new Body(BodyType.STATIC);
		body.rotation = ang * (Math.PI / 180);
		body.position.x = bx;
		body.position.y = by;
		//body.allowMovement = false;
		//body.allowRotation = false;
		//body.shapes.add(new Polygon(Polygon.box(18, 86)));
		switch( size ) 
		{
			case "deathwall1":
				body.shapes.add(new Polygon([   Vec2.weak( 6, -27)   ,  Vec2.weak( 6, 26)   ,  Vec2.weak(10, 26)   ,  Vec2.weak(10, -27)   ]));
			case "deathwall2":
				body.shapes.add(new Polygon([   Vec2.weak( 7, -48)   ,  Vec2.weak( 7, 48)   ,  Vec2.weak(11, 48)   ,  Vec2.weak(11, -48)   ]));
			case "deathwall3":
				body.shapes.add(new Polygon([   Vec2.weak( 5, -71)   ,  Vec2.weak( 5, 71)   ,  Vec2.weak(10, 71)   ,  Vec2.weak(10, -71)   ]));
			case "deathwall4":
				body.shapes.add(new Polygon([   Vec2.weak( 6, -94)   ,  Vec2.weak( 6, 94)   ,  Vec2.weak(10, 94)   ,  Vec2.weak(10, -94)   ]));
			default:
				body.shapes.add(new Polygon([   Vec2.weak( 7, -27)   ,  Vec2.weak( 7, 27)   ,  Vec2.weak(11, 27)   ,  Vec2.weak(11, -27)   ]));
		}
		//var mats:Material = new Material(Math.POSITIVE_INFINITY, 0, 0, 1, 0);
		//body.setShapeMaterials(mats);
		body.space = FlxPhysState.space;
		//body.rotation = angle;
		//body.mass = 10;
		//body.massMode = MassMode.FIXED;
	}
}