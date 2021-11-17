package;

import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxG;
import org.flixel.FlxText;

class LevelTransition extends FlxState
{
	private var lastLevel:Int;
	
	override public function new(lastLvl, rCreds, sTaken, pD)
	{
		super();
		lastLevel = lastLvl;
		var bg:FlxSprite = new FlxSprite( 0, 0, "assets/leveltransition.png");
		add(bg);
		var nextLevelButton:CustomButton = new CustomButton(843, 345, goNextLevel, "assets/nextlevel.png", "assets/nextleveldown.png");
		add(nextLevelButton);
		//var mainMenuButton:CustomButton = new CustomButton(840, 383, goMainMenu, "assets/mainmenubutton.png");
		//add(mainMenuButton);
		var replayLevelButton:CustomButton = new CustomButton(187, 342, replayLevel, "assets/replaylevel.png", "assets/replayleveldown.png");
		add(replayLevelButton);
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
		var lastLevelText:FlxText = new FlxText(660, 222, 170, Std.string(lastLevel), true);
		lastLevelText.setFormat("assets/blutter", 88, 0xe5e5e5, "center");
		add(lastLevelText);
		//new PlayState(levelNumber+1)
	}
	private function goNextLevel():Void
	{
		if (lastLevel + 1 <= Registry.numLevels)
		{
			FlxG.switchState(new PlayState(lastLevel + 1));
		}
	}
	private function goMainMenu():Void
	{
		FlxG.switchState(new MenuState());
	}
	private function replayLevel():Void
	{
		FlxG.switchState(new PlayState(lastLevel));
	}
	private function replayGame():Void
	{
		FlxG.switchState(new PlayState(1));
	}
}