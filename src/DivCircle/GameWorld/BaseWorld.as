package DivCircle.GameWorld 
{
	import AmidosEngine.World;
	import DivCircle.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseWorld extends World
	{
		
		public function BaseWorld() 
		{
			
		}
		
		override public function update(dt:Number):void 
		{
			Global.UpdateSound(dt);
			super.update(dt);
		}
	}

}