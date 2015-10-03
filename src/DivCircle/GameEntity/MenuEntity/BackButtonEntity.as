package DivCircle.GameEntity.MenuEntity 
{
	import AmidosEngine.ButtonEntity;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.LayerConstant;
	import flash.geom.Rectangle;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BackButtonEntity extends ButtonEntity
	{
		private const COLOR:uint = 0xFFFFFFFF;
		
		public var backFunction:Function;
		private var pressedBefore:Boolean;
		private var inGameButton:Boolean;
		private var xText:TextField;
		
		public function BackButtonEntity(func:Function, gameButton:Boolean = false) 
		{
			backFunction = func;
			inGameButton = gameButton;
			
			this.pressFunction = PressFunction;
			this.releaseFunction = ReleaseFunction;
			
			xText = new TextField(EmbeddedGraphics.ConversionRatio * 75, EmbeddedGraphics.ConversionRatio * 75, "x", "gameFont", EmbeddedGraphics.ConversionRatio * 60, COLOR);
			xText.alignPivot();
			xText.blendMode = "invert";
			
			x = xText.pivotX * 0.75;
			y = xText.pivotY * 0.75;
			
			hitBox = new Rectangle(-xText.pivotX, -xText.pivotY, xText.width, xText.height);
			
			graphic = xText;
			layer = LayerConstant.TOP_LAYER;
		}
		
		private function PressFunction():void
		{
			pressedBefore = true;
		}
		
		private function ReleaseFunction():void
		{
			if (pressedBefore)
			{
				if (backFunction != null)
				{
					backFunction();
				}
			}
		}
		
		override protected function ButtonIn():void 
		{
			super.ButtonIn();
			if (!inGameButton)
			{
				pressedBefore = true;
			}
		}
		
		override protected function ButtonOut():void 
		{
			super.ButtonOut();
			pressedBefore = false;
		}
		
	}

}