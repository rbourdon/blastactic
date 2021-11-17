package;

import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxG;

class GameComplete extends FlxState
{
	public var levelsScreen:LevelLoader;
	
	public function new(rCreds, sTaken, pD)
	{
		super();
		var bg:FlxSprite = new FlxSprite(0, 0, "assets/gamecompleted.png");
		add(bg);
		var mainMenuButton:CustomButton = new CustomButton(855, 328, goMainMenu, "assets/mainmenu.png", "assets/mainmenudown.png");
		add(mainMenuButton);
		//var mainMenuButton:CustomButton = new CustomButton(840, 383, goMainMenu, "assets/mainmenubutton.png");
		//add(mainMenuButton);
		var levelSelectButton:CustomButton = new CustomButton(187, 342, onLevelSelect, "assets/levelselect.png", "assets/levelselectdown.png");
		add(levelSelectButton);
		//var replayGameButton:CustomButton = new CustomButton(190, 380, replayGame, "assets/replaygame.png");
		//add(replayGameButton);
		var remainingCredits:FlxText = new FlxText(221, 480, 170, Std.string(rCreds), true);
		remainingCredits.setFormat("assets/blutter", 110, 0xBCD122, "center");
		add(remainingCredits);
		var pDestroyed:FlxText = new FlxText(563, 497, 170, Std.string(pD), true);
		pDestroyed.setFormat("assets/blutter", 110, 0xBCD122, "center");
		add(pDestroyed);
		var shotsTaken:FlxText = new FlxText(909, 480, 170, Std.string(sTaken), true);
		shotsTaken.setFormat("assets/blutter", 110, 0xBCD122, "center");
		add(shotsTaken);
		
		levelsScreen = new LevelLoader(this);
	}
	private function goMainMenu()
	{
		FlxG.switchState(new MenuState());
	}
	private function onLevelSelect():Void
	{
		add(levelsScreen);
	}
	public function backToHome():Void
	{
		remove(levelsScreen);
	}
}