package DivCircle.GameEntity.MenuEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.GameEntity.ControlEntity;
	import DivCircle.GameWorld.GameplayWorld;
	import DivCircle.Global;
	import DivCircle.LayerConstant;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameNameEntity extends Entity
	{
		private var control:ControlEntity;
		private var backButton:BackButtonEntity;
		private var whiteLayer:Image;
		private var gameName:TextField;
		private var tutorialText:TextField;
		private var touchToStart:TextField;
		private var gameByText:TextField;
		private var amidosText:TextField;
		private var musicByText:TextField;
		private var agentWhiskersText:TextField;
		private var writtenByText:TextField;
		private var talhaKayaText:TextField;
		private var creditsSprite:Sprite;
		private var replay:Boolean;
		private var appTween:Tween;
		private var disTween:Tween;
		private var touchAppTween:Tween;
		private var touchDisTween:Tween;
		private var gameNameTween:Tween;
		
		public function GameNameEntity(c:ControlEntity, b:BackButtonEntity) 
		{
			control = c;
			backButton = b;
			backButton.alpha = 0;
			replay = false;
			
			whiteLayer = new Image(EmbeddedGraphics.rectangleTexture);
			whiteLayer.scaleX = EmbeddedGraphics.screenWidth / whiteLayer.width;
			whiteLayer.scaleY = EmbeddedGraphics.screenHeight / whiteLayer.height;
			whiteLayer.alpha = 1;
			
			gameName = new TextField(EmbeddedGraphics.screenWidth, 120 * EmbeddedGraphics.ConversionRatio, "DIVCIRCLE", "gameFont", 120 * EmbeddedGraphics.ConversionRatio, 0xFFFFFFFF);
			gameName.alignPivot();
			gameName.blendMode = "invert";
			gameName.x = EmbeddedGraphics.screenWidth / 2;
			gameName.y = EmbeddedGraphics.screenHeight / 2 + gameName.height * 0.065;
			
			tutorialText = new TextField(EmbeddedGraphics.screenWidth, EmbeddedGraphics.screenHeight, "You are different but afraid to stand alone.\nSo go on, touch the screen and rotate, so you can blend with others.", "gameFont", 50 * EmbeddedGraphics.ConversionRatio, 0xFFFFFFFF);
			tutorialText.alignPivot();
			tutorialText.blendMode = "invert";
			tutorialText.x = EmbeddedGraphics.screenWidth / 2;
			tutorialText.y = EmbeddedGraphics.screenHeight / 2;
			tutorialText.alpha = 0;
			
			touchToStart = new TextField(EmbeddedGraphics.screenWidth, EmbeddedGraphics.ConversionRatio * 60, "Touch to Start", "gameFont", EmbeddedGraphics.ConversionRatio * 50, 0xFF777777);
			touchToStart.alignPivot();
			touchToStart.x = EmbeddedGraphics.screenWidth / 2;
			touchToStart.y = EmbeddedGraphics.screenHeight * 0.7;
			touchToStart.bold = true;
			touchToStart.alpha = 0;
			
			amidosText = new TextField(4 * EmbeddedGraphics.ConversionRatio * 35, EmbeddedGraphics.ConversionRatio * 35, "AMIDOS GAMES", "gameFont", EmbeddedGraphics.ConversionRatio * 35, 0xFF000000);
			amidosText.alignPivot("center", "bottom");
			amidosText.hAlign = "center";
			amidosText.x = EmbeddedGraphics.screenWidth / 2;
			amidosText.y = EmbeddedGraphics.screenHeight - EmbeddedGraphics.ConversionRatio * 5;
			
			gameByText = new TextField(EmbeddedGraphics.screenWidth, EmbeddedGraphics.ConversionRatio * 25, "Game By", "gameFont", EmbeddedGraphics.ConversionRatio * 25, 0xFF000000);
			gameByText.alignPivot("center", "bottom");
			gameByText.hAlign = "center";
			gameByText.x = amidosText.x;
			gameByText.y = amidosText.y - amidosText.height;
			
			agentWhiskersText = new TextField(4 * EmbeddedGraphics.ConversionRatio * 35, EmbeddedGraphics.ConversionRatio * 35, "Ben Burnes", "gameFont", EmbeddedGraphics.ConversionRatio * 35, 0xFF000000);
			agentWhiskersText.alignPivot("right", "bottom");
			agentWhiskersText.hAlign = "right";
			agentWhiskersText.x = EmbeddedGraphics.screenWidth - EmbeddedGraphics.ConversionRatio * 10;
			agentWhiskersText.y = EmbeddedGraphics.screenHeight - EmbeddedGraphics.ConversionRatio * 5;
			
			musicByText = new TextField(EmbeddedGraphics.screenWidth, EmbeddedGraphics.ConversionRatio * 25, "Music By", "gameFont", EmbeddedGraphics.ConversionRatio * 25, 0xFF000000);
			musicByText.alignPivot("right", "bottom");
			musicByText.hAlign = "right";
			musicByText.x = agentWhiskersText.x;
			musicByText.y = agentWhiskersText.y - agentWhiskersText.height;
			
			talhaKayaText = new TextField(4 * EmbeddedGraphics.ConversionRatio * 35, EmbeddedGraphics.ConversionRatio * 35, "Talha Kaya", "gameFont", EmbeddedGraphics.ConversionRatio * 35, 0xFF000000);
			talhaKayaText.alignPivot("left", "bottom");
			talhaKayaText.hAlign = "left";
			talhaKayaText.x = EmbeddedGraphics.ConversionRatio * 10;
			talhaKayaText.y = EmbeddedGraphics.screenHeight - EmbeddedGraphics.ConversionRatio * 5;
			
			writtenByText = new TextField(EmbeddedGraphics.screenWidth, EmbeddedGraphics.ConversionRatio * 25, "Written By", "gameFont", EmbeddedGraphics.ConversionRatio * 25, 0xFF000000);
			writtenByText.alignPivot("left", "bottom");
			writtenByText.hAlign = "left";
			writtenByText.x = talhaKayaText.x;
			writtenByText.y = talhaKayaText.y - amidosText.height;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(gameName);
			sprite.addChild(tutorialText);
			sprite.addChild(touchToStart);
			creditsSprite = new Sprite();
			creditsSprite.addChild(gameByText);
			creditsSprite.addChild(amidosText);
			creditsSprite.addChild(musicByText);
			creditsSprite.addChild(agentWhiskersText);
			creditsSprite.addChild(writtenByText);
			creditsSprite.addChild(talhaKayaText);
			sprite.addChild(creditsSprite);
			sprite.addChild(whiteLayer);
			graphic = sprite;
			layer = LayerConstant.TOP_LAYER;
		}
		
		override public function add():void 
		{
			super.add();
			
			gameNameTween = new Tween(whiteLayer, 0.5, "linear");
			gameNameTween.fadeTo(0);
			
			if (!replay)
			{
				gameNameTween.onComplete = ShowTouchToStart;
			}
			else
			{
				AE.AddPressFunction(StartGame); 
			}
			
			Starling.current.juggler.add(gameNameTween);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			creditsSprite.removeChildren();
		}
		
		private function ShowTouchToStart():void
		{
			Starling.current.juggler.remove(touchAppTween);
			Starling.current.juggler.remove(touchDisTween);
			
			AE.AddPressFunction(FadeGameName);
			
			touchAppTween = new Tween(touchToStart, 0.5, "linear");
			touchAppTween.fadeTo(1);
			Starling.current.juggler.add(touchAppTween);
		}
		
		private function HideTouchToStart():void
		{
			Starling.current.juggler.remove(touchAppTween);
			Starling.current.juggler.remove(touchDisTween);
			Starling.current.juggler.remove(gameNameTween);
			
			touchDisTween = new Tween(touchToStart, 0.5, "linear");
			touchDisTween.fadeTo(0);
			Starling.current.juggler.add(touchDisTween);
		}
		
		private function FadeGameName(tX:Number, tY:Number, tID:int):void
		{
			var amidosRect:Rectangle = new Rectangle(amidosText.x - amidosText.width / 2, amidosText.y - amidosText.height, amidosText.width, amidosText.height);
			var whiskerRect:Rectangle = new Rectangle(agentWhiskersText.x - agentWhiskersText.width, agentWhiskersText.y - agentWhiskersText.height, agentWhiskersText.width, agentWhiskersText.height);
			var talhaRect:Rectangle = new Rectangle(talhaKayaText.x, talhaKayaText.y - talhaKayaText.height, talhaKayaText.width, talhaKayaText.height);
			
			if (amidosRect.contains(tX, tY))
			{
				navigateToURL(new URLRequest(Global.AMIDOS_LINK), "_blank");
				return;
			}
			if (whiskerRect.contains(tX, tY))
			{
				navigateToURL(new URLRequest(Global.BUN_BURNES_LINK), "_blank");
				return;
			}
			if (talhaRect.contains(tX, tY))
			{
				navigateToURL(new URLRequest(Global.TALHA_KAYA_LINK), "_blank");
				return;
			}
			
			Starling.current.juggler.remove(gameNameTween);
			
			var tween:Tween = new Tween(gameName, 0.5, "linear");
			tween.fadeTo(0);
			Starling.current.juggler.add(tween);
			
			var bTween:Tween = new Tween(backButton, 0.5, "linear");
			bTween.fadeTo(1);
			Starling.current.juggler.add(bTween);
			
			appTween = new Tween(tutorialText, 0.75, "linear");
			appTween.fadeTo(1);
			Starling.current.juggler.add(appTween);
			
			HideTouchToStart();
			
			AE.RemovePressFunction(FadeGameName);
			AE.AddPressFunction(StartGame);
		}
		
		private function StartGame(tX:Number, tY:Number, tID:int):void
		{
			if (gameName.alpha > 0.5)
			{
				return;
			}
			
			var amidosRect:Rectangle = new Rectangle(amidosText.x, amidosText.y - amidosText.height, amidosText.width, amidosText.height);
			var whiskerRect:Rectangle = new Rectangle(agentWhiskersText.x - agentWhiskersText.width, agentWhiskersText.y - agentWhiskersText.height, agentWhiskersText.width, agentWhiskersText.height);
			
			if (amidosRect.contains(tX, tY))
			{
				navigateToURL(new URLRequest(Global.AMIDOS_LINK), "_blank");
				return;
			}
			if (whiskerRect.contains(tX, tY))
			{
				navigateToURL(new URLRequest(Global.BUN_BURNES_LINK), "_blank");
				return;
			}
			
			Starling.current.juggler.remove(appTween);
			disTween = new Tween(tutorialText, 0.5, "linear");
			disTween.fadeTo(0);
			Starling.current.juggler.add(disTween);
			
			if (backButton.collidePoint(tX, tY, backButton.x, backButton.y))
			{
				gameNameTween = new Tween(gameName, 0.5, "linear");
				gameNameTween.fadeTo(1);
				gameNameTween.onComplete = ShowTouchToStart;
				Starling.current.juggler.add(gameNameTween);
				
				var bTween:Tween = new Tween(backButton, 0.5, "linear");
				bTween.fadeTo(0);
				Starling.current.juggler.add(bTween);
				
				AE.AddPressFunction(FadeGameName);
			}
			else
			{
				control.StartGame();
				
				var cTween:Tween = new Tween(creditsSprite, 0.5, "linear");
				cTween.fadeTo(0);
				Starling.current.juggler.add(cTween);
				
				backButton.backFunction = BackToGameName;
			}
			
			AE.RemovePressFunction(StartGame);
		}
		
		private function BackToGameName():void
		{
			backButton.backFunction = null;
			control.CloseGame();
		}
		
		public function StartDirectGame():void
		{
			gameName.alpha = 0;
			tutorialText.alpha = 1;
			backButton.alpha = 1;
			replay = true;
		}
	}

}