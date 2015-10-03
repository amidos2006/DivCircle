package AmidosEngine
{
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Game extends Sprite
	{
		public var background:Quad;
		
		internal var currentWorld:World;
		internal var nextWorld:World;
		internal var pause:Boolean;
		
		public function get ActiveWorld():World
		{
			return currentWorld;
		}
		
		public function set ActiveWorld(world:World):void
		{
			nextWorld = world;
		}
		
		public function Game() 
		{
			background = new Quad(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0xFF000000);
			addChild(background);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, update);
			
			AE.game = this;
			pause = false;
		}
		
		private function update(event:EnterFrameEvent):void
		{
			if (currentWorld != null)
			{
				if (!pause)
				{
					currentWorld.update(event.passedTime);
				}
			}
			
			if (nextWorld != null)
			{
				if (currentWorld != null)
				{
					currentWorld.end();
					removeChild(currentWorld);
				}
				
				AE.RemoveAllPressFunction();
				AE.RemoveAllMoveFunction();
				AE.RemoveAllReleaseFunction();
				
				addChild(nextWorld);
				nextWorld.begin();
				
				currentWorld = nextWorld;
				nextWorld = null;
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.BEGAN);
			var i:int = 0;
			var j:int = 0;
			var localPos:Point;
			
			if (touches.length > 0)
			{
				for (i = 0; i < touches.length; i++) 
				{
					localPos = touches[i].getLocation(this);
					for (j = 0; j < AE.pressFunction.length; j++) 
					{
						AE.pressFunction[j](localPos.x, localPos.y, touches[i].id);
					}
				}
			}
			
			touches = event.getTouches(this, TouchPhase.MOVED);
			i = 0;
			j = 0;
			if (touches.length > 0)
			{
				for (i = 0; i < touches.length; i++) 
				{
					localPos = touches[i].getLocation(this);
					for (j = 0; j < AE.moveFunction.length; j++) 
					{
						AE.moveFunction[j](localPos.x, localPos.y, touches[i].id);
					}
				}
			}
			
			touches = event.getTouches(this, TouchPhase.ENDED);
			i = 0;
			j = 0;
			if (touches.length > 0)
			{
				for (i = 0; i < touches.length; i++) 
				{
					localPos = touches[i].getLocation(this);
					for (j = 0; j < AE.releaseFunction.length; j++) 
					{
						AE.releaseFunction[j](localPos.x, localPos.y, touches[i].id);
					}
				}
			}
		}
	}

}