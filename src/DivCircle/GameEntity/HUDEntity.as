package DivCircle.GameEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.Global;
	import DivCircle.LayerConstant;
	import flash.display3D.Context3DBlendFactor;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HUDEntity extends Entity
	{
		private const MAX_DAMAGE:Number = 100;
		
		public var score:Number;
		public var damage:Number;
		
		private var scoreText:TextField;
		private var whiteLayer:Image;
		
		public function HUDEntity() 
		{
			x = EmbeddedGraphics.screenWidth / 2 + Global.SHIFT_X * EmbeddedGraphics.ConversionRatio;
			y = EmbeddedGraphics.screenHeight / 2 + Global.SHIFT_Y * EmbeddedGraphics.ConversionRatio;
			
			whiteLayer = new Image(EmbeddedGraphics.rectangleTexture);
			whiteLayer.scaleX = EmbeddedGraphics.screenWidth / whiteLayer.width;
			whiteLayer.scaleY = EmbeddedGraphics.screenHeight / whiteLayer.height;
			whiteLayer.alpha = 0;
			whiteLayer.x = -x;
			whiteLayer.y = -y;
			
			score = 0;
			damage = 0;
			scoreText = new TextField(600 * EmbeddedGraphics.ConversionRatio, 60 * EmbeddedGraphics.ConversionRatio, "00000000", "gameFont", 60 * EmbeddedGraphics.ConversionRatio, 0xFFFFFF);
			scoreText.alignPivot();
			scoreText.blendMode = "invert";
			scoreText.y += scoreText.height * 0.065;
			scoreText.alpha = 0;
			
			graphic = scoreText;
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function add():void 
		{
			super.add();
			
			addChild(whiteLayer);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			removeChild(whiteLayer);
		}
		
		public function ShowHUD():void
		{
			var tween:Tween = new Tween(scoreText, 1, "linear");
			tween.fadeTo(1);
			Starling.current.juggler.add(tween);
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			
			whiteLayer.alpha = damage / MAX_DAMAGE;
			scoreText.text = Global.GetFixedNumberDigits(score, 8);
		}
	}

}