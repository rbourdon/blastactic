package;

import org.flixel.FlxSprite;
import org.flixel.FlxG;

class Goal extends FlxSprite
{
	public var complete:Bool;
	public var hitsNeeded:Int;
	public var hitsLeft:Int;
	
	public function new(x:Int, y:Int, hN:Int)
	{
		super(x, y);
		complete = false;
		moves = false;
		hitsNeeded = hN;
		hitsLeft = hN;
		//Load Graphics
		var graphicToLoad:String = "assets/goal" + Std.string(hitsNeeded) + ".png";
		loadGraphic(graphicToLoad);
		centerOffsets();
	}
	public function hit():Void
	{
		//trace("GOAL!!!");
		hitsLeft --;
		//PlayState.goalSnd.stop();
		//PlayState.goalSnd = FlxG.play("Goal");
		//trace(hitsNeeded);
		if (hitsLeft == 0)
		{
			complete = true;
			loadGraphic("assets/goalcomplete.png");
		}
		else
		{
			var graphicToLoad:String = "assets/goal" + Std.string(hitsLeft) + ".png";
			loadGraphic(graphicToLoad);
		}
	}
	public function resetHits():Void
	{
		hitsLeft = hitsNeeded;
		complete = false;
		var graphicToLoad:String = "assets/goal" + Std.string(hitsLeft) + ".png";
		loadGraphic(graphicToLoad);
	}
}