package DivCircle.GameEntity.MenuEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.events.GameCenterErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.GameWorld.GameplayWorld;
	import DivCircle.Global;
	import DivCircle.LayerConstant;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameoverEntity extends Entity
	{
		private var image:Image;
		private var allText:Sprite;
		private var currentScore:Number;
		private var upperText:TextField;
		private var lowerText:TextField;
		private var playerScoreText:TextField;
		private var backButtonEntity:BackButtonEntity;
		
		public function GameoverEntity(playerScore:Number, backButton:BackButtonEntity) 
		{
			currentScore = playerScore;
			backButtonEntity = backButton;
			
			image = new Image(EmbeddedGraphics.rectangleTexture);
			image.scaleX = EmbeddedGraphics.screenWidth / image.width;
			image.scaleY = EmbeddedGraphics.screenHeight / image.height;
			
			var endingXML:XML = AE.assetManager.getXml("gameEndings");
			var upperString:String = "";
			var lowerString:String = "";
			var searchingIndex:int = 0;
			if (playerScore >= 750)
			{
				searchingIndex = Global.numberOfWins;
			}
			else
			{
				searchingIndex = -Global.numberOfLoses;
			}
			for each(var e:Object in endingXML.text)
			{
				var level:int = e.@level;
				if (searchingIndex == level)
				{
					upperString = e.upper[0];
					lowerString = e.lower[0];
					
					var pattern:RegExp = /\\n/g;
					upperString = upperString.replace(pattern, "\n");
					lowerString = lowerString.replace(pattern, "\n");
				}
			}
			
			upperText = new TextField(EmbeddedGraphics.screenWidth, 3 * 70 * EmbeddedGraphics.ConversionRatio, upperString, "gameFont", 50 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
			upperText.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			upperText.vAlign = VAlign.BOTTOM;
			upperText.x = EmbeddedGraphics.screenWidth / 2;
			upperText.y = EmbeddedGraphics.screenHeight / 2 - 40;
			
			playerScoreText = new TextField(EmbeddedGraphics.screenWidth, 70 * EmbeddedGraphics.ConversionRatio, Global.GetFixedNumberDigits(playerScore, 8), "gameFont", 60 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
			playerScoreText.alignPivot();
			playerScoreText.x = EmbeddedGraphics.screenWidth / 2 + Global.SHIFT_X * EmbeddedGraphics.ConversionRatio;
			playerScoreText.y = EmbeddedGraphics.screenHeight / 2 + Global.SHIFT_Y * EmbeddedGraphics.ConversionRatio;
			
			lowerText = new TextField(EmbeddedGraphics.screenWidth, 3 * 70 * EmbeddedGraphics.ConversionRatio, lowerString, "gameFont", 50 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
			lowerText.vAlign = VAlign.TOP;
			lowerText.alignPivot(HAlign.CENTER, VAlign.TOP);
			lowerText.x = EmbeddedGraphics.screenWidth / 2;
			lowerText.y = EmbeddedGraphics.screenHeight / 2 + 40;
			
			allText = new Sprite();
			allText.addChild(upperText);
			allText.addChild(playerScoreText);
			allText.addChild(lowerText);
			allText.alpha = 0;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(image);
			sprite.addChild(allText);
			graphic = sprite;
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function add():void 
		{
			super.add();
			
			var tween:Tween = new Tween(allText, 0.75, "linear");
			tween.fadeTo(1);
			Starling.current.juggler.add(tween);
			
			AE.AddPressFunction(FadeOut);
			
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				if (GameCenter.gameCenter.isUserAuthenticated())
				{
					SubmitScore();
				}
				else
				{
					GameCenter.gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED, UserAuth);
					GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.AUTH_FAILED, UserNotAuth);
					GameCenter.gameCenter.authenticateLocalUser();
				}
			}
			
			if (GoogleGames.isSupported())
			{
				if (GoogleGames.games.isSignedIn())
				{
					SubmitGoogleScore();
				}
				else
				{
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserGoogleAuth);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserGoogleNotAuth);
					GoogleGames.games.signIn();
				}
			}
		}
		
		override public function remove():void 
		{
			super.remove();
			
			allText.removeChildren();
			AE.RemovePressFunction(FadeOut);
		}
		
		private function SubmitScore():void
		{
			GameCenter.gameCenter.reportScoreForCategory(currentScore, Global.GetLeaderboardName());
		}
		
		private function SubmitGoogleScore():void
		{
			GoogleGames.games.submitScore(Global.GetLeaderboardName(), currentScore);
		}
		
		private function UserAuth(e:GameCenterEvent):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, UserAuth);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, UserNotAuth);
			
			SubmitScore();
		}
		
		private function UserGoogleAuth(e:GoogleGamesEvent):void
		{
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserGoogleAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserGoogleNotAuth);
			
			SubmitGoogleScore();
		}
		
		private function UserNotAuth(e:GameCenterErrorEvent):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, UserAuth);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, UserAuth);
		}
		
		private function UserGoogleNotAuth(e:GoogleGamesEvent):void
		{
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserGoogleAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserGoogleNotAuth);
		}
		
		private function FadeOut(tX:Number, tY:Number, tID:int):void
		{
			var tween:Tween = new Tween(allText, 0.5, "linear");
			tween.fadeTo(0);
			if (backButtonEntity.collidePoint(tX, tY, backButtonEntity.x, backButtonEntity.y))
			{
				tween.onComplete = GoToGameName;
			}
			else
			{
				tween.onComplete = GoToGamePlay;
			}
			Starling.current.juggler.add(tween);
			AE.RemovePressFunction(FadeOut);
		}
		
		private function GoToGamePlay():void
		{
			AE.game.ActiveWorld = new GameplayWorld(true);
		}
		
		private function GoToGameName():void
		{
			AE.game.ActiveWorld = new GameplayWorld(false);
		}
	}

}