package AmidosEngine 
{
	import adobe.utils.CustomActions;
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class World extends DisplayObjectContainer
	{
		private var layers:Vector.<Layer>;
		private var addedList:Vector.<Entity>;
		private var removedList:Vector.<Entity>;
		
		public function World(numberOfLayers:int = 10) 
		{
			layers = new Vector.<Layer>();
			for (var i:int = 0; i < numberOfLayers; i++) 
			{
				layers.push(new Layer());
			}
			
			addedList = new Vector.<Entity>();
			removedList = new Vector.<Entity>();
		}
		
		public function begin():void
		{
			for (var i:int = 0; i < layers.length; i++) 
			{
				addChildAt(layers[i], i);
			}
		}
		
		public function AddPendingEntities():void
		{
			var e:Entity;
			for (var j:int = 0; j < addedList.length; j++) 
			{
				e = addedList[j];
				if (layers[e.layer].addChild(e) != null)
				{
					e.world = this;
					e.add();
				}
			}
			addedList.length = 0;
		}
		
		public function RemovePendingEntities():void
		{
			var e:Entity;
			for (var k:int = 0; k < removedList.length; k++) 
			{
				e = removedList[k];
				if (layers[e.layer].removeChild(e) != null)
				{
					e.remove();
					e.world = null;
				}
			}
			removedList.length = 0;
		}
		
		public function end():void
		{
			for (var i:int = 0; i < layers.length; i++) 
			{
				for (var j:int = 0; j < layers[i].numChildren; j++) 
				{
					(layers[i].getChildAt(j) as Entity).remove();
				}
				layers[i].removeChildren();
				removeChild(layers[i]);
			}
			layers.length = 0;
		}
		
		public function AddEntity(e:Entity):void
		{
			addedList.push(e);
		}
		
		public function RemoveEntity(e:Entity):void
		{
			removedList.push(e);
		}
		
		public function className(collisionName:String):Vector.<Entity>
		{
			var collidedEntities:Vector.<Entity> = new Vector.<Entity>();
			
			for (var i:int = 0; i < layers.length; i++) 
			{
				for (var j:int = 0; j < layers[i].numChildren; j++) 
				{
					var e:Entity = layers[i].getChildAt(j) as Entity;
					if (e.collisionName == collisionName)
					{
						collidedEntities.push(e);
					}
				}
			}
			
			return collidedEntities;
		}
		
		public function update(dt:Number):void
		{
			for (var i:int = 0; i < layers.length; i++) 
			{
				layers[i].update(dt);
			}
			
			AddPendingEntities();
			RemovePendingEntities();
		}
	}

}