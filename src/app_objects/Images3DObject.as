package app_objects
{

	import flash.html.__HTMLScriptFunction;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

    import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchPhase;
    import starling.events.EnterFrameEvent;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.utils.AssetManager;
	import starling.display.Canvas;
    import starling.animation.Juggler;
    import starling.animation.Transitions;

	import com.greensock.*;
	import com.greensock.easing.*;

	import flash.utils.getTimer;
	import flash.filesystem.File;
	import flash.geom.*;

    import app_events.Image3DEvent;


	public class Images3DObject extends Sprite
	{
        private var _juggler:Juggler;

        private var _loading:LodingObject;

		private var pic:Image;
		private var sAssets:AssetManager;
		private var rectMask:Canvas;
		private var galleryContainer:Sprite;
		private var picContainer:Sprite;

		private var intervalID:uint;
		private var touchPosition:Point;
		private var i:Number;
		private var l:Number;
		private var j:Number;
		private var k:Number;
		private var picNum:Number;
		private var picWidth:Number;
		private var totalImages:Number;
		public var galleryPosX:Number;

		private var filesList:Array;

		private var picDownPosition:Point;
		private var picUpPosition:Point;
		private var prvTouched:Number;
		private var currentTouched:Number;
		private var startTouchTime:Number;
		private var endTouchTime:Number;
		private var elapsedTime:Number;

        private var startX:Number;
        private var startFrame:int;
        private var changeDistance:int;
        private var travelDistance:int;

		private var picObject:Vector.<Image> = new Vector.<Image>();
		private var currentTexture:Vector.<String> = new Vector.<String>();

		public var settingComplete:Boolean;
		public var productName:String;
        public var isAnimate:Boolean;
        public var frameRate:Number;
		public var _startFrame:Number;
		public var _fullRotate:Boolean;
		public var _autoPlay:Boolean;
		public var playDirection:String;

		public function Images3DObject()
		{
            _juggler = new Juggler();

			//super();
			//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:starling.events.Event):void
		{
			//this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
        public function init():void
        {
            picNum = 0;
        }
		public function createGallery(assets:AssetManager, product:String, fullRotate:Boolean=true,
									  startFrame:Number=0, fps:Number=12, autoPlay:Boolean=false):void {
			sAssets = assets;
			productName = product;
			_startFrame = startFrame;
			_fullRotate = fullRotate;
			_autoPlay = autoPlay;
            _loading = new LodingObject();
            _loading.createAnimation(sAssets);
            this.addChild(_loading);

			if(Khun_T12.ipadProDisplay == "pro"){
				_loading.scale = 1.6;
			}
			else{
				_loading.scale = 0.6*(Khun_T12.scaleFactor*Khun_T12.scaleScreen);
			}
			settingComplete = false;
			currentTexture.length = 0;
			filesList = new Array();
			galleryPosX = 0;

			loadImages();

			picNum = _startFrame;
            isAnimate = false;
			playDirection = "next";
			frameRate = 1/fps;
		}
		public function loadImages():void{
			var picPath:String = "images/"+productName;
			var picFile:File = File.applicationDirectory.resolvePath(picPath);
			filesList = picFile.getDirectoryListing();
			totalImages = filesList.length;
			trace("totalImages = "+totalImages);
			/*for(i=0, l=filesList.length;i<l;++i){
			trace(filesList[i].nativePath);
			trace(filesList[i].name);
			}*/

			sAssets.enqueue(picFile);
			sAssets.loadQueue(function(ratio:Number):void
			{
//				trace("Loading assets, progress:", ratio);
				if (ratio == 1.0)
					setTimeout(setPic, 200);
//					trace("load complete");
			});

		}

		private function getFileName($url:String):String {
			var extRemoved:String = $url.slice($url.lastIndexOf("/") + 1, $url.lastIndexOf("."));
			return extRemoved;
		}
		private function setPic():void{

			var TextureName:String;
			for(i=0, l=totalImages;i<l;++i){
				TextureName = getFileName(filesList[i].name);
				currentTexture.push(TextureName);

				pic = new Image(sAssets.getTexture(TextureName));
				if(Khun_T12.ipadProDisplay == "pro"){
					pic.scale = 1.6;
				}
				else{
					pic.scale = 0.6*(Khun_T12.scaleFactor*Khun_T12.scaleScreen);
				}
				pic.visible = false;
				addChild(pic);
				picObject.push(pic);
			}

            this.x = (Khun_T12.screenWidth - picObject[0].width)/2;
            this.y = (Khun_T12.screenHeight - picObject[0].height)/2;

			picObject[_startFrame].visible = true;

			if(_autoPlay == true){
				playLoop();
			}
            _loading.removeAnimation();

			if(!stage) return;

			stage.addEventListener(TouchEvent.TOUCH, onTouch);

//			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

            settingComplete = true;
		}
		public function hidePics():void
		{
			for(i=0, l=picObject.length;i<l;++i){
				picObject[i].visible = false;
			}
		}
		public function nextPic():void
		{
			picNum++;
			if(picNum >= picObject.length){
				if(_fullRotate == true){
					picNum = 0;
				}
				else {
					picNum = picObject.length-1;
					delayLoop();
					playDirection = "back";
					Starling.juggler.delayCall(playLoop, 1);
				}
			}
			hidePics();
			picObject[picNum].visible = true;
		}
		public function prevPic():void
		{
			picNum--;
			if(picNum <= 0){
				picNum = 0;
				delayLoop();
				playDirection = "next";
				Starling.juggler.delayCall(playLoop, 1);
			}
			hidePics();
			picObject[picNum].visible = true;
		}
        public function animatePics():void {
			trace("running");
			if(playDirection == "next"){
				nextPic();
			}
			else if(playDirection == "back"){
				prevPic();
			}

			if(isAnimate == true){
				Starling.juggler.delayCall(animatePics, frameRate);
			}
			else{
				Starling.juggler.removeDelayedCalls(animatePics);
			}
        }
        public function playLoop():void {
            trace("loop");
            if(isAnimate == false){
                isAnimate = true;
				animatePics();
            }
        }
        public function stopLoop():void {
			trace("stop");
            Starling.juggler.removeDelayedCalls(animatePics);
			Starling.juggler.removeDelayedCalls(playLoop);
            isAnimate = false;
			this.dispatchEvent(new Image3DEvent(Image3DEvent.SET_STOP, {id: null}, true));
        }
		public function delayLoop():void {
			trace("delay");
			Starling.juggler.removeDelayedCalls(animatePics);
			Starling.juggler.removeDelayedCalls(playLoop);
			isAnimate = false;
		}



		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage);
			var distance:int;
			if (touch && touch.phase != TouchPhase.HOVER)
			{
				touchPosition = touch.getLocation(this);

				if(touch.phase == TouchPhase.BEGAN){ //on finger down
					trace("on finger down");
					stopLoop();
                    touchPosition = touch.getLocation(this);
                    startX = touchPosition.x;
                    startFrame = picNum;
				}
				if(touch.phase == TouchPhase.MOVED){ //on finger move
//					trace("on finger move");
                    touchPosition = touch.getLocation(this);
                    changeDistance = Math.round((touchPosition.x - startX) / 35);
                    travelDistance = startFrame - changeDistance;
//                    trace(changeDistance, travelDistance);

                    if (travelDistance >= picObject.length) {
						if(_fullRotate == true){
							picNum = travelDistance % (picObject.length-1);
						}
						else{
							picNum = picObject.length-1;
						}
                    } else if (travelDistance < 0) {
						if(_fullRotate == true){
							picNum = (picObject.length-1) + (travelDistance % (picObject.length-1));
						}
						else{
							picNum = 0;
						}
                    } else {
                        picNum = travelDistance;
                    }
//                    trace(picNum);
                    hidePics();
                    picObject[picNum].visible = true;
				}
				if(touch.phase == TouchPhase.ENDED){ //on finger up
                    trace("on finger up");
					if(_autoPlay == true){
						playLoop();
					}
				}
			}
		}


		public function setButtonEvent():void
		{
			//
		}
		public function unsetButtonEvent():void
		{
			//
		}

		public function disposeObject():void
		{
			stopLoop();
//			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			while(currentTexture.length > 0){
				sAssets.removeTexture(currentTexture[0], true);
				currentTexture.splice(0, 1);
			}
			this.removeChildren();
            removeFromParent(true);
		}
		/*private function onEnterFrame(event:EnterFrameEvent):void {
			advanceTime(event.passedTime);
		}*/
		public function advanceTime(time:Number):void {
			_juggler.advanceTime(time);
		}

	}
}