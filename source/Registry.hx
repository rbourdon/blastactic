package;

import nape.callbacks.CbType;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.system.input.Mouse;
import nape.callbacks.InteractionListener;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionCallback;
import org.flixel.FlxG;
import addons.FlxEmitterExt;
import org.flixel.FlxParticle;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;

class Registry
{
	public static var level:Level;
	public static var shotManager:ShotManager;
	public static var levelBody:LevelBody;
	public static var objects:FlxGroup;
	public static var goals:FlxGroup;
	public static var cannon:Cannon;
	public static var hazards:FlxGroup;
	public static var WALL:CbType;
	public static var BALL:CbType;
	public static var DEATHWALL:CbType;
	public static var levelNumber:Int;
	public static var ballTrails:FlxGroup;
	public static var ballTrail:FlxEmitterExt;
	public static var maxCredits:Int;
	public static var bumps:FlxGroup;
	public static var corners:FlxGroup;
	public static var handJoint:PivotJoint;
	public static var particles:FlxGroup;
	public static var numLevels:Int;
	public static var playState:PlayState;
	
	public static function init(lNum:Int=1, pState)
	{
		playState = pState;
		numLevels = 10;
		levelNumber = lNum;
		maxCredits = 0;
		BALL = new CbType();
		WALL = new CbType();
		DEATHWALL = new CbType();
		particles = new FlxGroup();
		//cannon = new Cannon(0, 0, 0);
		bumps = new FlxGroup();
		corners = new FlxGroup();
		ballTrails = new FlxGroup();
		goals = new FlxGroup();
		objects = new FlxGroup();
		hazards = new FlxGroup();
		levelBody = new LevelBody(0, 0);
		level = new Level(levelNumber);
		shotManager = new ShotManager(cannon.shots);
		
		//Set Up Piece Handle Joint
		handJoint = new PivotJoint(FlxPhysState.space.world, null, Vec2.weak(), Vec2.weak());
        handJoint.space = FlxPhysState.space;
        handJoint.active = false;
        handJoint.stiff = false;
		
		
		//Collision Events
		//Ball->Wall Sound
		FlxPhysState.space.listeners.add(new InteractionListener(
            CbEvent.BEGIN,
			InteractionType.COLLISION,
            WALL,
            BALL,
            bounceSound,
            /*precedence*/ 0
        ));
		//Ball-DeathWall Sound + Particles
		FlxPhysState.space.listeners.add(new InteractionListener(
            CbEvent.BEGIN,
			InteractionType.COLLISION,
            DEATHWALL,
            BALL,
            ballDWall,
            /*precedence*/ 0
        ));
	}
	public static function bounceSound(cb:InteractionCallback):Void
	{
		//PlayState.ballSnd.stop();
		//PlayState.ballSnd = FlxG.play("Bounce",.3);
	}
	public static function ballDWall(cb:InteractionCallback):Void
	{
		for (i in shotManager.members)
		{
			var ball = cast(i, Ball);
			if (ball.body == cb.int2.castBody)
			{
				//Kill Trail
				ball.emit.kill();
				//PlayState.dWallBallSnd.stop();
				//PlayState.dWallBallSnd = FlxG.play("dWallBall");
				//Death Particles
				var part:FlxParticle = new FlxParticle();
				var ballD = new FlxEmitterExt(ball.x, ball.y);
				part.loadGraphic("assets/cannonballpart1.png");
				part.exists = false;
				ballD.add(part);
				part = new FlxParticle();
				part.loadGraphic("assets/cannonballpart2.png");
				part.exists = false;
				ballD.add(part);
				part = new FlxParticle();
				part.loadGraphic("assets/cannonballpart3.png");
				part.exists = false;
				ballD.add(part);
				part = new FlxParticle();
				part.loadGraphic("assets/cannonballpart4.png");
				part.exists = false;
				ballD.add(part);
				ballD.setMotion(1, 2, 2, 360, 20, 1);
				ballD.start(true, 0, .1, 0);
				particles.add(ballD);
				
				ball.kill();
				break;
			}
		}
	}
}