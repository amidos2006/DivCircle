package DivCircle 
{
	import AmidosEngine.AE;
	import AmidosEngine.Data;
	import AmidosEngine.Sfx;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import DivCircle.GameData.ActionGroup;
	import DivCircle.GameData.EndingsData;
	import flash.display3D.Context3DBlendFactor;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import starling.display.BlendMode;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Global 
	{
		[Embed(source="../../assets/Montepetrum bold.ttf", embedAsCFF="false", fontFamily="gameFont")]private static const fontClass:Class;
		
		public static const SHIFT_X:Number = 0;
		public static const SHIFT_Y:Number = 0;
		public static const AMIDOS_LINK:String = "http://www.amidos-games.com";
		public static const BUN_BURNES_LINK:String = "http://www.abstractionmusic.com/";
		public static const TALHA_KAYA_LINK:String = "http://www.kayabros.com/";
		private static const SAVE_FILE_NAME:String = "DivCircleSaveFile"
		private static const MUSIC_DEC:Number = -0.75;
		private static const VOLUME_SCALE:Number = 0.5;
		private static const DEATH_SCALE:Number = 1;
		
		public static var firstColorArray:Array = [0xFF000000];
		public static var secondColorArray:Array = [0xFFFFFFFF];
		public static var currentIndex:int = 0;
		public static var currentFirstColor:uint;
		public static var currentSecondColor:uint;
		
		public static var normalVolume:Number;
		public static var currentSpeedPercentage:Number;
		public static var numberOfWins:int;
		public static var numberOfLoses:int;
		public static var numberOfTotalLoses:int;
		public static var numberOfWinEndings:int;
		public static var numberOfLoseEndings:int;
		public static var numberOfTotalEndings:int;
		
		private static var musicLayer1Sfx:Sfx;
		private static var musicLayer2Sfx:Sfx;
		private static var musicLayer3Sfx:Sfx;
		private static var musicLayer4Sfx:Sfx;
		public static var deathSfx:Sfx;
		private static var pausePosition:Number;
		private static var deathPausePosition:Number;
		private static var death:Boolean;
		private static var deathFactor:Number;
		
		public static function Initialize():void
		{
			currentFirstColor = firstColorArray[currentIndex];
			currentSecondColor = secondColorArray[currentIndex];
			death = true;
			deathFactor = 0;
			normalVolume = 0;
			currentSpeedPercentage = 0;
			pausePosition = 0;
			deathPausePosition = 0;
			numberOfWins = 0;
			numberOfLoses = 0;
			numberOfTotalLoses = 0;
			
			musicLayer1Sfx = new Sfx(AE.assetManager.getSound("layer1"));
			musicLayer2Sfx = new Sfx(AE.assetManager.getSound("layer2"));
			musicLayer3Sfx = new Sfx(AE.assetManager.getSound("layer3"));
			musicLayer4Sfx = new Sfx(AE.assetManager.getSound("layer4"));
			deathSfx = new Sfx(AE.assetManager.getSound("death"));
			
			LoadData();
			
			BlendMode.register("invert", Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR, true);
		}
		
		public static function UpdateSound(dt:Number):void
		{
			if (musicLayer1Sfx == null)
			{
				return;
			}
			
			if (death)
			{
				deathFactor += MUSIC_DEC * dt;
				
				if (deathFactor <= 0)
				{
					deathFactor = 0;
					
					musicLayer1Sfx.Stop();
					musicLayer2Sfx.Stop();
					musicLayer3Sfx.Stop();
					musicLayer4Sfx.Stop();
					
					return;
				}
			}
			else
			{
				deathFactor = 1;
			}
			
			var totalVolume:Number = 0;
			for (var i:int = 0; i < 4; i++) 
			{
				totalVolume += GetVolume(i);
			}
			totalVolume = 1;
			
			musicLayer1Sfx.volume = (normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(0) / totalVolume;
			musicLayer2Sfx.volume = (normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(1) / totalVolume;
			musicLayer3Sfx.volume = (normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(2) / totalVolume;
			musicLayer4Sfx.volume = (normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(3) / totalVolume;
			
			deathSfx.volume = (1 - normalVolume) * DEATH_SCALE;
		}
		
		public static function GetVolume(layerNumber:int):Number
		{
			var volume:Number = 0;
			
			if (layerNumber == 0)
			{
				volume = 1;
			}
			
			if (layerNumber == 1)
			{
				volume = (currentSpeedPercentage - 0.2) / 0.2;
			}
			
			if (layerNumber == 2)
			{
				volume = (currentSpeedPercentage - 0.5) / 0.2;
			}
			
			if (layerNumber == 3)
			{
				volume = (currentSpeedPercentage - 0.8) / 0.2;
			}
			
			if (volume < 0)
			{
				volume = 0;
			}
			
			if (volume > 1)
			{
				volume = 1;
			}
			
			return volume;
		}
		
		public static function PlayDeathSfx(position:Number = 0):void
		{
			deathSfx.Loop((1 - normalVolume) * DEATH_SCALE, 0, position);
		}
		
		private static function ResumeDeathSfx():void
		{
			if (deathPausePosition >= 0 && !isNaN(deathPausePosition))
			{
				PlayDeathSfx(deathPausePosition);
			}
		}
		
		private static function PauseDeathSfx():void
		{
			if (deathSfx.playing)
			{
				deathPausePosition = deathSfx.position;
				deathSfx.Stop();
			}
			else
			{
				deathPausePosition = -1;
			}
		}
		
		public static function StopDeathSfx():void
		{
			if (death)
			{
				deathPausePosition = -1;
				deathSfx.Stop();
			}
		}
		
		public static function PlayMusic(position:Number = 0):void
		{
			death = false;
			normalVolume = 1;
			deathFactor = 1;
			
			var totalVolume:Number = 0;
			for (var i:int = 0; i < 4; i++) 
			{
				totalVolume += GetVolume(i);
			}
			totalVolume = 1;
			
			musicLayer1Sfx.Loop((normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(0) / totalVolume, 0, position);
			musicLayer2Sfx.Loop((normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(1) / totalVolume, 0, position);
			musicLayer3Sfx.Loop((normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(2) / totalVolume, 0, position);
			musicLayer4Sfx.Loop((normalVolume * (1 - VOLUME_SCALE) + VOLUME_SCALE) * deathFactor * GetVolume(3) / totalVolume, 0, position);
		}
		
		public static function PauseMusic():void
		{
			if (musicLayer1Sfx.playing)
			{
				pausePosition = deathSfx.position;
				musicLayer1Sfx.Stop();
				musicLayer2Sfx.Stop();
				musicLayer3Sfx.Stop();
				musicLayer4Sfx.Stop();
			}
			else
			{
				pausePosition = -1;
			}
			
			PauseDeathSfx();
		}
		
		public static function ResumeMusic():void
		{
			if (pausePosition >= 0 && !death && !isNaN(pausePosition))
			{
				PlayMusic(pausePosition);
			}
			
			ResumeDeathSfx();
		}
		
		public static function StopMusic():void
		{
			death = true;
			normalVolume = 0;
		}
		
		public static function GetAngle(p1X:Number, p1Y:Number, p2X:Number, p2Y:Number):Number
		{
			var currentAngle:Number = Math.atan2(p2Y - p1Y, p2X - p1X) * 180 / Math.PI;
			if (currentAngle < 0)
			{
				currentAngle += 360;
			}
			return currentAngle;
		}
		
		public static function GetSign(number:Number):int
		{
			if (number < 0)
			{
				return -1;
			}
			return 1;
		}
		
		public static function GetRandom(max:int):int
		{
			var randomValue:Number = Math.random() * max;
			return Math.floor(randomValue);
		}
		
		public static function GetFixedNumberDigits(number:Number, length:int = 10):String
		{
			var string:String = Math.floor(number).toString();
			var count:Number = length - string.length;
			for (var i:int = 0; i < count; i += 1)
			{
				string = "0" + string;
			}
			
			return string;
		}
		
		public static function GetLeaderboardName():String
		{
			if (GoogleGames.isSupported())
			{
				return "CgkIxbfn46gNEAIQAQ";
			}
			
			if (GameCenter.isSupported())
			{
				return "DivCircle_LeaderBoard";
			}
			
			return "";
		}
		
		public static function GetAchievement(endingType:int):String
		{
			if (GoogleGames.isSupported())
			{
				if (endingType == EndingsData.BLEND)
				{
					return "CgkIxbfn46gNEAIQAg";
				}
				if (endingType == EndingsData.NOT_BLEND)
				{
					return "CgkIxbfn46gNEAIQAw";
				}
			}
			
			if (GameCenter.isSupported())
			{
				if (endingType == EndingsData.BLEND)
				{
					return "Blending_Achievement";
				}
				if (endingType == EndingsData.NOT_BLEND)
				{
					return "Yourself_Achievement";
				}
			}
			
			return "";
		}
		
		public static function GetEnding():int
		{
			if (Global.numberOfWins > Global.numberOfWinEndings)
			{
				return EndingsData.BLEND;
			}
			
			if (Global.numberOfLoses > Global.numberOfLoseEndings)
			{
				return EndingsData.NOT_BLEND;
			}
			
			if (Global.numberOfTotalLoses > Global.numberOfTotalEndings)
			{
				return EndingsData.BLEND;
			}
			
			return EndingsData.NONE;
		}
		
		public static function SaveData():void
		{
			Data.writeInt("numberOfWins", numberOfWins);
			Data.writeInt("numberOfLoses", numberOfLoses);
			Data.writeInt("numberOfTotalLoses", numberOfTotalLoses);
			
			Data.save(SAVE_FILE_NAME);
		}
		
		public static function LoadData():void
		{
			Data.load(SAVE_FILE_NAME);
			
			numberOfWins = Data.readInt("numberOfWins", 0);
			numberOfLoses = Data.readInt("numberOfLoses", 0);
			numberOfTotalLoses = Data.readInt("numberOfTotalLoses", 0);
			
			numberOfWinEndings = AE.assetManager.getXml("gameEndings").@winNumber;
			numberOfLoseEndings = AE.assetManager.getXml("gameEndings").@loseNumber;
			numberOfTotalEndings = AE.assetManager.getXml("gameEndings").@totalNumber;
		}
	}

}