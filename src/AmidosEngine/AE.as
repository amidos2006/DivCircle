package AmidosEngine 
{
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author Amidos
	 */
	public class AE 
	{
		internal static var pressFunction:Vector.<Function>;
		internal static var moveFunction:Vector.<Function>;
		internal static var releaseFunction:Vector.<Function>;
		
		public static var game:Game;
		public static var assetManager:AssetManager;
		
		public static function Intialize():void
		{
			pressFunction = new Vector.<Function>();
			moveFunction = new Vector.<Function>();
			moveFunction = new Vector.<Function>();
			releaseFunction = new Vector.<Function>();
			assetManager = new AssetManager();
		}
		
		public static function AddPressFunction(f:Function):void
		{
			pressFunction.push(f);
		}
		
		public static function ResumeEngine():void
		{
			if (AE.game != null)
			{
				AE.game.pause = false;
			}
		}
		
		public static function PauseEngine():void
		{
			if (AE.game != null)
			{
				AE.game.pause = true;
			}
		}
		
		public static function RemovePressFunction(f:Function):void
		{
			var index:int = pressFunction.indexOf(f);
			pressFunction.splice(index, 1);
		}
		
		public static function RemoveAllPressFunction():void
		{
			pressFunction.length = 0;
		}
		
		public static function AddMoveFunction(f:Function):void
		{
			moveFunction.push(f);
		}
		
		public static function RemoveMoveFunction(f:Function):void
		{
			var index:int = moveFunction.indexOf(f);
			moveFunction.splice(index, 1);
		}
		
		public static function RemoveAllMoveFunction():void
		{
			moveFunction.length = 0;
		}
		
		public static function AddReleaseFunction(f:Function):void
		{
			releaseFunction.push(f);
		}
		
		public static function RemoveReleaseFunction(f:Function):void
		{
			var index:int = releaseFunction.indexOf(f);
			releaseFunction.splice(index, 1);
		}
		
		public static function RemoveAllReleaseFunction():void
		{
			releaseFunction.length = 0;
		}
	}

}