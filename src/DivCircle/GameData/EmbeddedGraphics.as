package DivCircle.GameData 
{
	import DivCircle.Global;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EmbeddedGraphics 
	{
		private static const CIRCLE_PERCENTAGE:Number = 0.5;
		private static const COLOR:uint = 0xFFFFFF;
		
		public static var screenWidth:int;
		public static var screenHeight:int;
		
		public static var rectangleTexture:Texture;
		public static var halfCircleTexture:Texture;
		
		[Embed(source = "../../../assets/restImage.png")]public static var resetImage:Class;
		[Embed(source = "../../../assets/gameCenterOutImage.png")]public static var gameCenterImage:Class;
		[Embed(source = "../../../assets/googleGamesOutImage.png")]public static var googleGamesImage:Class;
		
		public static function get ConversionRatio():Number
		{
			return screenHeight / 640;
		}
		
		public static function Initialize(screenWidth:int, screenHeight:int):void
		{
			EmbeddedGraphics.screenWidth = screenWidth;
			EmbeddedGraphics.screenHeight = screenHeight;
			
			var radius:int = screenHeight * CIRCLE_PERCENTAGE / 2;
			var imageSize:int = 2 * (radius + 10);
			
			var sprite:Sprite= new Sprite();
			sprite.graphics.beginFill(COLOR, 1);
			sprite.graphics.drawCircle(imageSize / 2, imageSize / 2, radius);
			sprite.graphics.endFill();
			
			var bitmapData:BitmapData = new BitmapData(imageSize, imageSize / 2, true, 0);
			bitmapData.draw(sprite);
			halfCircleTexture = Texture.fromBitmapData(bitmapData);
			
			bitmapData = new BitmapData(1, 1, true, 0xFF<<24 | COLOR);
			rectangleTexture = Texture.fromBitmapData(bitmapData);
		}
	}

}