package;

import nape.phys.Body;
import nape.phys.Material;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.geom.Geom;
import nape.geom.Vec2;
import org.flixel.FlxG;
import nape.dynamics.InteractionFilter;


class Mover extends FlxPhysSprite
{
	public var cost:Int;
	public var hover:Bool;
	
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx, by);
		hover = false;
		cost = 15;
		//Graphics
		loadGraphic("assets/mover.png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Set interaction filters
		var moverFilter:InteractionFilter = new InteractionFilter();
		moverFilter.collisionGroup = 0;
		moverFilter.collisionMask = 0;
		//Physics Body
		createCircularBody(19);
		body.setShapeFilters(moverFilter);
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
		{
			destroyPhysObjects();
		}
		this.centerOffsets(false);
		body = new Body(BodyType.KINEMATIC);
		body.shapes.add(new Circle(radius));
		body.space = FlxPhysState.space;
		var mats:Material = new Material(.98, 0, 0, 1, 0);
		body.setShapeMaterials(mats);
		//body.space = FlxPhysState.space;
		//body.rotation = angle;
		//body.mass = 10;
		//body.massMode = MassMode.FIXED;
	}
	override public function update()
	{
		super.update();
		if (alive)
		{
			var i:Int;
			var j:Int;
			var closestA = Vec2.get();
			var closestB = Vec2.get();
			//for (i in Registry.shotManager.members)
			//{
				
			//}
			for (i in Registry.shotManager.members)
			{
				if (i.alive && exists)
				{
					//trace("gravity ball");
					// Find closest points between bodies.
					//samplePoint.position.set(body.position);
					var aRad:Float = (angle-90) * (Math.PI/180);
					var ball:Ball = cast(i, Ball);
					var dx:Float = body.position.x - ball.body.position.x;
					var dy:Float = body.position.y - ball.body.position.y;
					var dist:Float = Math.sqrt(dx * dx + dy * dy);
					//var vx:Float = Math.cos(aRad) * 560;
					//var vy:Float = Math.sin(aRad) * 560;
					//var distance = Geom.distanceBody(body, ball.body, closestA, closestB);
					// Cut gravity off, well before distance threshold.
					if (dist > 30) 
					{
						continue;
					}
					// Gravitational force.
					//var force = closestA.sub(ball.body.position, true);
					//force.length *= 3.5;
	 
					// We don't use a true description of gravity, as it doesn't 'play' as nice.
					//trace(force.length);
					//force.length = ball.body.mass * 1800000;
					//trace(body.mass * 1000 / (distance * distance));
					// Impulse to be applied = force * deltaTime
					//ball.body.applyImpulse(force.muleq(FlxG.elapsed), null, false);
					ball.body.velocity.angle = (angle-90) * (Math.PI / 180);
					ball.body.velocity.length *= 1.05;
					//ball.body.velocity.x = ball.body.velocity.x * .1 + vx;
					//ball.body.velocity.y = ball.body.velocity.y * .1 + vy;
				}
			}
			closestA.dispose();
			closestB.dispose();
		}
	}
}