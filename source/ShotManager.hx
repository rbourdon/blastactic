package;

import org.flixel.FlxGroup;
import org.flixel.FlxParticle;
import org.flixel.FlxSprite;
import addons.FlxEmitterExt;
import org.flixel.FlxG;


class ShotManager extends FlxGroup
{
	
	public function new(poolSize:Int = 45)
	{
		super(poolSize);
		var i:Int = 0;
		while (i < poolSize)
		{
			var shot = new Ball();
			shot.alive = false;
			shot.exists = false;
			add(shot);
			var ballTrail = new FlxEmitterExt(shot.x, shot.y);
			//ballTrail.makeParticles("assets/cannonballpart2.png", 10, 1, true, 0);
			//ballTrail.makeParticles("assets/cannonballpart3.png", 10, 1, true,0);
			for (j in 0...3)			
			{
				var part:FlxParticle = new FlxParticle();
				part.loadGraphic("assets/balltrail.png");
				part.kill();
				ballTrail.add(part);
				part = new FlxParticle();
				part.makeGraphic(2, 2, 0xffbcd122);
				part.kill();
				ballTrail.add(part);
			}
			Registry.ballTrails.add(ballTrail);
			ballTrail.kill();
			i++;
		}
	}
	public function fire(bx:Float, by:Float, vx:Float, vy:Float):Void
	{
		if (getFirstAvailable() != null)
		{
			var shot = cast(getFirstAvailable(), Ball);
			shot.fire(bx, by, vx, vy);
		}
		else
		{
			//trace("No Shots!");
		}
	}
}