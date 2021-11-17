package;

import org.flixel.system.FlxPreloader;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.Lib;
import nme.display.Sprite;
import org.flixel.system.preloaderHelpers.PxTextField;
import org.flixel.plugin.pxText.PxTextAlign;
import org.flixel.FlxG;
import nme.Assets;
import nme.display.BlendMode;

//@:bitmap("assets/preloadlogo.png") class PreLogo extends flash.display.BitmapData { }
@:bitmap("assets/preloadlogo.png") class PreLogo extends BitmapData { }
@:bitmap("assets/pauseninelogo.png") class P9Logo extends BitmapData {}

class PNinePreloader extends FlxPreloader
{
	override private function create()
	{
		super.create();
		minDisplayTime = 3;
		_min = 0;
		if(!FlxG.debug)
		{
			_min = Math.floor(minDisplayTime * 1000);
		}
		_buffer = new Sprite();
		_buffer.scaleX = _buffer.scaleY = 2;
		addChild(_buffer);
		_width = Math.floor(Lib.current.stage.stageWidth / _buffer.scaleX);
		_height = Math.floor(Lib.current.stage.stageHeight / _buffer.scaleY);
		#if !neko
		_buffer.addChild(new Bitmap(new BitmapData(_width, _height, false, 0xe5e5e5)));
		#else
		_buffer.addChild(new Bitmap(new BitmapData(_width, _height, false, {rgb: 0xe5e5e5, a: 0xff})));
		#end
		//var bitmap:Bitmap = new Bitmap(createBitmapFromData(LogoLightData, LogoLightWidth, LogoLightHeight));
		//bitmap.smoothing = true;
		//bitmap.width = bitmap.height = _height;
		//bitmap.x = (_width - bitmap.width) / 2;
		//_buffer.addChild(bitmap);
		#if !neko
		_bmpBar = new Bitmap(new BitmapData(1, 7, false, 0xBCD122));
		#else
		_bmpBar = new Bitmap(new BitmapData(1, 7, false, {rgb: 0xBCD122, a: 0xff}));
		#end
		_bmpBar.x = 4;
		_bmpBar.y = _height - 11;
		_buffer.addChild(_bmpBar);
		
		_text = new PxTextField(_font);
		_text.alignment = PxTextAlign.LEFT;
		_text.scaleX = _text.scaleY = 0.8;
		_text.color = 0x111111;
		_text.x = 4;
		_text.y = _bmpBar.y - 11;
		_text.setWidth(120);
		_text.wordWrap = false;
		_buffer.addChild(_text);
		//_logo = new Sprite();
		//drawLogo(_logo.graphics);
		//_logo.scaleX = _logo.scaleY = _height / 8 * 0.04;
		//_logo.x = (_width - _logo.width) / 2;
		//_logo.y = (_height - _logo.height) / 2;
		//_buffer.addChild(_logo);
		//_logoGlow = new Sprite();
		//drawLogo(_logoGlow.graphics);
		//_logoGlow.blendMode = BlendModeScreen;
		//_logoGlow.scaleX = _logoGlow.scaleY = _height / 8 * 0.04;
		//_logoGlow.x = (_width - _logoGlow.width) / 2;
		//_logoGlow.y = (_height - _logoGlow.height) / 2;
		//_buffer.addChild(_logoGlow);
		
		//Game Logo
		var bitmap:Bitmap = new Bitmap(new PreLogo(419,419));
		//bitmap.width *= .5;
		//bitmap.height *= .5;
		bitmap.scaleX = .5;
		bitmap.scaleY = .5;
		bitmap.x = _width / 2 - bitmap.width / 2;
		bitmap.y = _height / 2 - bitmap.height / 2;
		_buffer.addChild(bitmap);
		
		//Pause 9 Logo
		var bitmap = new Bitmap(new P9Logo(111,131));
		//bitmap.width *= .5;
		//bitmap.height *= .5;
		bitmap.scaleX = .5;
		bitmap.scaleY = .5;
		bitmap.x = _width - bitmap.width - 10;
		bitmap.y = _height - bitmap.height - 15;
		_buffer.addChild(bitmap);
		
		//Scan Lines
		bitmap = new Bitmap();
		#if !neko
		bitmap = new Bitmap(new BitmapData(_width, _height, false, 0xffffff));
		#else
		bitmap = new Bitmap(new BitmapData(_width, _height, false, {rgb: 0xffffff, a: 0xff}));
		#end
		var i:Int = 0;
		var j:Int = 0;
		while(i < _height)
		{
			j = 0;
			while(j < _width)
			{
				bitmap.bitmapData.setPixel(j++, i, 0);
			}
			i += 2;
		}
		bitmap.blendMode = BlendMode.OVERLAY;
		bitmap.alpha = .3;
		_buffer.addChild(bitmap);
		
	}
	override public function update(Percent:Float)
	{
		//super.update(Percent);
		_bmpBar.scaleX = Percent * (_width - 8);
		_text.text = "Blastactic v1.0" + " " + Math.floor(Percent * 100) + "%";
	}
}