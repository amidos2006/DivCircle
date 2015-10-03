package DivCircle.GameWorld 
{
	import AmidosEngine.AE;
	import AmidosEngine.Sfx;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.GameEntity.MenuEntity.BackButtonEntity;
	import DivCircle.GameEntity.MenuEntity.GameButtonEntity;
	import DivCircle.GameEntity.MenuEntity.GameEndEntity;
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
	public class GameEndWorld extends BaseWorld
	{
		private static var deltaVolume:Number = 0.25;
		private var endSfx:Sfx;
		
		public function GameEndWorld(playerScore:Number) 
		{
			var reset:GameButtonEntity = new GameButtonEntity("resetImage", null);
			reset.x = EmbeddedGraphics.screenWidth / 2;
			reset.y = EmbeddedGraphics.screenHeight / 2 + 100 * EmbeddedGraphics.ConversionRatio;
			var score:GameButtonEntity = null;
			if (GoogleGames.isSupported() || GameCenter.isSupported())
			{
				var imageString:String = "gameCenterImage";
				if (GoogleGames.isSupported())
				{
					imageString = "googleGamesImage";
				}
				
				score = new GameButtonEntity(imageString, null);
				score.x = EmbeddedGraphics.screenWidth / 2 + 100 * EmbeddedGraphics.ConversionRatio;
				score.y = reset.y;
				reset.x -= 100 * EmbeddedGraphics.ConversionRatio;
				
				AddEntity(score);
			}
			AddEntity(reset);
			AddEntity(new GameEndEntity(playerScore, reset, score));	
		}
		
		override public function begin():void 
		{
			super.begin();
			
			endSfx = new Sfx(AE.assetManager.getSound("end"));
			if (Global.deathSfx.playing)
			{
				var fadeOutTween:Tween = new Tween(Global.deathSfx, 1);
				fadeOutTween.animate("volume", 0);
				fadeOutTween.onComplete = EndDeathSound;
				Starling.current.juggler.add(fadeOutTween);
			}
			else
			{
				endSfx.Play();
			}
		}
		
		override public function end():void 
		{
			super.end();
			
			var fadeOutTween:Tween = new Tween(endSfx, 0.5);
			fadeOutTween.animate("volume", 0);
			Starling.current.juggler.add(fadeOutTween);
		}
		
		private function EndDeathSound():void
		{
			Global.StopDeathSfx();
			endSfx.Play();
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
		}
	}

}