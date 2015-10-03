package AmidosEngine 
{
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Entity extends Sprite
	{
		public var layer:int;
		public var hitBox:Rectangle;
		public var graphic:DisplayObject;
		public var collisionName:String;
		public var world:World;
		
		public function Entity() 
		{
			
		}
		
		public function add():void
		{
			if (graphic != null)
			{
				addChild(graphic);
			}
		}
		
		public function remove():void
		{
			if (graphic != null)
			{
				removeChild(graphic);
			}
		}
		
		public function collidePoint(pX:Number, pY:Number, sX:Number, sY:Number):Boolean
		{
			var currentRectangle:Rectangle = new Rectangle(hitBox.x + sX, hitBox.y + sY, hitBox.width, hitBox.height);
			
			return currentRectangle.contains(pX, pY);
		}
		
		public function collideName(otherName:String, sX:Number, sY:Number):Entity
		{
			var entities:Vector.<Entity> = AE.game.ActiveWorld.className(otherName);
			var currentRectangle:Rectangle = new Rectangle(hitBox.x + sX, hitBox.y + sY, hitBox.width, hitBox.height);
			
			for (var i:int = 0; i < entities.length; i++) 
			{
				var otherRectangle:Rectangle = new Rectangle(entities[i].x + entities[i].hitBox.x, entities[i].y + entities[i].hitBox.y, 
					entities[i].hitBox.width, entities[i].hitBox.height);
				if (currentRectangle.intersects(otherRectangle))
				{
					return entities[i];
				}
			}
			
			return null;
		}
		
		public function update(dt:Number):void
		{
			
		}
	}

}