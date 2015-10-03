package DivCircle.GameEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.Global;
	import DivCircle.LayerConstant;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BackgroundEntity extends Entity
	{
		private const TRANSITION_SPEED:Number = 0.75;
		private const SOUND_VOLUME:Number = 2;
		
		private var firstRectangle:Image;
		private var secondRectangle:Image;
		private var rotationLeftSfx:Array;
		private var rotationRightSfx:Array;
		
		public var rotationSpeed:Number;
		public var targetSpeed:Number;
		
		public function set CurrentAngle(value:Number):void
		{
			rotation = value * Math.PI / 180;
		}
		
		public function get CurrentAngle():Number
		{
			return rotation * 180 / Math.PI;
		}
		
		public function get TargetSpeed():Number
		{
			return Math.abs(targetSpeed);
		}
		
		public function BackgroundEntity() 
		{
			x = EmbeddedGraphics.screenWidth / 2 + Global.SHIFT_X * EmbeddedGraphics.ConversionRatio;
			y = EmbeddedGraphics.screenHeight / 2 + Global.SHIFT_Y * EmbeddedGraphics.ConversionRatio;
			
			rotationSpeed = 0;
			targetSpeed = 0;
			
			firstRectangle = new Image(EmbeddedGraphics.rectangleTexture);
			firstRectangle.color = Global.currentFirstColor;
			firstRectangle.smoothing = TextureSmoothing.TRILINEAR;
			firstRectangle.pivotX = 0.5 * firstRectangle.width;
			firstRectangle.pivotY = 1 * firstRectangle.height;
			firstRectangle.scaleX = 1.5 * EmbeddedGraphics.screenWidth / firstRectangle.width;
			firstRectangle.scaleY = 1.5 * EmbeddedGraphics.screenHeight / firstRectangle.height;
			
			secondRectangle = new Image(EmbeddedGraphics.rectangleTexture);
			secondRectangle.color = Global.currentSecondColor;
			secondRectangle.smoothing = TextureSmoothing.TRILINEAR;
			secondRectangle.pivotX = 0.5 * secondRectangle.width;
			secondRectangle.pivotY = 0 * secondRectangle.height;
			secondRectangle.scaleX = 1.5 * EmbeddedGraphics.screenWidth / secondRectangle.width;
			secondRectangle.scaleY = 1.5 * EmbeddedGraphics.screenHeight / secondRectangle.height;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(firstRectangle);
			sprite.addChild(secondRectangle);
			
			rotationRightSfx = new Array();
			rotationRightSfx.push(new Sfx(AE.assetManager.getSound("breathIn0")));
			rotationRightSfx.push(new Sfx(AE.assetManager.getSound("breathIn1")));
			rotationRightSfx.push(new Sfx(AE.assetManager.getSound("breathIn2")));
			
			rotationLeftSfx = new Array();
			rotationLeftSfx.push(new Sfx(AE.assetManager.getSound("breathOut0")));
			rotationLeftSfx.push(new Sfx(AE.assetManager.getSound("breathOut1")));
			rotationLeftSfx.push(new Sfx(AE.assetManager.getSound("breathOut2")));
			
			graphic = sprite;
			layer = LayerConstant.BACKGROUND_LAYER;
		}
		
		private function PlayRotationSound(current:Number, next:Number):void
		{
			if (current * next < 0)
			{
				var randomInt:int = Math.floor(Math.random() * rotationLeftSfx.length);
				if (current > 0)
				{
					rotationLeftSfx[randomInt].Play(SOUND_VOLUME);
				}
				else
				{
					rotationRightSfx[randomInt].Play(SOUND_VOLUME);
				}
			}
		}
		
		public function ChangeRotationSpeed(target:Number, timeFactor:Number = 1):void
		{
			PlayRotationSound(rotationSpeed, target);
			
			var tween:Tween = new Tween(this, timeFactor * TRANSITION_SPEED, "linear");
			tween.animate("rotationSpeed", target * Global.GetSign(rotationSpeed));
			
			Starling.current.juggler.add(tween);
			
			tween = new Tween(this, timeFactor * TRANSITION_SPEED, "linear");
			tween.animate("targetSpeed", Math.abs(target));
			
			Starling.current.juggler.add(tween);
		}
		
		public function ChangeDirection():void
		{	
			PlayRotationSound(rotationSpeed, -rotationSpeed);
			
			var tween:Tween = new Tween(this, TRANSITION_SPEED, "linear");
			tween.animate("rotationSpeed", -rotationSpeed);
			
			Starling.current.juggler.add(tween);
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			
			CurrentAngle += rotationSpeed * dt;
		}
	}

}