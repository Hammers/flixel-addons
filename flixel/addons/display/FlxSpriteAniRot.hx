package flixel.addons.display;

#if flash
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxSprite;
import flixel.system.layer.frames.FlxSpriteFrames;
import flixel.util.FlxColor;
import flixel.util.loaders.CachedGraphics;

/**
 * Creating animated and rotated sprite from an un-rotated animated image. 
 * THE ANIMATION MUST CONTAIN ONLY ONE ROW OF SPRITE FRAMES.
 * 
 * @version 1.0 - November 8th 2011
 * @link http://www.gameonaut.com
 * @author Simon Etienne Rozner / Gameonaut.com, ported to Haxe by Sam Batista
*/
class FlxSpriteAniRot extends FlxSprite
{
	private var cached:Array<CachedGraphics>;
	private var framesCache:Array<FlxSpriteFrames>;
	private var rotations:Float = 0;
	private var angleIndex:Int = -1;

	public function new(AnimatedGraphic:Dynamic, Rotations:Int, X:Float = 0, Y:Float = 0)
	{
		super(X, Y);
		// Just to get the number of frames
		loadGraphic(AnimatedGraphic, true); 
		
		rotations = 360 / Rotations;
		cached = [];
		framesCache = [];
		
		// Load the graphic, create rotations every 10 degrees
		for (i in 0...frames)
		{
			// Create the rotation spritesheet for that frame
			loadRotatedGraphic(AnimatedGraphic, Rotations, i, true, false);
			cached.push(_cachedGraphics);
			framesCache.push(_framesData);
		}
		bakedRotation = 0;
	}
	
	override public function destroy():Void 
	{
		cached = null;
		framesCache = null;
		
		super.destroy();
	}
	
	override private function updateAnimation():Void 
	{
		var oldIndex:Int = angleIndex;
		var angleHelper:Int = Math.floor(angle % 360);
		
		while (angleHelper < 0)
		{
			angleHelper += 360;
		}
		
		angleIndex = Math.floor(angleHelper / rotations + 0.5);
		angleIndex = Std.int(angleIndex % frames);
		
		if (oldIndex != angleIndex)
		{
			dirty = true;
		}
		
		super.updateAnimation();
	}

	override private function calcFrame():Void 
	{
		_cachedGraphics = cached[_curIndex];
		_flxFrame = framesCache[_curIndex].frames[angleIndex];
		super.calcFrame();
	}
}
#end