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
	public class EmbeddedData 
	{
		[Embed(source = "../../../assets/gameEndings.xml", mimeType = "application/octet-stream")]public static const gameEndings:Class;
		
	}

}