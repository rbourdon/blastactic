package;

import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import org.flixel.FlxG;

class PauseScreen extends FlxGroup
{
	public var levelsScreen:LevelLoader;
	public var helpScreen:FlxGroup;
	
	public function new()
	{
		super();
		var pauseBG:FlxSprite = new FlxSprite(0, 0, "assets/paused.png");
		add(pauseBG);
		
		//var mMButtonText:FlxText = new FlxText(640, 250, 100, "Main Menu", true);
		//mMButtonText.setFormat("blutter", 24, 0xffffff, "center");
		var mainMenuButton:CustomButton = new CustomButton(547, 416, onMainMenu, "assets/mainmenu.png", "assets/mainmenudown.png");
		add(mainMenuButton);
		var levelSelectButton:CustomButton = new CustomButton(510, 499, onLevelSelect, "assets/levelselect.png", "assets/levelselectdown.png");
		add(levelSelectButton);
		var helpButton:CustomButton = new CustomButton(558, 562, onHelp, "assets/helpbutton.png", "assets/helpbuttondown.png");
		add(helpButton);
		levelsScreen = new LevelLoader(this);
		
		helpScreen = new FlxGroup();
		var bg:FlxSprite = new FlxSprite(0, 0, "assets/help_screen.png");
		helpScreen.add(bg);
		var backButton:CustomButton = new CustomButton(FlxG.width / 2 - 496, FlxG.height / 2 - 67, backToHome, "assets/back.png", "assets/backdown.png");
		helpScreen.add(backButton);
	}
	private function onMainMenu():Void
	{
		FlxG.switchState(new MenuState());
	}
	private function onLevelSelect():Void
	{
		add(levelsScreen);
		remove(helpScreen);
	}
	public function backToHome():Void
	{
		remove(helpScreen);
		remove(levelsScreen);
	}
	public function onHelp():Void
	{
		add(helpScreen);
		remove(levelsScreen);
	}
}