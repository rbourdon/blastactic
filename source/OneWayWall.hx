package;

import nape.phys.Body;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.dynamics.InteractionFilter;
import org.flixel.FlxG;
import nape.phys.MassMode;
import nape.callbacks.CbType;
import nape.callbacks.PreListener;
import nape.callbacks.InteractionType;
import nape.callbacks.PreFlag;
import nape.callbacks.PreCallback;

class OneWayWall extends FlxPhysSprite
{
	private var oneWayType:CbType;
	public var cost:Int;
	public var hover:Bool;
	
	public function new(bx:Float, by:Float, ang:Int)
	{
		super(bx, by);
		hover = false;
		cost = 8;
		//Graphics
		loadGraphic("assets/onewaywall.png");
		centerOffsets();
		antialiasing = true;
		angle = ang;
		
		//Set interaction filters
		//var onewaywallFilter:InteractionFilter = new InteractionFilter();
		//wallFilter.collisionGroup = 4;
		//wallFilter.collisionMask = 2;
		//Physics Body
		createRectangularBody();
		//body.setShapeFilters(onewaywallFilter);
		body.rotation = ang * (Math.PI / 180);
		body.position.x = bx;
		body.position.y = by;
		setDrag(0, 0);
		//OneWay
		oneWayType = new CbType();
        FlxPhysState.space.listeners.add(new PreListener(
            InteractionType.COLLISION,
            oneWayType,
            CbType.ANY_BODY,
            oneWayHandler,
            /*precedence*/ 0,
            /*pure*/ true
        ));
		body.cbTypes.add(oneWayType);
	}
	override public function createRectangularBody():Dynamic 
	{
		//super.createRectangularBody();
		
		//Physics Body
		body = new Body(BodyType.KINEMATIC);
		//body.allowMovement = false;
		//body.allowRotation = false;
		//body.shapes.add(new Polygon(Polygon.box(18, 86)));
		body.shapes.add(new Polygon([   Vec2.weak( -7, -43)   ,  Vec2.weak( -7, 43)   ,  Vec2.weak(6, 43)   ,  Vec2.weak(6, -43)   ]));
		var mats:Material = new Material(Math.POSITIVE_INFINITY, 0, 0, 1, 0);
		body.setShapeMaterials(mats);
		body.space = FlxPhysState.space;
		//body.rotation = angle;
		//body.mass = 10;
		//body.massMode = MassMode.FIXED;
	}
	function oneWayHandler(cb:PreCallback):PreFlag {
        var colArb = cb.arbiter.collisionArbiter;
        if (cb.arbiter.collisionArbiter.referenceEdge2.localNormal.x < 0) 
		{
			//trace("ignore");
            return PreFlag.IGNORE;
        }
        else 
		{
			//trace("accept");
            return PreFlag.ACCEPT;
        }
    }
}