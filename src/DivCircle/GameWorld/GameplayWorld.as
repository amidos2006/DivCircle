package DivCircle.GameWorld 
{
	import AmidosEngine.AE;
	import DivCircle.GameData.EmbeddedGraphics;
	import DivCircle.GameEntity.*;
	import DivCircle.GameEntity.MenuEntity.BackButtonEntity;
	import DivCircle.GameEntity.MenuEntity.GameNameEntity;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameplayWorld extends BaseWorld
	{	
		private var background:BackgroundEntity;
		private var circle:CircleEntity;
		private var hudEntity:HUDEntity;
		private var control:ControlEntity;
		private var gameNameEntity:GameNameEntity;
		private var backButton:BackButtonEntity;
		
		public function GameplayWorld(enterGame:Boolean = false) 
		{
			background = new BackgroundEntity();
			circle = new CircleEntity();
			hudEntity = new HUDEntity();
			control = new ControlEntity(circle, background, hudEntity);
			backButton = new BackButtonEntity(null, true);
			gameNameEntity = new GameNameEntity(control, backButton);
			
			AddEntity(background);
			AddEntity(circle);
			AddEntity(hudEntity);
			AddEntity(control);
			AddEntity(gameNameEntity);
			AddEntity(backButton);
			if (enterGame)
			{
				gameNameEntity.StartDirectGame();
			}
		}
		
	}

}