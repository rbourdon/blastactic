package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;

class MenuState extends FlxState
{
	public var playButton:CustomButton;
	public var creditsButton:CustomButton;
	//public var optionsButton:CustomButton;
	public var helpButton:CustomButton;
	public var homeScreen:FlxGroup;
	//private var optionsScreen:FlxGroup;
	private var helpScreen:FlxGroup;
	private var creditsScreen:FlxGroup;
	private var levelsScreen:LevelLoader;
	//private var backButton:CustomButton;
	private var homeButtons:FlxGroup;
	
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xffcccccc;
		#else
		FlxG.camera.bgColor = {rgb: 0xcccccc, a: 0xff};
		#end		
		FlxG.mouse.load("assets/cursor.png");
		FlxG.mouse.show();
		//Save Data
		var gameSave = new FlxSave();
		gameSave.bind("Blastactic");
		FlxG.saves = new Array();
		FlxG.saves.push(gameSave);
		if (gameSave.data.levelsUnlocked == null)
		{
			var l:Int = 1;
			gameSave.data.levelsUnlocked = l;
			//FlxG.levels[0] = gameSave.data.levelsUnlocked;
		}
		//Create Different Menu Screens
		homeScreen = new FlxGroup();
		creditsScreen = new FlxGroup();
		helpScreen = new FlxGroup();
		//optionsScreen = new FlxGroup();
		levelsScreen = new LevelLoader(this);
		var bg:FlxSprite = new FlxSprite();
		
		//**HOME
		bg = new FlxSprite(0, 0, "assets/home_screen.png");
		homeScreen.add(bg);
		//**CREDITS
		bg = new FlxSprite(0, 0, "assets/credits_screen.png");
		creditsScreen.add(bg);
		//**HELP
		bg = new FlxSprite(0, 0, "assets/help_screen.png");
		helpScreen.add(bg);
		
		homeButtons = new FlxGroup(3);
		//Help Button
		helpButton = new CustomButton(FlxG.width/2 - 200 - 200, FlxG.height / 2 + 10, onHelp, "assets/help.png", "assets/helpdown.png" ,null, false,homeButtons,2);
		homeButtons.add(helpButton);
		//Credits Button
		creditsButton = new CustomButton(FlxG.width/2 + 200, FlxG.height / 2 + 10, onCredits, "assets/credits.png", "assets/creditsdown.png", null, false,homeButtons,2);
		homeButtons.add(creditsButton);
		//Options Button
		//optionsButton = new CustomButton(FlxG.width/2, FlxG.height / 2 + 130, onOptions, "assets/options.png", "assets/optionsdown.png",null,false,homeButtons);
		//homeButtons.add(optionsButton);
		//Play Button
		playButton = new CustomButton(FlxG.width/2 - 144, FlxG.height / 2 - 35, onPlay, "assets/play.png",  "assets/playdown.png", null, true, homeButtons,1);
		homeButtons.add(playButton);
		homeScreen.add(homeButtons);
		
		//BackButtons
		var backButton = new CustomButton(FlxG.width / 2 - 496, FlxG.height / 2 - 67, backToHome, "assets/back.png", "assets/backdown.png" );
		creditsScreen.add(backButton);
		backButton = new CustomButton(FlxG.width / 2 - 496, FlxG.height / 2 - 67, backToHome, "assets/back.png", "assets/backdown.png");
		helpScreen.add(backButton);
		
		add(homeScreen);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		//Buttons
		/*var found:Bool = false;
		for (i in homeButtons.members)
		{
			var button = cast(i, CustomButton);
			if (found)
			{
				if (button.hover)
				{
					button.hoverOverride = true;
				}
			}
			if (button.hover)
			{
				found = true;
			}
		}*/
		
	}
	private function onPlay():Void
	{
		add(levelsScreen);
		remove(homeScreen);
		FlxG.mouse.reset();
		//levelsScreen.visible = true;
		//levelsScreen.active = true;
		//homeScreen.visible = false;
		//homeScreen.active = false;
	}
	private function onOptions():Void
	{
		//Some options, eventually
	}
	private function onHelp():Void
	{
		add(helpScreen);
		remove(homeScreen);
		FlxG.mouse.reset();
		//helpScreen.visible = true;
		//helpScreen.active = true;
		//homeScreen.visible = false;
		//homeScreen.active = false;
	}
	private function onCredits():Void
	{
		add(creditsScreen);
		remove(homeScreen);
		FlxG.mouse.reset();
		//creditsScreen.visible = true;
		//creditsScreen.active = true;
		//homeScreen.visible = false;
		//homeScreen.active = false;
	}
	public function backToHome():Void 
	{
		add(homeScreen);
		remove(creditsScreen);
		remove(helpScreen);
		remove(levelsScreen);
		FlxG.mouse.reset();
		//homeScreen.visible = true;
		//homeScreen.active = true;
		//creditsScreen.visible = false;
		//creditsScreen.active = false;
		//helpScreen.visible = false;
		//helpScreen.active = false;
	}
}