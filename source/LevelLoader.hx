package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxText;

class LevelLoader extends FlxGroup
{
	private var menu:Dynamic;
	
	public function new(m:Dynamic)
	{
		super();
		menu = m;
		var bg = new FlxSprite(0, 0, "assets/home_screen.png");
		add(bg);
		buildScreen();
	}
	private function buildScreen()
	{
		var backButton = new CustomButton(FlxG.width / 2 - 496, FlxG.height / 2 - 67, backToHome, "assets/back.png", "assets/backdown.png");
		add(backButton);
		for (j in 1...5)
		{
			var start:Int = 0;
			var numCol:Int = 7;
			if (j % 2 != 0)
			{
				start = 75;
				numCol = 6;
			}
			for (i in 1...numCol)
			{
				var button:CustomButton = new CustomButton(i * 150 + 85 + start, j * 80 + 235, loadLevel, "assets/levelButton.png", "assets/levelButtonHover.png", null, true, this, (j-1)*5 + i);
				button.text.text = Std.string((j-1)*5 + i);
				button.text.y = button.graphic.y + button.graphic.height / 2 - button.text.height / 2;
				button.text.x -= 2;
				add(button);
				if ((j - 1) * 5 + i > FlxG.saves[0].data.levelsUnlocked)
				{
					button.disabled = true;
					var locked:FlxSprite = new FlxSprite(button.graphic.x, button.graphic.y, "assets/lockedlevel.png");
					add(locked);
				}
			}
		}
	}
	private function loadLevel():Void
	{
		for (i in members)
		{
			if (Std.is(i, CustomButton))
			{
				var button = cast(i, CustomButton);
				if (button.hover)
				{
					FlxG.switchState(new PlayState(button.idNum));
					break;
				}
			}
		}
		//trace(this.text);
	}
	private function backToHome():Void
	{
		if (menu != null)
		{
			menu.backToHome();
		}
		else
		{
			
		}
	}
}