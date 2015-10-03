package DivCircle.GameEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.Global;
	import DivCircle.LayerConstant;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CircleEntity extends Entity
	{
		private var firstCircle:Image;
		private var secondCircle:Image;
		
		private var startingID:int;
		private var startingX:Number;
		private var startingY:Number;
		private var startingAngle:Number;
		
		public var bonusDistance:Number;
		public var notStart:Boolean;
		
		public function set CurrentAngle(value:Number):void
		{
			rotation = value * Math.PI / 180;
		}
		
		public function get CurrentAngle():Number
		{
			return rotation * 180 / Math.PI;
		}
		
		public function CircleEntity() 
		{
			startingID = -1;
			startingX = x;
			startingY = y;
			bonusDistance = 0;
			
			x = EmbeddedGraphics.screenWidth / 2 + Global.SHIFT_X * EmbeddedGraphics.ConversionRatio;
			y = EmbeddedGraphics.screenHeight / 2 + Global.SHIFT_Y * EmbeddedGraphics.ConversionRatio;
			
			firstCircle = new Image(EmbeddedGraphics.halfCircleTexture);
			firstCircle.color = Global.currentFirstColor;
			firstCircle.smoothing = TextureSmoothing.TRILINEAR;
			firstCircle.pivotX = firstCircle.width / 2;
			firstCircle.pivotY = firstCircle.height;
			//firstCircle.rotation = Math.PI
			
			secondCircle = new Image(EmbeddedGraphics.halfCircleTexture);
			secondCircle.color = Global.currentSecondColor;
			secondCircle.smoothing = TextureSmoothing.TRILINEAR;
			secondCircle.pivotX = secondCircle.width / 2;
			secondCircle.pivotY = secondCircle.height;
			secondCircle.rotation = Math.PI;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(firstCircle);
			sprite.addChild(secondCircle);
			
			notStart = true;
			
			graphic = sprite;
			layer = LayerConstant.CIRCLE_LAYER;
		}
		
		override public function add():void 
		{
			super.add();
			
			AE.AddPressFunction(onPress);
			AE.AddMoveFunction(onMove);
			AE.AddReleaseFunction(onRelease);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			AE.RemovePressFunction(onPress);
			AE.RemoveMoveFunction(onMove);
			AE.RemoveReleaseFunction(onRelease);
		}
		
		public function onPress(tX:Number, tY:Number, tID:int):void
		{
			if (notStart)
			{
				return;
			}
			
			if (startingID == -1)
			{
				startingX = tX;
				startingY = tY;
				startingID = tID;
				startingAngle = CurrentAngle;
			}
		}
		
		public function onMove(tX:Number, tY:Number, tID:int):void
		{
			if (notStart)
			{
				return;
			}
			
			if (startingID == -1)
			{
				startingID = tID;
				startingX = tX;
				startingY = tY;
				startingAngle = CurrentAngle;
			}
			else if (startingID == tID)
			{
				var intialAngle:Number = Global.GetAngle(x, y, startingX, startingY);
				var newAngle:Number = Global.GetAngle(x, y, tX, tY);
				
				var difference:Number = newAngle - intialAngle;
				CurrentAngle = startingAngle + difference;
				
				var p:Point = new Point(tX - x, tY - y);
				bonusDistance = 3 * p.length / EmbeddedGraphics.screenWidth;
			}
		}
		
		public function onRelease(tX:Number, tY:Number, tID:int):void
		{
			if (notStart)
			{
				return;
			}
			
			if (startingID == tID)
			{
				startingID = -1;
				bonusDistance = 0;
			}
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
		}
	}

}