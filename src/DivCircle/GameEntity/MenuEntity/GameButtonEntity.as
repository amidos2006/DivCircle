package DivCircle.GameEntity.MenuEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.ButtonEntity;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.LayerConstant;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameButtonEntity extends ButtonEntity
	{
		private const COLOR:uint = 0xFFFFFFFF;
		
		public var buttonFunction:Function;
		
		private var image:Image;
		
		public function GameButtonEntity(imageString:String, func:Function) 
		{
			buttonFunction = func;
			
			this.releaseFunction = ReleaseFunction;
			
			image = new Image(AE.assetManager.getTexture(imageString));
			image.alignPivot();
			image.scaleX = EmbeddedGraphics.ConversionRatio;
			image.scaleY = EmbeddedGraphics.ConversionRatio;
			
			hitBox = new Rectangle(-image.pivotX, -image.pivotY, image.width, image.height);
			
			graphic = image;
			layer = LayerConstant.TOP_LAYER;
		}
		
		private function ReleaseFunction():void
		{
			if (buttonFunction != null)
			{
				buttonFunction();
			}
		}
	}

}