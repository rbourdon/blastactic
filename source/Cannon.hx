package;

import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxTimer;
import addons.FlxEmitterExt;
import org.flixel.FlxParticle;

class Cannon extends FlxSprite
{
	public var power:Int;
	public var canFire:Bool;
	public var shots:Int;
	public var emit:FlxEmitterExt;
	
	public function new(x:Int=0,y:Int=0,ang:Float=0)
	{
		super(x,y);
		power = 775;
		shots = 45;
		//Load Graphics
		loadGraphic("assets/shotgun.png");
		//offset.x += 47;
		//offset.y += 58;
		angle = ang;
		//centerOffsets();
		antialiasing = true;
		emit = new FlxEmitterExt();
		emit.width = 5;
		emit.height = 5;
		emit.particleDrag = new FlxPoint(7,7);
		//emit.
		//var part;
		for (i in 0...100)
		{
			var part:FlxParticle = new FlxParticle();
			part.makeGraphic(2, 2, 0xffffffff);
			part.exists = false;
			emit.add(part);
			var part:FlxParticle = new FlxParticle();
			part.makeGraphic(3, 3, 0xffffa412);
			part.exists = false;
			emit.add(part);
		}
		Registry.particles.add(emit);
	}
	public function fire():Void
	{
		emit.callAll("kill", false);
		Registry.handJoint.active = false;
		if (Registry.shotManager.countLiving() > 0)
		{
			Registry.playState.retry();
		}
		//Shot Particles
		emit.minParticleSpeed = new FlxPoint(0, 0);
		emit.setMotion(angle-50, 50, .4, 100, 400, .3);
		emit.start(true, 0, .1, 0);
		//FlxG.play("Bounce");
		//FlxG.log("handjoint deactivated");
		//Registry.handJoint.active = false;
		var aRad:Float;
		var vx:Float;
		var vy:Float;
		var dx:Float;
		var dy:Float;
		var i:Int = 0;
		//var j:Int = 0;
		var aRad:Float = angle * (Math.PI/180);
		//var rand:Float = 1;
		var row:Int = 0;
		//if (Registry.shotManager.countLiving() < shots)
		//{
			var i:Int = 0;
			var g:Int = 0;
			for (j in 0...shots)
			{
				//Registry.shotManager.countLiving() > 0
				//trace("fire");
				//trace(j);
				//var aRad:Float = angle  * .0174;
				//var rand:Float = Math.random() + .6;
				//if (rand < .6)
				//{
					//rand = .6;
				//}
				dx = Math.cos(aRad);
				dy = Math.sin(aRad);
				vx = dx * power;
				vy = dy * power;
				dx = Math.cos(aRad);
				dy = Math.sin(aRad);
				var p:FlxPoint = getMidpoint();
				Registry.shotManager.fire(p.x + (dx * 75) + i*8 - (5*8/2), p.y + (dy * 75) + g*8 - (5*8/2), vx, vy);
				i++;
				if (i > 6)
				{
					g++;
					i = 0;
				}
			}
			//}
			//row++;;
			//canFire = false;
		//}
	}
}