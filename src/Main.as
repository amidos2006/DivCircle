package 
{
	import AmidosEngine.AE;
	import AmidosEngine.Game;
	import com.mesmotronic.ane.AndroidFullScreen;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import com.sticksports.nativeExtensions.SilentSwitch;
	import DivCircle.GameData.*;
	import DivCircle.GameWorld.GameEndWorld;
	import DivCircle.GameWorld.GameplayWorld;
	import DivCircle.Global;
	import flash.desktop.NativeApplication;
	import flash.display.StageQuality;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class Main extends Sprite 
	{
		public static const FRAMERATE:int = 30;
		
		private var mStarling:Starling;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = FRAMERATE;
			
			stage.addEventListener(flash.events.Event.DEACTIVATE, Deactivate);
			stage.addEventListener(flash.events.Event.ACTIVATE, Activate)
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			AE.Intialize();
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			var screenWidth:int = Math.max(stage.fullScreenWidth, stage.fullScreenHeight);
			var screenHeight:int = Math.min(stage.fullScreenWidth, stage.fullScreenHeight);
			if (AndroidFullScreen.isSupported && AndroidFullScreen.isImmersiveModeSupported)
			{
				screenWidth = Math.max(AndroidFullScreen.immersiveWidth, AndroidFullScreen.immersiveHeight);
				screenHeight = Math.min(AndroidFullScreen.immersiveWidth, AndroidFullScreen.immersiveHeight);
				
				AndroidFullScreen.immersiveMode();
			}
			
			mStarling = new Starling(Game, stage, new Rectangle(0, 0, screenWidth, screenHeight));
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, gameStarted);
			if (screenWidth > 2048)
			{
				screenHeight = 2048 * screenHeight / screenWidth;
				screenWidth = 2048;
			}
			if (screenHeight > 2048)
			{
				screenWidth = 2048 * screenWidth / screenHeight;
				screenHeight = 2048;
			}
			mStarling.stage.stageWidth = screenWidth;
			mStarling.stage.stageHeight = screenHeight;
			//mStarling.showStats = true;
			//mStarling.simulateMultitouch = true;
			//mStarling.showStatsAt("right", "top", 1);
			mStarling.start();
		}
		
		private function gameStarted(e:starling.events.Event):void
		{
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, gameStarted);
			
			stage.quality = StageQuality.BEST;
			EmbeddedGraphics.Initialize(mStarling.stage.stageWidth, mStarling.stage.stageHeight);
			stage.quality = StageQuality.LOW;
			AE.assetManager.enqueue(EmbeddedGraphics);
			AE.assetManager.enqueue(EmbeddedSounds);
			AE.assetManager.enqueue(EmbeddedData);
			AE.game.background.color = 0xFFFFFFFF;
			
			AE.assetManager.loadQueue(loadingFunction);
		}
		
		private function loadingFunction(ratio:Number):void
		{
			if (ratio == 1)
			{
				//start game
				if (GameCenter.isSupported())
				{
					GameCenter.create(stage);
					if (GameCenter.gameCenter.isGameCenterAvailable())
					{
						GameCenter.gameCenter.authenticateLocalUser();
					}
				}
				
				if (GoogleGames.isSupported())
				{
					GoogleGames.create();
					GoogleGames.games.signIn();
				}
				
				Global.Initialize();
				if (Global.GetEnding() != EndingsData.NONE)
				{
					AE.game.ActiveWorld = new GameEndWorld(0);
				}
				else
				{
					AE.game.ActiveWorld = new GameplayWorld();
				}
				SilentSwitch.apply();
			}
		}
		
		private function Deactivate(e:flash.events.Event):void 
		{
			Starling.current.stop(true);
			AE.PauseEngine();
			Global.PauseMusic();
		}
		
		private function Activate(e:flash.events.Event):void
		{
			Starling.current.start();
			if (stage)
			{
				stage.quality = stage.quality;
			}
			AE.ResumeEngine();
			Global.ResumeMusic();
			SilentSwitch.apply();
			if (AndroidFullScreen.isSupported && AndroidFullScreen.isImmersiveModeSupported)
			{
				AndroidFullScreen.immersiveMode();
			}
		}
		
	}
	
}