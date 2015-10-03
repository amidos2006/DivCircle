package DivCircle.GameData 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class ActionGroup 
	{
		public var scoreLimit:Number;
		public var speedLimit:Number;
		public var actions:Array;
		
		public function ActionGroup(limit:Number, sLimit:Number, a:Array)
		{
			scoreLimit = limit;
			speedLimit = sLimit;
			actions = a;
		}
		
		public function ContainsReverse():Boolean
		{
			for each (var a:int in actions) 
			{
				if (a == Action.REVERSE || a == Action.SPEED_REVERSE || a == Action.SLOW_REVERSE)
				{
					return true;
				}
			}
			
			return false;
		}
	}

}