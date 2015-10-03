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
	import DivCircle.GameData.EndingsData;
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
	public class GameEndEntity extends Entity
	{
		private var image:Image;
		private var allText:Sprite;
		private var currentScore:Number;
		private var textArray:Array;
		private var descriptionText:TextField;
		private var currentText:int;
		private var resetButtonEntity:GameButtonEntity;
		private var scoreButtonEntity:GameButtonEntity;
		private var restText:TextField;
		private var scoreText:TextField;
		
		public function GameEndEntity(playerScore:Number, resetButton:GameButtonEntity, scoreButton:GameButtonEntity = null) 
		{
			currentScore = playerScore;
			resetButtonEntity = resetButton;
			resetButtonEntity.buttonFunction = GoToGameName;
			resetButtonEntity.active = false;
			resetButtonEntity.visible = false;
			
			scoreButtonEntity = scoreButton;
			if (scoreButtonEntity != null)
			{
				scoreButtonEntity.active = false;
				scoreButtonEntity.visible = false;
				scoreButtonEntity.buttonFunction = ShowScores;
				if (GoogleGames.isSupported())
				{
					scoreButtonEntity.buttonFunction = ShowGoogleScores;
				}
			}
			currentText = 0;
			
			image = new Image(EmbeddedGraphics.rectangleTexture);
			image.scaleX = EmbeddedGraphics.screenWidth / image.width;
			image.scaleY = EmbeddedGraphics.screenHeight / image.height;
			
			var endingXML:XML = AE.assetManager.getXml("gameEndings");
			var string:String;
			var text:TextField;
			textArray = new Array();
			allText = new Sprite();
			
			if (Global.GetEnding() == EndingsData.BLEND)
			{
				endingXML = endingXML.ending[0];
			}
			else
			{
				endingXML = endingXML.ending[1];
			}
			
			for each(var e:String in endingXML.text)
			{
				string = e;
				var pattern:RegExp = /\\n/g;
				string = string.replace(pattern, "\n");
				text = new TextField(EmbeddedGraphics.screenWidth, EmbeddedGraphics.screenHeight, string, "gameFont", 60 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
				text.alignPivot();
				text.alpha = 0;
				text.x = EmbeddedGraphics.screenWidth / 2 + Global.SHIFT_X * EmbeddedGraphics.ConversionRatio;
				text.y = EmbeddedGraphics.screenHeight / 2 + Global.SHIFT_Y * EmbeddedGraphics.ConversionRatio;
				textArray.push(text);
				
				allText.addChild(text);
			}
			
			descriptionText = new TextField(EmbeddedGraphics.screenWidth, 40 * EmbeddedGraphics.ConversionRatio, "(Touch to Continue)", "gameFont", 30 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
			descriptionText.alignPivot();
			descriptionText.x = EmbeddedGraphics.screenWidth / 2 + Global.SHIFT_X * EmbeddedGraphics.ConversionRatio;
			descriptionText.y = EmbeddedGraphics.screenHeight - 100 * EmbeddedGraphics.ConversionRatio;
			descriptionText.alpha = 0;
			
			restText = new TextField(200 * EmbeddedGraphics.ConversionRatio, 40 * EmbeddedGraphics.ConversionRatio, "Reset Game", "gameFont", 30 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
			restText.alignPivot();
			restText.x = resetButtonEntity.x;
			restText.y = resetButtonEntity.y + 40 * EmbeddedGraphics.ConversionRatio;
			restText.alpha = 0;
			
			if (scoreButtonEntity != null)
			{
				scoreText = new TextField(200 * EmbeddedGraphics.ConversionRatio, 40 * EmbeddedGraphics.ConversionRatio, "See your Friends", "gameFont", 30 * EmbeddedGraphics.ConversionRatio, 0xFF000000);
				scoreText.alignPivot();
				scoreText.x = scoreButtonEntity.x;
				scoreText.y = scoreButtonEntity.y + 40 * EmbeddedGraphics.ConversionRatio;
				scoreText.alpha = 0;
				allText.addChild(scoreText);
			}
			
			allText.addChild(restText)
			allText.addChild(descriptionText);
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(image);
			sprite.addChild(allText);
			graphic = sprite;
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function add():void 
		{
			super.add();
			
			var tween:Tween = new Tween(textArray[currentText], 0.75, "linear");
			tween.fadeTo(1);
			tween.onComplete = AddPressFunction;
			Starling.current.juggler.add(tween);
			
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				if (GameCenter.gameCenter.isUserAuthenticated())
				{
					SubmitScore();
					SubmitAchievement();
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
					SubmitGoogleAchievement();
				}
				else
				{
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserGoogleAuth);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserGoogleNotAuth);
					GoogleGames.games.signIn();
				}
			}
		}
		
		private function AddPressFunction():void
		{
			descriptionText.alpha = 1;
			AE.AddPressFunction(PressFunction);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			allText.removeChildren();
			AE.RemovePressFunction(PressFunction);
		}
		
		private function SubmitAchievement():void
		{
			GameCenter.gameCenter.reportAchievement(Global.GetAchievement(Global.GetEnding()), 100);
		}
		
		private function SubmitGoogleAchievement():void
		{
			GoogleGames.games.unlockAchievement(Global.GetAchievement(Global.GetEnding()));
		}
		
		private function SubmitScore():void
		{
			if (currentScore <= 0)
			{
				return;
			}
			
			GameCenter.gameCenter.reportScoreForCategory(currentScore, Global.GetLeaderboardName());
		}
		
		private function SubmitGoogleScore():void
		{
			if (currentScore <= 0)
			{
				return;
			}
			
			GoogleGames.games.submitScore(Global.GetLeaderboardName(), currentScore);
		}
		
		private function UserAuth(e:GameCenterEvent):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, UserAuth);
			GameCenter.gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, UserNotAuth);
			
			SubmitScore();
			SubmitAchievement();
		}
		
		private function UserGoogleAuth(e:GoogleGamesEvent):void
		{
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserGoogleAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserGoogleNotAuth);
			
			SubmitGoogleScore();
			SubmitGoogleAchievement();
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
		
		private function PressFunction(tX:Number, tY:Number, tID:int):void
		{
			var tween:Tween = new Tween(textArray[currentText], 0.5, "linear");
			tween.fadeTo(0);
			Starling.current.juggler.add(tween);
			
			currentText += 1;
			tween = new Tween(textArray[currentText], 0.5, "linear");
			tween.fadeTo(1);
			Starling.current.juggler.add(tween);
			
			if (currentText >= textArray.length - 1)
			{
				descriptionText.alpha = 0;
				resetButtonEntity.visible = true;
				resetButtonEntity.active = true;
				restText.alpha = 1;
				
				if (scoreButtonEntity != null)
				{
					scoreButtonEntity.visible = true;
					scoreButtonEntity.active = true;
					scoreText.alpha = 1;
				}
				
				AE.RemovePressFunction(PressFunction);
			}
		}
		
		private function GoToGameName():void
		{
			Global.numberOfWins = 0;
			Global.numberOfLoses = 0;
			Global.numberOfTotalLoses = 0;
			Global.SaveData();
			AE.game.ActiveWorld = new GameplayWorld(false);
		}
		
		private function ShowScores():void
		{
			GameCenter.gameCenter.showLeaderboardForCategory(Global.GetLeaderboardName());
		}
		
		private function ShowGoogleScores():void
		{
			GoogleGames.games.showLeaderboard(Global.GetLeaderboardName());
		}
	}

}