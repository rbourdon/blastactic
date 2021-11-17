package;

import nme.Assets;
import haxe.xml.Fast;
import haxe.xml.Parser;
import org.flixel.FlxG;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.phys.Material;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.dynamics.InteractionFilter;
import nape.callbacks.CbType;

class Level
{
	private var levelNumber:Int;
	private var xml:Xml;
	private var levelXML:Fast;
	
	public function new(lNum:Int = 1)
	{
		levelNumber = lNum;
		createLevelObjects(lNum);
		
	}
	private function createLevelObjects(lNum):Void
	{
		//OGMO
		//Load XML
		var lvlString:String = "assets/levels/level" + Std.string(lNum) + ".oel";
		xml = Parser.parse(Assets.getText(lvlString));
		levelXML = new Fast(xml.firstElement());
		
		//Set Credits **FIXED NUMBER NOW**
		Registry.maxCredits = Std.parseInt(levelXML.att.credits);
		
		//Add objects to level
		var objects = levelXML.node.resolve("Objects");
		var goal:Goal;
		for ( o in objects.elements ) 
		{
			if (o.name == "Goal")
			{
				//Position Goal
				goal = new Goal(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.hitsNeeded));
				Registry.goals.add(goal);
			}
			else if (o.name == "Cannon")
			{
				//Position Cannon
				var ang:Float = Std.parseFloat(o.att.angle) * 57.295;
				Registry.cannon = new Cannon(Std.parseInt(o.att.x) - 47, Std.parseInt(o.att.y) - 58, ang);
				//Registry.cannon.x = Std.parseInt(o.att.x) - 47;
				//Registry.cannon.y = Std.parseInt(o.att.y) - 58;
				//Registry.cannon.angle = ang;
				
				//Position Emitter
				var aRad:Float = ang * (Math.PI / 180);
				var dx = Math.cos(aRad);
				var dy = Math.sin(aRad);
				Registry.cannon.emit.x = Registry.cannon.x + 47 + dx * 35;
				Registry.cannon.emit.y = Registry.cannon.y + 58 + dy * 35;
			}
			else if (o.name == "deathwall1" || o.name == "deathwall2"|| o.name == "deathwall3" || o.name == "deathwall4")
			{
				var ang:Float = Std.parseFloat(o.att.angle) * 57.295;
				var dWall = new DeathWall(Std.parseInt(o.att.x), Std.parseInt(o.att.y), ang, o.name);
				Registry.hazards.add(dWall);
			}
			else if (o.name == "wallbump")
			{
				var wBump = new FlxPhysSprite(Std.parseInt(o.att.x), Std.parseInt(o.att.y), "assets/wallbump.png");
				wBump.body = new Body();
				wBump.body.shapes.add(new Polygon([  Vec2.weak(-8, -20),  Vec2.weak(8, -20),  Vec2.weak( 18, -8),  Vec2.weak(18, 8),  Vec2.weak(8, 18),  Vec2.weak(-8, 18),  Vec2.weak(-19, 8),  Vec2.weak(-19, -8)   ]));
				var mats:Material = new Material(.95, 0, 0, 1, 0);
				wBump.body.setShapeMaterials(mats);
				var bumpFilter:InteractionFilter = new InteractionFilter();
				bumpFilter.collisionGroup = 4;
				bumpFilter.collisionMask = 2;
				wBump.body.setShapeFilters(bumpFilter);
				wBump.body.position.x = Std.parseInt(o.att.x);
				wBump.body.position.y = Std.parseInt(o.att.y);
				wBump.body.type = BodyType.STATIC;
				wBump.body.space = FlxPhysState.space;
				wBump.body.cbTypes.add(Registry.WALL);
				Registry.bumps.add(wBump);
			}
			else if (o.name == "corner")
			{
				//Broken into 3 shapes due to concave features
				var corner = new FlxPhysSprite(Std.parseInt(o.att.x), Std.parseInt(o.att.y), "assets/corner.png");
				corner.body = new Body();
				corner.body.shapes.add(new Polygon([  Vec2.weak( -15, -28),  Vec2.weak( -4, -17),  Vec2.weak( -4, -10), Vec2.weak( -5, 0), Vec2.weak( -15, -10)])); 
				corner.body.shapes.add(new Polygon([  Vec2.weak( -5, 0), Vec2.weak( -4, -10), Vec2.weak( 3, -10), Vec2.weak( 14, 0), Vec2.weak( 3, 10), Vec2.weak( -4, 10)]));
				corner.body.shapes.add(new Polygon([  Vec2.weak( -15, 28),  Vec2.weak( -4, 17),  Vec2.weak( -4, 10), Vec2.weak( -5, 0), Vec2.weak( -15, 10)]));
				var mats:Material = new Material(.95, 0, 0, 1, 0);
				corner.body.setShapeMaterials(mats);
				var cornerFilter:InteractionFilter = new InteractionFilter();
				cornerFilter.collisionGroup = 4;
				cornerFilter.collisionMask = 2;
				corner.body.setShapeFilters(cornerFilter);
				corner.body.position.x = Std.parseInt(o.att.x);
				corner.body.position.y = Std.parseInt(o.att.y);
				corner.body.rotation = Std.parseFloat(o.att.angle);
				corner.body.type = BodyType.STATIC;
				corner.body.space = FlxPhysState.space;
				corner.antialiasing = true;
				corner.body.cbTypes.add(Registry.WALL);
				Registry.corners.add(corner);
			}
			else if (o.name == "levelbar1" || o.name == "levelbar2" || o.name == "levelbar3" || o.name == "levelbar4")
			{
				var levelbar = new FlxPhysSprite(Std.parseInt(o.att.x), Std.parseInt(o.att.y), "assets/" + o.name + ".png");
				levelbar.body = new Body();
				switch(o.name)
				{
					case "levelbar1":
						levelbar.body.shapes.add(new Polygon([  Vec2.weak( -144, 7), Vec2.weak( -144, -7), Vec2.weak( -133, -18),  Vec2.weak( 133, -18),  Vec2.weak( 144, -7), Vec2.weak( 144, 7), Vec2.weak( 133, 17), Vec2.weak( -133, 17)]));
					case "levelbar2":
						levelbar.body.shapes.add(new Polygon([  Vec2.weak( -188, 7), Vec2.weak( -188, -7), Vec2.weak( -177, -18),  Vec2.weak( 177, -18),  Vec2.weak( 188, -7), Vec2.weak( 188, 7), Vec2.weak( 177, 17), Vec2.weak( -177, 17)]));
					case "levelbar3":
						levelbar.body.shapes.add(new Polygon([  Vec2.weak( -240, 7), Vec2.weak( -240, -7), Vec2.weak( -229, -18),  Vec2.weak( 229, -18),  Vec2.weak( 240, -7), Vec2.weak( 240, 7), Vec2.weak( 229, 17), Vec2.weak( -229, 17)]));
					case "levelbar4":
						levelbar.body.shapes.add(new Polygon([  Vec2.weak( -291, 7), Vec2.weak( -291, -7), Vec2.weak( -280, -18),  Vec2.weak( 280, -18),  Vec2.weak( 291, -7), Vec2.weak( 291, 7), Vec2.weak( 280, 17), Vec2.weak( -280, 17)]));
					default:
						FlxG.log("INVALID LEVEL BAR");
				}
				//levelbar.body.shapes.add(new Polygon([  Vec2.weak( -15, -28),  Vec2.weak( -4, -17),  Vec2.weak( -4, -10), Vec2.weak( -5, 0), Vec2.weak( -15, -10)]));
				var mats:Material = new Material(.95, 0, 0, 1, 0);
				levelbar.body.setShapeMaterials(mats);
				var barFilter:InteractionFilter = new InteractionFilter();
				barFilter.collisionGroup = 4;
				barFilter.collisionMask = 2;
				levelbar.body.setShapeFilters(barFilter);
				levelbar.body.position.x = Std.parseInt(o.att.x);
				levelbar.body.position.y = Std.parseInt(o.att.y);
				levelbar.body.rotation = Std.parseFloat(o.att.angle);
				levelbar.body.type = BodyType.STATIC;
				levelbar.body.space = FlxPhysState.space;
				levelbar.antialiasing = true;
				levelbar.body.cbTypes.add(Registry.WALL);
				Registry.bumps.add(levelbar);
			}
			else if (o.name == "levelobject1" || o.name == "levelobject2" || o.name == "levelobject3" || o.name == "levelobject4")
			{
				//Broken into 3 shapes due to concave features
				var levelobject = new FlxPhysSprite(Std.parseInt(o.att.x), Std.parseInt(o.att.y), "assets/" + o.name + ".png");
				levelobject.body = new Body();
				switch(o.name)
				{
					case "levelobject1":
						levelobject.body.shapes.add(new Polygon([  Vec2.weak( -21, 10), Vec2.weak( -21, -10), Vec2.weak( -10, -21),  Vec2.weak( 10, -21),  Vec2.weak( 21, -10), Vec2.weak( 21, 10), Vec2.weak( 10, 21), Vec2.weak( -10, 21)]));
					case "levelobject2":
						levelobject.body.shapes.add(new Polygon([  Vec2.weak( -33, 14), Vec2.weak( -33, -14), Vec2.weak( -14, -33),  Vec2.weak( 14, -33),  Vec2.weak( 33, -14), Vec2.weak( 33, 14), Vec2.weak( 14, 33), Vec2.weak( -14, 33)]));
					case "levelobject3":
						levelobject.body.shapes.add(new Polygon([  Vec2.weak( -50, 20), Vec2.weak( -50, -20), Vec2.weak( -20, -50),  Vec2.weak( 20, -50),  Vec2.weak( 50, -20), Vec2.weak( 50, 20), Vec2.weak( 20, 50), Vec2.weak( -20, 50)]));
					case "levelobject4":
						levelobject.body.shapes.add(new Polygon([  Vec2.weak( -76, 32), Vec2.weak( -76, -32), Vec2.weak( -31, -75),  Vec2.weak( 30, -75),  Vec2.weak( 74, -32), Vec2.weak( 74, 32), Vec2.weak( 30, 75), Vec2.weak( -31, 75)]));
					default:
						FlxG.log("INVALID LEVEL OBJECT");
				}
				//levelbar.body.shapes.add(new Polygon([  Vec2.weak( -15, -28),  Vec2.weak( -4, -17),  Vec2.weak( -4, -10), Vec2.weak( -5, 0), Vec2.weak( -15, -10)]));
				var mats:Material = new Material(.95, 0, 0, 1, 0);
				levelobject.body.setShapeMaterials(mats);
				var objectFilter:InteractionFilter = new InteractionFilter();
				objectFilter.collisionGroup = 4;
				objectFilter.collisionMask = 2;
				levelobject.body.setShapeFilters(objectFilter);
				levelobject.body.position.x = Std.parseInt(o.att.x);
				levelobject.body.position.y = Std.parseInt(o.att.y);
				//levelobject.body.rotation = Std.parseFloat(o.att.angle);
				levelobject.body.type = BodyType.STATIC;
				levelobject.body.space = FlxPhysState.space;
				levelobject.antialiasing = true;
				levelobject.body.cbTypes.add(Registry.WALL);
				Registry.bumps.add(levelobject);
			}
		}
	}
}