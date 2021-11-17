package;

import nape.dynamics.InteractionFilter;
import nape.phys.Body;
import nape.phys.Material;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.shape.Circle;

class Speeder extends FlxPhysSprite
{
	public var cost:Int;
	public var hover:Bool;
	
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx, by);
		hover = false;
		cost = 17;
		//Graphics
		loadGraphic("assets/speeder.png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Set interaction filters
		var speederFilter:InteractionFilter = new InteractionFilter();
		speederFilter.collisionGroup = 0;
		speederFilter.collisionMask = 0;
		//Physics Body
		createCircularBody(19);
		body.setShapeFilters(speederFilter);
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
			var aRad:Float;
			var ball:Ball;
			var dx:Float;
			var dy:Float;
			var dist:Float;
			var vx:Float;
			var vy:Float;
			for (i in Registry.shotManager.members)
			{
				if (i.alive && exists)
				{
					//trace("gravity ball");
					// Find closest points between bodies.
					//samplePoint.position.set(body.position);
					ball = cast(i, Ball);
					aRad = (ball.body.velocity.angle);
					dx = body.position.x - ball.body.position.x;
					dy = body.position.y - ball.body.position.y;
					dist = Math.sqrt(dx * dx + dy * dy);
					vx = Math.cos(aRad) * 60;
					vy = Math.sin(aRad) * 60;
					//var distance = Geom.distanceBody(body, ball.body, closestA, closestB);
					// Cut gravity off, well before distance threshold.
					if (dist > 40) 
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
					//ball.body.velocity.x += 200;
					//ball.body.velocity.y += 200;
					ball.body.velocity.x += vx;
					ball.body.velocity.y += vy;
				}
			}
			closestA.dispose();
			closestB.dispose();
		}
	}
}