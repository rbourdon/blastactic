package;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.dynamics.InteractionFilter;
import org.flixel.FlxG;
import nape.shape.Circle;
import nape.geom.Geom;

class GravityWell extends FlxPhysSprite
{
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx,by);
		//Graphics
		loadGraphic("assets/gravitywell.png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Set interaction filters
		var wellFilter:InteractionFilter = new InteractionFilter();
		//wellFilter.collisionGroup = 4;
		//wellFilter.collisionMask = 1;
		//Physics Body
		createCircularBody(15);
		body.setShapeFilters(wellFilter);
		body.rotation = ang * (Math.PI / 180);
		body.position.x = bx;
		body.position.y = by;
		setDrag(0, 0);
		//var mats:Material = new Material(.98, 0, 0, 1, 0);
		//body.setShapeMaterials(mats);
		//body.type = BodyType.KINEMATIC;
	}
	override public function createCircularBody(radius:Float = 16):Dynamic
	{
		//super.createRectangularBody();
		
		if (body != null) 
			destroyPhysObjects();

		this.centerOffsets(false);
		body = new Body(BodyType.KINEMATIC);
		body.shapes.add(new Circle(radius));
		body.space = FlxPhysState.space;
		var mats:Material = new Material(.98, 0, 0, 1, 0);
		body.setShapeMaterials(mats);
	}
	override public function update()
	{
		super.update();
		
		var i:Int;
		var j:Int;
		var closestA = Vec2.get();
        var closestB = Vec2.get();
		for (i in Registry.shotManager.members)
		{
			if (i.alive)
			{
				var ball = cast(i, Ball);
				var distance = Geom.distanceBody(body, ball.body, closestA, closestB);
				// Cut gravity off, well before distance threshold.
				if (distance > 60) 
				{
					continue;
				}
				else if (distance < 8)
				{
					continue;
				}
				// Gravitational force.
				var force = closestA.sub(ball.body.position, true);
				force.length = ball.body.mass * 2000000 / (distance * distance) * -1;
				//if (force.length > 2700)
				//{
						
					//force.length = 2700;
				//}
				ball.body.applyImpulse(
					/*impulse*/ force.muleq(FlxG.elapsed),
					/*position*/ ball.body.position, // implies body.position
					/*sleepable*/ false);
			}
		}
		closestA.dispose();
        closestB.dispose();
	}
} 