package app_objects
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;


	public class LodingObject extends Sprite
	{
		private var objectType:String;
		public var isComplete:Boolean;

		private var animation:MovieClip;
		private var sAssets:AssetManager;

		public function LodingObject()
		{
			//super();
			//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public function createAnimation(assets:AssetManager):void
		{
			sAssets = assets;
			isComplete = false;
			
			animation = new MovieClip(sAssets.getTextures("loading"), 25);
			animation.loop = true;
			animation.x = Math.ceil(-animation.width/2);
			animation.y = Math.ceil(-animation.height/2);

			starling.core.Starling.juggler.add(animation);
			this.addChild(animation);


			animation.addEventListener(Event.COMPLETE, animationComplete);

			//animation.stop();

		}
		public function animationComplete(e:Event):void
		{
			//trace("Complete !!!!");
			//stopAnimation();
			//isComplete = true;
//			removeAnimation();
		}

		public function playAnimation():void
		{
			if(animation.isPlaying == false && animation.isComplete == false){
				//trace("play");
				animation.play();
				isComplete = false;
			}
		}
		public function pauseAnimation():void
		{
			if(animation.isPlaying == true){
				//trace("pause");
				animation.pause();
			}
		}
		public function stopAnimation():void
		{
			if(animation.isPlaying == true){
				//trace("stop");
				animation.stop();
			}
		}
		public function removeAnimation():void
		{
			trace("Remove !!!!");

			animation.dispose();
			this.removeChild(animation);
			this.removeFromParent(true);
			this.dispose();
		}
	}
}
