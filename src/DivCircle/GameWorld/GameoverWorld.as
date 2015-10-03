package DivCircle.GameWorld 
{
	import AmidosEngine.AE;
	import DivCircle.GameEntity.MenuEntity.BackButtonEntity;
	import DivCircle.GameEntity.MenuEntity.GameoverEntity;
	import DivCircle.Global;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameoverWorld extends BaseWorld
	{
		private static var deltaVolume:Number = 0.25;
		
		public function GameoverWorld(playerScore:Number) 
		{
			var back:BackButtonEntity = new BackButtonEntity(null, false);
			AddEntity(back);
			AddEntity(new GameoverEntity(playerScore, back));	
		}
		
		override public function begin():void 
		{
			super.begin();
			
			if (!Global.deathSfx.playing)
			{
				Global.PlayDeathSfx();
			}
		}
		
		override public function end():void 
		{
			super.end();
			
			var fadeOutTween:Tween = new Tween(Global.deathSfx, 0.5);
			fadeOutTween.animate("volume", 0);
			fadeOutTween.onComplete = Global.StopDeathSfx;
			Starling.current.juggler.add(fadeOutTween);
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
		}
	}

}