package;

import addons.FlxEmitterExt;
import addons.FlxTrail;
import org.flixel.FlxSprite;
import nape.dynamics.InteractionFilter;
import nape.geom.Geom;
import nape.geom.Vec2;
import org.flixel.FlxG;
import nape.phys.MassMode;
import nape.phys.Material;
import org.flixel.FlxSound;
import org.flixel.FlxParticle;

class Ball extends FlxPhysSprite
{
	public var maxVel:Int;		
	public var emit:FlxEmitterExt;
	//private var snd_wallHit:FlxSound = new FlxSound()
	
	public function new()
	{
		super();
		//Create ball
		loadRotatedGraphic("assets/cannonball.png");
		createCircularBody(5.5);
		antialiasing = true;
		
		//Set interaction filters
		var ballFilter:InteractionFilter = new InteractionFilter();
		ballFilter.collisionGroup = 2;
		//ballFilter.collisionMask = 1;
		body.setShapeFilters(ballFilter);
		var mats:Material = new Material(.4, 0, 0, .1, 0);
		body.setShapeMaterials(mats);
		//body.position.setxy( -50, -50);
		maxVel = 1000;
		//Collision Sound
		body.cbTypes.add(Registry.BALL);
		emit = new FlxEmitterExt();
	}
	public function fire(bx:Float,by:Float, vx:Float, vy:Float):Void
	{		
		//Position the ball
		body.position.setxy(bx - width / 2, by - height / 2); 
		body.velocity.setxy(vx, vy);
		centerOffsets();
		reset(bx - width / 2, by - height / 2);
		if (Registry.ballTrails.getFirstAvailable() != null)
		{
			emit = cast(Registry.ballTrails.getFirstAvailable(), FlxEmitterExt);
			emit.revive();
			emit.setMotion(1, 5, .2, 360, 20, .4);
			//emit.setMotion(2,
			emit.start(false,0,.09,0);
		}
		//emit.makeParticles(
	}
	override function update()
	{
		super.update();
		/*if (exists && body.velocity.length < .1)
		{
			kill();
			if (Registry.shotManager.countLiving() == 0)
			{
				Registry.cannon.canFire = true;
				Registry.goals.callAll("resetHits", false);
			}
		}*/
		//trace(body.velocity.length);
		if (alive && exists)
		{
			if (body.velocity.length > maxVel)
			{
				body.velocity.length -= 10;
			}
			gravityControl();
			emit.x = x+width/2;
			emit.y = y+width/2;
		}
	}
	override public function createCircularBody(radius:Float = 16):Dynamic 
	{
		super.createCircularBody(5);
	}
	private function gravityControl():Void
	{
		//var i;
		//var closestA = Vec2.get();
        var closestB = Vec2.get();
		var ball:Ball;
		var force:Vec2;
		var dx:Float;
		var dy:Float;
		var distance:Float;
		for (i in Registry.shotManager.members)
		{
			ball = cast(i, Ball);
			if (ball.alive && this != ball)
			{
				//var distance = Geom.distanceBody(body, ball.body, closestA, closestB);
				dx = body.position.x - ball.body.position.x;
				dy = body.position.y - ball.body.position.y;
				//var rad:Float = Math.atan2(dy, dx);
				distance = Math.sqrt(dx * dx + dy * dy); 
				//var vx = Math.cos(rad) * 20;
				//var vy = Math.sin(rad) * 20;
				// Cut gravity off, well before distance threshold.
				//var distance = 50;
				//trace(distance);
				if (distance < 1) 
				{
					//trace("no effect");
					continue;
				}
				if (distance > 50) 
				{
					//trace("no effect");
					continue;
				} 
 				// Gravitational force.
				closestB.x = body.position.x;
				closestB.y = body.position.y;
				force = closestB.sub(ball.body.position, true);
				force.length = (ball.body.mass * 260); // ((distance * distance));
				//ball.body.velocity.x += vx;
				//ball.body.velocity.y += vy;
				/*if (force.length > 60000)
				{
					force.length = 60000;
				}*/
				ball.body.applyImpulse(force.muleq(FlxG.elapsed),body.position, true);
				
			}
		}
		//Registry.goals.callAll("resetHits", false);
		//closestA.dispose();
        closestB.dispose();
	}
	override function kill()
	{
		super.kill();
		emit.kill();
		if (Registry.shotManager.countLiving() == 0 && !Registry.cannon.canFire)
		{
			//FlxG.log("retry");
			Registry.playState.retry();
		}
	}
}