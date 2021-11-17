package;

import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.phys.BodyType;
import nape.util.Debug;
import nape.util.ShapeDebug;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.geom.ColorTransform;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSave;
import org.flixel.FlxSound;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxSprite;
import nme.ui.Mouse;
import nape.dynamics.InteractionFilter;
import nape.callbacks.CbType;
import nape.callbacks.PreListener;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nme.Assets;
import nape.geom.Geom;
import browser.display.BlendMode;

class PlayState extends FlxPhysState
{
	private var testText:FlxText;
	private var registry:Registry;
	public var levelLayout:FlxSprite;
	public var cannon:Cannon;
	private var wallButton:PlayerWall;
	private var wedgeButton:PlayerWedge;
	private var superWedgeButton:SuperWedge;
	private var wellButton:GravityWell;
	private var owWallButton:OneWayWall;
	private var moverButton:Mover;
	private var mouse:Mouse;
	private var pauseScreen:PauseScreen;
	public var levelNumber:Int;
	private var levelComplete:Bool;
	private var creditsText:FlxText;
	public var credits:Int;
	private var sellButton:FlxSprite;
	public static var ballSnd:FlxSound = new FlxSound();
	public static var goalSnd:FlxSound = new FlxSound();
	public static var dWallBallSnd:FlxSound = new FlxSound();
	private var creditCostLabel:FlxGroup;
	private var shotsTaken:Int;
	private var overlay:FlxSprite;
	private var speederButton:Speeder;
	private var validPlacement:Bool;
	private var invalidText:FlxText;
	private var screenFlashBit:FlxSprite;
	private var howToPlay:FlxSprite;
	private var readyButton:CustomButton;
	
	public function new(lNum:Int=1)
	{
		super();
		levelNumber = lNum;
		if (FlxG.paused)
		{
			FlxG.paused = false;
		}
	}
	override public function create():Void
	{
		super.create();
		#if !neko
		FlxG.bgColor = 0xFF212121;
		#else
		FlxG.camera.bgColor = {rgb: 0x212121, a: 0xff};
		#end
		
		Registry.init(levelNumber, this);
		FlxG.sounds.maxSize = 20;
		//Registry.cannon.canFire = true;
		levelComplete = false;
		shotsTaken = 0;
		validPlacement = true;
		
		//Version Text
		//testText = new FlxText(3, 2, 395, "Press 'SPACE' to fire, 'R' to reset, 'ESC' for main menu.");
		//testText.color = 0xff111111;
		//testText.alignment = "left";
		//testText.size = 12;
		
		//Player Tray
		var tray:FlxSprite = new FlxSprite(0, 0, "assets/itemtray.png");
		
		//NAPE Setup
		FlxPhysState.space.gravity = new Vec2(0, 0);
		FlxPhysState.space.worldLinearDrag = .01;
		FlxPhysState.space.worldAngularDrag = .1;
		
		//Overlay
		overlay = new FlxSprite(0, 0, "assets/overlay6.png");
		
		//OneWayWall Button
		owWallButton = new OneWayWall(612, 55, 270);
		//owWallButton.body.position.x = 612; //+ owWallButton.width / 2;
		//owWallButton.body.position.y = 55; //+ owWallButton.height / 2;
		owWallButton.body.type = BodyType.STATIC;
		var owWallFilter:InteractionFilter = new InteractionFilter();
		owWallFilter.collisionGroup = 0;
		owWallFilter.collisionMask = 0;
		owWallButton.alive = false;
		owWallButton.body.setShapeFilters(owWallFilter);
		
		//Speeder Button
		speederButton = new Speeder(721, 56, 270);
		//speederButton.body.position.x = 703 + speederButton.width / 2;
		//speederButton.body.position.y = 38 + speederButton.height / 2;
		speederButton.body.type = BodyType.STATIC;
		var speederFilter:InteractionFilter = new InteractionFilter();
		speederFilter.collisionGroup = 0;
		speederFilter.collisionMask = 0;
		speederButton.alive = false;
		speederButton.body.setShapeFilters(speederFilter);
		
		//SuperWedge Button
		superWedgeButton = new SuperWedge(821, 55, 180);
		//superWedgeButton.body.position.x = 780 - superWedgeButton.width / 2;
		superWedgeButton.body.type = BodyType.STATIC;
		var superWedgeFilter:InteractionFilter = new InteractionFilter();
		superWedgeFilter.collisionGroup = 0;
		superWedgeFilter.collisionMask = 0;
		superWedgeButton.alive = false;
		superWedgeButton.body.setShapeFilters(superWedgeFilter);
		
		//Mover Button
		moverButton = new Mover(927, 53, 270);
		//moverButton.body.position.x = 910 - moverButton.width / 2;
		moverButton.body.type = BodyType.STATIC;
		var moverFilter:InteractionFilter = new InteractionFilter();
		moverFilter.collisionGroup = 0;
		moverFilter.collisionMask = 0;
		moverButton.alive = false;
		moverButton.body.setShapeFilters(moverFilter);
		
		//Wall Button
		wallButton = new PlayerWall(1037, 54, 90);
		//wallButton.body.position.x = 989 - wallButton.width / 2;
		wallButton.body.type = BodyType.STATIC;
		var wallFilter:InteractionFilter = new InteractionFilter();
		wallFilter.collisionGroup = 0;
		wallFilter.collisionMask = 0;
		wallButton.alive = false;
		wallButton.body.setShapeFilters(wallFilter);
	
		//FlxG.mouse.load("assets/cursor.png");
		//FlxG.mouse.hide();
		//Mouse.show();
		
		//Available Credits Text
		var cLabelText:FlxText = new FlxText(1191, 69, 75, "credits",true);
		cLabelText.setFormat("assets/blutter", 14, 0xe5e5e5, "left");
		credits = Registry.maxCredits;
		creditsText = new FlxText(1182, 74, 88, Std.string(Registry.maxCredits),true);
		creditsText.setFormat("assets/blutter", 56, 0xBCD122, "center");
		//Sell Button
		sellButton = new FlxSprite(1187, 132, "assets/sell.png");
		//Clear Level Button
		var clearButton = new CustomButton(1190, 43, clearLevel, "assets/clear.png", "assets/clearover.png");
		//Pause Screen
		pauseScreen = new PauseScreen();
		//Goal Lines
		//var goalLines:FlxSprite = new FlxSprite(0, 0, "assets/shell1wires.png");
		
		//**Credit Cost Labels
		creditCostLabel = new FlxGroup(15);
		//Wall
		var wallCost:FlxText = new FlxText(1059, 35, 49, Std.string(wallButton.cost), true);
		wallCost.setFormat("assets/blutter", 24, 0xe5e5e5, "right");
		wallCost.visible = false;
		creditCostLabel.add(wallCost);
		var crText:FlxText = new FlxText(wallCost.x + wallCost.width - 3, 0, 100, "cr", true);
		crText.setFormat("assets/blutter", 13, 0xe5e5e5, "left");
		crText.y = wallCost.y + wallCost.height - crText.height - 3;
		crText.visible = false;
		creditCostLabel.add(crText);
		var wallPop:FlxSprite = new FlxSprite(647, 98, "assets/wallinfo.png");
		wallPop.visible = false;
		creditCostLabel.add(wallPop);
		//Wedge
		var wedgeCost:FlxText = new FlxText(753, 15, 49, Std.string(superWedgeButton.cost), true);
		wedgeCost.setFormat("assets/blutter", 24, 0xe5e5e5, "right");
		wedgeCost.visible = false;
		creditCostLabel.add(wedgeCost);
		crText = new FlxText(wedgeCost.x + wedgeCost.width - 3, 0, 100, "cr", true);
		crText.setFormat("assets/blutter", 13, 0xe5e5e5, "left");
		crText.y = wedgeCost.y + wedgeCost.height - crText.height - 2;
		crText.visible = false;
		creditCostLabel.add(crText);
		var wedgePop:FlxSprite = new FlxSprite(647, 98, "assets/wedgeinfo.png");
		wedgePop.visible = false;
		creditCostLabel.add(wedgePop);
		//One Way Wall
		var owWallCost:FlxText = new FlxText(492, 36, 49, Std.string(owWallButton.cost), true);
		owWallCost.setFormat("assets/blutter", 24, 0xe5e5e5, "right");
		owWallCost.visible = false;
		creditCostLabel.add(owWallCost);
		crText = new FlxText(owWallCost.x + owWallCost.width - 3, 0, 100, "cr", true);
		crText.setFormat("assets/blutter", 13, 0xe5e5e5, "left");
		crText.y = owWallCost.y + owWallCost.height - crText.height  - 2;
		crText.visible = false;
		creditCostLabel.add(crText);
		var owPop:FlxSprite = new FlxSprite(647, 98, "assets/onewaywallinfo.png");
		owPop.visible = false;
		creditCostLabel.add(owPop);
		//Mover
		var moverCost:FlxText = new FlxText(934, 12, 49, Std.string(moverButton.cost), true);
		moverCost.setFormat("assets/blutter", 24, 0xe5e5e5, "right");
		moverCost.visible = false;
		creditCostLabel.add(moverCost);
		crText = new FlxText(moverCost.x + moverCost.width - 3, 0, 100, "cr", true);
		crText.setFormat("assets/blutter", 13, 0xe5e5e5, "left");
		crText.y = moverCost.y + moverCost.height - crText.height - 2;
		crText.visible = false;
		creditCostLabel.add(crText);
		var moverPop:FlxSprite = new FlxSprite(647, 98, "assets/hardturninfo.png");
		moverPop.visible = false;
		creditCostLabel.add(moverPop);
		//Speeder
		var speederCost:FlxText = new FlxText(648, 12, 49, Std.string(speederButton.cost), true);
		speederCost.setFormat("assets/blutter", 24, 0xe5e5e5, "right");
		speederCost.visible = false;
		creditCostLabel.add(speederCost);
		crText = new FlxText(speederCost.x + speederCost.width - 3, 0, 100, "cr", true);
		crText.setFormat("assets/blutter", 13, 0xe5e5e5, "left");
		crText.y = speederCost.y + speederCost.height - crText.height - 2;
		crText.visible = false;
		creditCostLabel.add(crText);
		var speederPop:FlxSprite = new FlxSprite(647, 98, "assets/speedboostinfo.png");
		speederPop.visible = false;
		creditCostLabel.add(speederPop);
		
		//INVALID text
		invalidText = new FlxText(0, 0, 1280, "INVALID PLACEMENT", true);
		invalidText.setFormat("assets/blutter", 240, 0xFF0000, "center");
		invalidText.y = 360 - invalidText.height / 2;
		invalidText.visible = false;
		//invalidText.visible = true;
		
		//Screen Flash
		screenFlashBit = new FlxSprite(0, 0);
		screenFlashBit.makeGraphic(1280, 1024, 0xffffffff);
		screenFlashBit.visible = false;
		screenFlashBit.alpha = 0;
		
		//Launch Button
		var launchButton:CustomButton = new CustomButton(1042, 108, onLaunchButton, "assets/launch.png", "assets/launchdown.png");
		
		
		
		//Add objects to display
		add(Registry.bumps);
		add(Registry.hazards);
		add(Registry.levelBody);
		add(Registry.corners);
		add(tray);
		//add(goalLines);
		//add(testText);
		add(Registry.goals);
		add(Registry.particles);
		add(Registry.ballTrails);
		add(cLabelText);
		add(creditsText);
		add(sellButton);
		add(clearButton);
		add(wallButton);
		//add(wedgeButton);
		add(owWallButton);
		//add(wellButton);
		add(moverButton);
		add(speederButton);
		add(superWedgeButton);
		add(Registry.shotManager);
		add(Registry.cannon);
		add(Registry.objects);
		add(creditCostLabel);
		add(launchButton);
		add(invalidText);
		add(screenFlashBit);
		add(overlay);
		
		//Level 1 instructions screen
		if (levelNumber == 1)
		{
			howToPlay = new FlxSprite(0, 0, "assets/howtoplay.png");
			add(howToPlay);
			readyButton = new CustomButton(267, 662, ready, "assets/ready.png", "assets/readydown.png");
			add(readyButton);
		}
		
		disablePhysDebug();
	}
	override public function update():Void
	{
		if (FlxG.paused == false)
		{
			super.update();
			pieceControl();
			if (invalidText.alpha > 0)
			{
				invalidText.alpha *= .94;
				if (invalidText.alpha < .04)
				{
					invalidText.visible = false;
				}
			}
			if (screenFlashBit.alpha > 0)
			{
				screenFlashBit.alpha *= .7;
				if (screenFlashBit.alpha < .04)
				{
					screenFlashBit.visible = false;
				}
			}
			//Ball/Goal Collision
			FlxG.overlap(Registry.goals, Registry.shotManager, overlapped);
			//Firing
			//Registry.canFire = true;
			if (Registry.handJoint.active)
			{
				var invalid:Bool = false;
				//var obj:Dynamic = null;
				FlxPhysState.space.bodies.foreach(function(b:Body) 
				{
					var obj:Body = b;
					if (obj.isStatic())
					{
						if (Geom.intersectsBody(Registry.handJoint.body2, obj))
						{
							colorRed();
							invalid = true;
						}
					}
				});
				if (!invalid)
				{
					if (Registry.handJoint.body2.userData.sprite._colorTransform != null)
					{
						Registry.handJoint.body2.userData.sprite._colorTransform = null;
						Registry.handJoint.body2.userData.sprite.calcFrame();
						validPlacement = true;
					}
				}
			}
			costDisplay();
		}
		else
		{
			pauseScreen.update();
		}
		keyControl();
	}
	private function colorRed():Void
	{
		Registry.handJoint.body2.userData.sprite._colorTransform = new ColorTransform(1, 1, 1, 1, 100, -185, -185, 0);
		Registry.handJoint.body2.userData.sprite.calcFrame();
		validPlacement = false;
	}
	private function screenFlash():Void
	{
		screenFlashBit.visible = true;
		screenFlashBit.alpha = 1;
	}
	public function overlapped(Object1:FlxObject , Object2:FlxObject):Void
	{
		if (Std.is(Object1, Goal))
		{
			var goal:Goal = cast(Object1, Goal);
			if (goal.complete == false)
			{
				goal.hit();
				Object2.kill();
				//Check for WIN
				if (!levelComplete)
				{
					if (Registry.goals.members.length > 0)
					{
						var complete = true;
						for (i in Registry.goals.members)
						{
							var goal = cast(i, Goal);
							if (goal.complete == false)
							{
								complete = false;
							}
						}
						if (complete)
						{
							levelComplete = true;
							if (levelNumber < 10)
							{
								FlxG.switchState(new LevelTransition(levelNumber, credits, shotsTaken, Registry.cannon.shots - Registry.shotManager.countLiving()));
							}
							else
							{
								screenFlash();
								FlxG.switchState(new GameComplete(credits, shotsTaken, Registry.cannon.shots - Registry.shotManager.countLiving()));
							}
							save();
						}
					}
				}
			}
		}
	}
	function mouseDown():Void 
	{
        // Allocate a Vec2 from object pool.
		var mousePoint = Vec2.get(FlxG.mouse.x, FlxG.mouse.y);
        // Determine the set of Body's which are intersecting mouse point.
        // And search for any 'dynamic' type Body to begin dragging.
		for (body in FlxPhysState.space.bodiesUnderPoint(mousePoint)) {
			if (body == wallButton.body  && credits >= wallButton.cost) 
			{
				var newWall:PlayerWall = new PlayerWall(wallButton.x, wallButton.y, Std.int(wallButton.body.rotation * 57.29577));
				newWall.body.position.setxy(wallButton.body.position.x, wallButton.body.position.y);
				newWall.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(newWall.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = newWall.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
				newWall.body.userData.sprite = newWall;
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(newWall);
				credits -= newWall.cost;
				retry();
				//break;
			}
			/*else if (body == wedgeButton.body)
			{
				//trace("anchor new");
				var newWedge:PlayerWedge = new PlayerWedge(wedgeButton.x, wedgeButton.y, Std.int(wedgeButton.body.rotation * 57.29577));
				newWedge.body.position.setxy(wedgeButton.body.position.x, wedgeButton.body.position.y);
				newWedge.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(newWedge.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = newWedge.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(newWedge);
				break;
			}*/
			/*else if (body == wellButton.body)
			{
				var newWell:GravityWell = new GravityWell(wellButton.x, wellButton.y, Std.int(wellButton.body.rotation * 57.29577));
				newWell.body.position.setxy(wellButton.body.position.x, wellButton.body.position.y);
				newWell.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(newWell.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = newWell.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(newWell);
				break;
			}*/
			else if (body == owWallButton.body && credits >= owWallButton.cost)
			{
				var owWall:OneWayWall = new OneWayWall(owWallButton.x, owWallButton.y, Std.int(owWallButton.body.rotation * 57.29577));
				owWall.body.position.setxy(owWallButton.body.position.x, owWallButton.body.position.y);
				owWall.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(owWall.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = owWall.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
				owWall.body.userData.sprite = owWall;
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(owWall);
				credits -= owWall.cost;
				retry();
				//break;
			}
			else if (body == moverButton.body && credits >= moverButton.cost)
			{
				var mover:Mover = new Mover(moverButton.x, moverButton.y, Std.int(moverButton.body.rotation * 57.29577));
				mover.body.position.setxy(moverButton.body.position.x, moverButton.body.position.y);
				mover.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(mover.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = mover.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
				mover.body.userData.sprite = mover;
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(mover);
				credits -= mover.cost;
				retry();
			}
			else if (body == superWedgeButton.body && credits >= superWedgeButton.cost)
			{
				var newSuperWedge:SuperWedge = new SuperWedge(superWedgeButton.x, superWedgeButton.y, Std.int(superWedgeButton.body.rotation * 57.29577));
				newSuperWedge.body.position.setxy(superWedgeButton.body.position.x, superWedgeButton.body.position.y);
				newSuperWedge.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(newSuperWedge.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = newSuperWedge.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
				newSuperWedge.body.userData.sprite = newSuperWedge;
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(newSuperWedge);
				credits -= newSuperWedge.cost;
				retry();
				//break;
			}
			else if (body == speederButton.body && credits >= speederButton.cost)
			{
				var speeder:Speeder = new Speeder(speederButton.x, speederButton.y, Std.int(speederButton.body.rotation * 57.29577));
				speeder.body.position.setxy(speederButton.body.position.x, speederButton.body.position.y);
				speeder.body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(speeder.body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = speeder.body;
				Registry.handJoint.anchor1.setxy(mousePoint.x, mousePoint.y);
				speeder.body.userData.sprite = speeder;
 
				// Enable hand joint!
				Registry.handJoint.active = true;
				Registry.objects.add(speeder);
				credits -= speeder.cost;
				retry();
				//break;
			}
			if(!body.isStatic())
			{
				//FlxG.log("grabbing");
				body.type = BodyType.DYNAMIC;
				Registry.handJoint.anchor2.set(body.worldPointToLocal(mousePoint, true));
				Registry.handJoint.body2 = body;
				Registry.handJoint.anchor1.setxy(FlxG.mouse.x, FlxG.mouse.y);
				// Enable hand joint!
				Registry.handJoint.active = true;
				retry();
				break;
			}
			else
			{
				setCreditsText();
			}
			//creditsText.setText(Std.string(credits));
		}
        // Release Vec2 back to object pool.
        mousePoint.dispose();
    }
	private function setCreditsText():Void
	{
		creditsText.setText(Std.string(credits));
	}
	function mouseUp():Void 
	{
		//retry();
		if (Registry.handJoint.active)
		{
			//FlxG.log("deactivate handjoint");
			Registry.handJoint.active = false;
			Registry.handJoint.body2.type = BodyType.KINEMATIC;
			if (sellButton.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				var obj:Dynamic = null;
				for (i in Registry.objects.members)
				{
					obj = i;
					if (Registry.handJoint.body2 == obj.body)
					{
						obj.kill();
						credits += obj.cost;
						validPlacement = true;
					}
				}
				creditsText.setText(Std.string(credits));
			}
		}
    }
	private function pieceControl():Void
	{
		//Update Hand Joint if it's active
		if (Registry.handJoint.active) 
		{
			Registry.handJoint.anchor1.setxy(FlxG.mouse.x, FlxG.mouse.y);
		}
		//Mouse Control
		if (FlxG.mouse.justPressed())
		{
			mouseDown();
		}
		if (FlxG.mouse.justReleased())
		{
			mouseUp();
		}
	}
	private function keyControl():Void
	{
		if (FlxG.keys.justPressed("R"))
		{
			retry();
		}
		if (FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("P"))
		{
			if (FlxG.paused == false)
			{
				FlxG.paused = true;
				add(pauseScreen);
			}
			else
			{
				FlxG.paused = false;
				remove(pauseScreen);
				pauseScreen.remove(pauseScreen.levelsScreen);
				pauseScreen.remove(pauseScreen.helpScreen);
			}
		}
		//Developer Key
		/*if (FlxG.keys.justPressed("T"))
		{
			levelComplete = true;
			if (levelNumber < 10)
			{
				FlxG.switchState(new LevelTransition(levelNumber, credits, shotsTaken, Registry.cannon.shots - Registry.shotManager.countLiving()));
			}
			else
			{
				screenFlash();
				FlxG.switchState(new GameComplete(credits, shotsTaken, Registry.cannon.shots - Registry.shotManager.countLiving()));
			}
			save();
			//var ff:FlxSpecialFX = new GlitchFX();
			//ff.
		}*/
		if (FlxG.keys.justPressed("SPACE"))
		{
			if (validPlacement == true)
			{
				Registry.cannon.fire();
				shotsTaken ++;
			}
			else
			{
				invalidText.visible = true;
				invalidText.alpha = 1;
			}
		}
	}
	public function retry():Void
	{
		if (Registry.shotManager.countLiving() > 0)
		{
			//FlxG.log("flash");
			screenFlash();
			Registry.shotManager.callAll("kill", false);
		}
		//Registry.cannon.canFire = true;
		Registry.goals.callAll("resetHits", false);
	}
	private function clearLevel():Void
	{
		screenFlash();
		//Registry.cannon.canFire = true;
		var obj:Dynamic = null;
		for (i in Registry.objects.members)
		{
			//FlxG.log("killed object");
			obj = i;
			obj.kill();
		}
		credits = Registry.maxCredits;
		setCreditsText();
		Registry.goals.callAll("resetHits", false);
		Registry.shotManager.callAll("kill", false);
	}
	private function costDisplay():Void
	{
		var mousePoint = Vec2.get(FlxG.mouse.x, FlxG.mouse.y);
		if (mousePoint.x > 550 && mousePoint.y < 200)
		{
			var found:Bool = false;
			for (body in FlxPhysState.space.bodiesUnderPoint(mousePoint)) 
			{
				if (body == wallButton.body) 
				{
					if (wallButton.hover == false)
					{
						wallButton.hover = true;
						creditCostLabel.members[0].visible = true;
						creditCostLabel.members[1].visible = true;
						creditCostLabel.members[2].visible = true;
					}
					found = true;
				}
				else
				{
					if (found == false)
					{
						if (wallButton.hover)
						{
							wallButton.hover = false;
							creditCostLabel.members[0].visible = false;
							creditCostLabel.members[1].visible = false;
							creditCostLabel.members[2].visible = false;
						}
					}
				}
				if (body == superWedgeButton.body) 
				{
					if (superWedgeButton.hover == false)
					{
						superWedgeButton.hover = true;
						creditCostLabel.members[3].visible = true;
						creditCostLabel.members[4].visible = true;
						creditCostLabel.members[5].visible = true;
					}
					found = true;
				}
				else
				{
					if (found == false)
					{
						if (superWedgeButton.hover)
						{
							superWedgeButton.hover = false;
							creditCostLabel.members[3].visible = false;
							creditCostLabel.members[4].visible = false;
							creditCostLabel.members[5].visible = false;
						}
					}
				}
				if (body == owWallButton.body) 
				{
					if (owWallButton.hover == false)
					{
						owWallButton.hover = true;
						creditCostLabel.members[6].visible = true;
						creditCostLabel.members[7].visible = true;
						creditCostLabel.members[8].visible = true;
					}
					found = true;
				}
				else
				{
					if (found == false)
					{
						if (owWallButton.hover)
						{
							owWallButton.hover = false;
							creditCostLabel.members[6].visible = false;
							creditCostLabel.members[7].visible = false;
							creditCostLabel.members[8].visible = false;
						}
					}
				}
				if (body == moverButton.body) 
				{
					if (moverButton.hover == false)
					{
						moverButton.hover = true;
						creditCostLabel.members[9].visible = true;
						creditCostLabel.members[10].visible = true;
						creditCostLabel.members[11].visible = true;
					}
					found = true;
				}
				else
				{
					if (found == false)
					{
						if (moverButton.hover)
						{
							moverButton.hover = false;
							creditCostLabel.members[9].visible = false;
							creditCostLabel.members[10].visible = false;
							creditCostLabel.members[11].visible = false;
						}
					}
				}
				if (body == speederButton.body) 
				{
					if (speederButton.hover == false)
					{
						speederButton.hover = true;
						creditCostLabel.members[12].visible = true;
						creditCostLabel.members[13].visible = true;
						creditCostLabel.members[14].visible = true;
					}
					found = true;
				}
				else
				{
					if (found == false)
					{
						if (speederButton.hover)
						{
							speederButton.hover = false;
							creditCostLabel.members[12].visible = false;
							creditCostLabel.members[13].visible = false;
							creditCostLabel.members[14].visible = false;
						}
					}
				}
			}
		}
		mousePoint.dispose();
	}
	private function save():Void
	{
		if (levelNumber + 1 <= Registry.numLevels && FlxG.saves[0].data.levelsUnlocked < levelNumber + 1)
		{
			FlxG.saves[0].data.levelsUnlocked = levelNumber + 1;
		}
	}
	private function onLaunchButton():Void
	{
		if (validPlacement == true)
		{
			Registry.cannon.fire();
			shotsTaken ++;
		}
		else
		{
			invalidText.visible = true;
			invalidText.alpha = 1;
		}
	}
	private function ready()
	{
		remove(howToPlay);
		remove(readyButton);
	}
}