package DivCircle.GameEntity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import DivCircle.GameData.Action;
	import DivCircle.GameData.ActionGroup;
	import DivCircle.GameData.EndingsData;
	import DivCircle.GameWorld.GameEndWorld;
	import DivCircle.GameWorld.GameoverWorld;
	import DivCircle.GameWorld.GameplayWorld;
	import DivCircle.Global;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ControlEntity extends Entity
	{
		private const DAMAGE_PER_ANGLE:Number = 2;
		private const DAMAGE_COOLDOWN:Number = -10;
		private const MAX_DAMAGE:Number = 100;
		
		private const MAX_SPEED:Number = 90;
		private const MAX_SPEED_SHIFT:Number = 30;
		private const SPEED_SHIFT_FACTOR:Number = 10 / 1000;
		private const MIN_SPEED:Number = 20;
		
		private const MIN_SLOW:Number = 0.4;
		private const SLOW_FACTOR:Number = 0.05 / 750;
		private const MAX_SLOW:Number = 0.7;
		
		private const LIVING_SCORE:Number = 30;
		private const SCORE_PER_ANGLE:Number = -0.5;
		
		private const MIN_SCORE_GAP:Number = 100;
		private const MAX_SCORE_GAP:Number = 250;
		private const SCORE_GAP_FACTOR:Number = -30 / 1000;
		
		private const MIN_REVERSE_GAP:Number = 2;
		private const REVERSE_GAP_FACTOR:Number = 1 / 500;
		private const MAX_REVERSE_GAP:Number = 8;
		
		private const MAX_ACTIONS:int = 200;
		
		private const SPEED_AMOUNT:Number = 10;
		private const SPEED_FAST_AMOUNT:Number = 20;
		private const SLOW_AMOUNT:Number = -10;
		private const SLOW_FAST_AMOUNT:Number = -20;
		
		private var circle:CircleEntity;
		private var background:BackgroundEntity;
		private var hud:HUDEntity;
		
		private var score:Number;
		private var damage:Number;
		private var gameStart:Boolean;
		private var gameEnds:Boolean;
		
		private var scoreGap:Number;
		private var maxScoreGap:Number;
		
		private var reverseGap:int;
		private var maxReverseGap:int;
		
		private var speedShift:Number;
		private var slowFactor:Number;
		
		private var actionGroups:Array;
		private var currentActions:Array;
		
		public function ControlEntity(c:CircleEntity, b:BackgroundEntity, h:HUDEntity) 
		{
			circle = c;
			background = b;
			hud = h;
			
			score = 0;
			damage = 0;
			gameStart = false;
			gameEnds = false;
			speedShift = 0;
			slowFactor = MIN_SLOW;
			
			maxScoreGap = MAX_SCORE_GAP;
			scoreGap = maxScoreGap;
			
			maxReverseGap = MIN_REVERSE_GAP;
			reverseGap = maxReverseGap;
			
			currentActions = new Array();
			actionGroups = new Array();
			actionGroups.push(new ActionGroup(0, SPEED_AMOUNT, [Action.SPEED]));
			actionGroups.push(new ActionGroup(300, SPEED_FAST_AMOUNT, [Action.SPEED_FAST]));
			actionGroups.push(new ActionGroup(500, SLOW_AMOUNT, [Action.SLOW]));
			actionGroups.push(new ActionGroup(900, SLOW_FAST_AMOUNT, [Action.SLOW_FAST]));
			actionGroups.push(new ActionGroup(400, 0, [Action.REVERSE]));
			actionGroups.push(new ActionGroup(1300, SPEED_FAST_AMOUNT, [Action.SPEED_REVERSE]));
			actionGroups.push(new ActionGroup(1500, SLOW_FAST_AMOUNT, [Action.SLOW_REVERSE]));
			actionGroups.push(new ActionGroup(900, 0, [Action.REVERSE, Action.REVERSE]));
			actionGroups.push(new ActionGroup(2000, 2 * SPEED_FAST_AMOUNT, [Action.SPEED_FAST, Action.SPEED_FAST, Action.SLOW_FAST]));
			actionGroups.push(new ActionGroup(1800, SLOW_FAST_AMOUNT, [Action.SLOW_FAST, Action.SPEED_FAST]));
			actionGroups.push(new ActionGroup(2500, SPEED_FAST_AMOUNT, [Action.SPEED_REVERSE, Action.SLOW_FAST, Action.SPEED_REVERSE]));
			actionGroups.push(new ActionGroup(3000, SPEED_FAST_AMOUNT, [Action.REVERSE, Action.SPEED_FAST, Action.REVERSE, Action.SLOW_FAST, Action.REVERSE]));
			actionGroups.push(new ActionGroup(3000, 2 * SPEED_FAST_AMOUNT, [Action.SPEED_FAST, Action.SPEED_FAST, Action.REVERSE]));
			actionGroups.push(new ActionGroup(2500, SPEED_FAST_AMOUNT, [Action.SPEED_REVERSE, Action.SLOW_REVERSE, Action.SPEED_REVERSE]));
		}
		
		override public function add():void 
		{
			super.add();
		}
		
		public function StartGame():void
		{
			gameStart = true;
			background.ChangeRotationSpeed(MIN_SPEED, 3);
			circle.notStart = false;
			hud.ShowHUD();
			Global.PlayMusic();
			Global.PlayDeathSfx();
		}
		
		private function GoToMainMenu():void
		{
			AE.game.ActiveWorld = new GameplayWorld(false);
			Global.StopMusic();
			Global.StopDeathSfx();
		}
		
		public function CloseGame():void
		{
			if (gameEnds)
			{
				return;
			}
			gameEnds = true;
			
			var damageTween:Tween = new Tween(hud, 0.5, "linear");
			damageTween.animate("damage", MAX_DAMAGE);
			damageTween.onComplete = GoToMainMenu;
			Starling.current.juggler.add(damageTween);
		}
		
		private function GetCurrentSpeed():Number
		{
			var currentSpeed:Number = Math.abs(background.rotationSpeed);
			for each(var a:int in currentActions)
			{
				switch (a) 
				{
					case Action.SPEED:
						currentSpeed += SPEED_AMOUNT;
						break;
					case Action.SPEED_FAST:
						currentSpeed += SPEED_FAST_AMOUNT;
						break;
					case Action.SLOW:
						currentSpeed += SLOW_AMOUNT;
						break;
					case Action.SLOW_FAST:
						currentSpeed += SLOW_FAST_AMOUNT;
						break;
					case Action.SPEED_REVERSE:
						currentSpeed += SPEED_FAST_AMOUNT;
						break;
					case Action.SLOW_REVERSE:
						currentSpeed += SLOW_FAST_AMOUNT;
						break;
				}
			}
			
			return currentSpeed;
		}
		
		private function GetPossibleGroup(isReverse:Boolean):ActionGroup
		{
			var possibleArray:Array = new Array();
			var reverseArray:Array = new Array();
			for each (var group:ActionGroup in actionGroups) 
			{
				if (score > group.scoreLimit)
				{
					var currentSpeed:Number = GetCurrentSpeed();
					if ((currentSpeed + group.speedLimit <= MAX_SPEED + speedShift && group.speedLimit >= 0) || 
						(currentSpeed + group.speedLimit >= MIN_SPEED + speedShift && group.speedLimit <= 0))
					{
						if (group.speedLimit < 0)
						{
							if ((currentSpeed + group.speedLimit) / (MAX_SPEED + speedShift) >= slowFactor)
							{
								possibleArray.push(group);
							}
						}
						else
						{
							possibleArray.push(group);
						}
						
						if (group.ContainsReverse())
						{
							reverseArray.push(group);
						}
					}
				}
			}
			
			if (isReverse && reverseArray.length > 0)
			{
				return reverseArray[Global.GetRandom(reverseArray.length)];
			}
			
			if (possibleArray.length > 0)
			{
				return possibleArray[Global.GetRandom(possibleArray.length)];
			}
			
			return null;
		}
		
		private function UpdateActions(scoreIncrement:Number):void
		{
			scoreGap -= scoreIncrement;
			if (scoreGap <= 0)
			{
				scoreGap = maxScoreGap;
				
				var actionString:String = "";
				for each (var atest:int in currentActions) 
				{
					actionString += atest.toString() + ",";
				}
				var action:int = currentActions[0];
				currentActions.splice(0, 1);
				switch (action) 
				{
					case Action.SPEED:
						background.ChangeRotationSpeed(background.rotationSpeed + Global.GetSign(background.rotationSpeed) * SPEED_AMOUNT);
						break;
					case Action.SPEED_FAST:
						background.ChangeRotationSpeed(background.rotationSpeed + Global.GetSign(background.rotationSpeed) * SPEED_FAST_AMOUNT);
						break;
					case Action.SLOW:
						background.ChangeRotationSpeed(background.rotationSpeed + Global.GetSign(background.rotationSpeed) * SLOW_AMOUNT);
						break;
					case Action.SLOW_FAST:
						background.ChangeRotationSpeed(background.rotationSpeed + Global.GetSign(background.rotationSpeed) * SLOW_FAST_AMOUNT);
						break;
					case Action.REVERSE:
						background.ChangeDirection();
						break;
					case Action.SPEED_REVERSE:
						background.ChangeRotationSpeed(-(background.rotationSpeed + Global.GetSign(background.rotationSpeed) * SPEED_FAST_AMOUNT));
						break;
					case Action.SLOW_REVERSE:
						background.ChangeRotationSpeed(-(background.rotationSpeed + Global.GetSign(background.rotationSpeed) * SLOW_FAST_AMOUNT));
						break;
				}
				
				if (currentActions.length < MAX_ACTIONS)
				{
					reverseGap -= 1;
					var randomGroup:ActionGroup = GetPossibleGroup(reverseGap <= 0);
					if (randomGroup.ContainsReverse())
					{
						reverseGap = maxReverseGap;
					}
					
					for each (var a:int in randomGroup.actions) 
					{
						currentActions.push(a);
					}
				}
			}
			
			maxScoreGap = MAX_SCORE_GAP + score * SCORE_GAP_FACTOR;
			if (maxScoreGap < MIN_SCORE_GAP)
			{
				maxScoreGap = MIN_SCORE_GAP;
			}
			
			maxReverseGap = MIN_REVERSE_GAP + Math.floor(score * REVERSE_GAP_FACTOR);
			if (maxReverseGap > MAX_REVERSE_GAP)
			{
				maxReverseGap = MAX_REVERSE_GAP;
			}
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			
			if (!gameStart || gameEnds)
			{
				return;
			}
			
			damage += DAMAGE_COOLDOWN * dt;
			var difference:Number = circle.CurrentAngle - background.CurrentAngle;
			if (difference > 180)
			{
				difference -= 360;
			}
			if (difference < -180)
			{
				difference += 360;
			}
			difference = Math.abs(difference);
			damage += DAMAGE_PER_ANGLE * difference * dt;
			if (damage < 0)
			{
				damage = 0;
			}
			Global.normalVolume = 1 - damage / MAX_DAMAGE;
			Global.currentSpeedPercentage = (background.targetSpeed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED);
			
			if (damage > MAX_DAMAGE)
			{
				damage = MAX_DAMAGE;
				if (score >= 750)
				{
					Global.numberOfWins += 1;
					Global.numberOfLoses = 0;
				}
				else
				{
					Global.numberOfLoses += 1;
					Global.numberOfTotalLoses += 1;
				}
				Global.SaveData();
				
				if (Global.GetEnding() != EndingsData.NONE)
				{
					AE.game.ActiveWorld = new GameEndWorld(score);
				}
				else
				{
					AE.game.ActiveWorld = new GameoverWorld(score);
				}
				Global.StopMusic();
				return;
			}
			
			var scoreDiff:Number = difference * SCORE_PER_ANGLE;
			if (Math.abs(scoreDiff) > LIVING_SCORE / 2)
			{
				scoreDiff = - LIVING_SCORE / 2;
			}
			var scoreIncrement:Number = (LIVING_SCORE + scoreDiff) * dt;
			score += scoreIncrement;
			
			speedShift = score * SPEED_SHIFT_FACTOR;
			if (speedShift >= MAX_SPEED_SHIFT)
			{
				speedShift = MAX_SPEED_SHIFT;
			}
			
			slowFactor = MIN_SLOW + score * SLOW_FACTOR;
			if (slowFactor > MAX_SLOW)
			{
				slowFactor = MAX_SLOW;
			}
			
			UpdateActions(scoreIncrement);
			
			hud.damage = damage;
			hud.score = score;
		}
	}

}