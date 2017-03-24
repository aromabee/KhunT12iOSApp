
package app_screens {
	import app_events.Image3DEvent;
	import app_events.SoundsEvent;

	import com.greensock.TweenMax;

	import feathers.controls.LayoutGroup;

    import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;
	import starlingbuilder.engine.LayoutLoader;



	public class Screen15 extends Sprite{

	    public var layout:Sprite;
        public var _bg:Image;
        public var _product_img1:Image;
        public var _product_img2:Image;
        public var _productsGroup:LayoutGroup;
        public var _logo:LayoutGroup;

        public var _product_img1_position:Point;
        public var _product_img2_position:Point;

        public var screenName:String;
        public var screenStatus:String;
        private var sAssets:AssetManager;
        private var intervalID:uint;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;

        private var juggler:Juggler;
		public var uiBuilder:IUIBuilder;


        public function Screen15() {
	        super();
        }
        public function initialize(assets:AssetManager):void
        {
            screenName = "Screen 15";
            trace("Welcome to "+screenName);
            sAssets = assets;
            juggler = new Juggler();

            this.visible = false;

            drawScreen();
        }
        private function drawScreen():void
        {
            trace("Drawing "+screenName+" .......");
            addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

	        if(Khun_T12.ipadProDisplay == "pro"){
		        layout = Root.uiBuilder.create(ParsedLayouts.screen15_layout_pro, false, this) as Sprite;
	        }
	        else{
		        layout = Root.uiBuilder.create(ParsedLayouts.screen15_layout, false, this) as Sprite;
	        }
	        addChild(layout);

	        _product_img1_position = _product_img1.localToGlobal(new Point(_product_img1.x, _product_img1.y));
	        _product_img2_position = _product_img2.localToGlobal(new Point(_product_img2.x, _product_img2.y));
	        trace("Local to Global Position 1 = " + _product_img1_position.x, _product_img1_position.y);
	        trace("Local to Global Position 2 = " + _product_img2_position.x, _product_img2_position.y);

	        layout.scale = Khun_T12.scaleScreen;
	        layout.width = Starling.current.stage.stageWidth;
	        layout.height = Starling.current.stage.stageHeight;
        }
        public function chkDrawScreenComplete(e:Event):void{
            if(layout){
                trace("Draw "+screenName+" Complete");
                removeEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);
                drawScreenComplete = true;
            }
        }
        public function startScreen():void{
            trace(screenName+" Start Now!");
            screenStatus = "start";
            disposeStatus = false;
            removeAnimations();
//            initScreen();
            this.visible = true;

        }
        public function initScreen():void{
            screenStatus = "init";
	        setTouchEvent();
//            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }
		public function setTouchEvent():void{
			_product_img1.addEventListener(TouchEvent.TOUCH, onTouch);
			_product_img2.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function removeTouchEvent():void{
			_product_img1.removeEventListener(TouchEvent.TOUCH, onTouch);
			_product_img2.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function onTouch(event:TouchEvent):void {
			var current_touchPosition:Point;
			var sTouch:Touch = event.getTouch(event.currentTarget as DisplayObject);
			var product:Object = event.currentTarget;
			if (sTouch && sTouch.phase != TouchPhase.HOVER) {
				current_touchPosition = sTouch.getLocation(this);
				if(sTouch.phase == TouchPhase.BEGAN){
					product.alpha = 0.5;
				}
				if(sTouch.phase == TouchPhase.ENDED){
					product.alpha = 1;
					trace("touch me!");
					setTimeout(function():void {
						if(Root.touchStatus == "touch") {
							if (product == _product_img1) {
								display3D("BasinMixer", true, 31);
							}
							else if (product == _product_img2) {
								display3D("AxStarck", false, 4);
							}
						}
					}, 100);
				}
			}
		}
		public function display3D(_name:String, _round360:Boolean, _start:Number=0):void{
			this.dispatchEvent(new Image3DEvent(Image3DEvent.DISPLAY_3D,
					{_productName:_name, _isFullRotate:_round360, _startFrame:_start}, true));
		}
        public function playAnimationIn():void{


        }
        public function playAnimationOut():void{

        }

        private function removeAnimations():void{

        }

        public function playSound(sName:String, sVolume:Number=0.8, sLoop:Boolean=false):void{
            this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {soundName:sName, volume:sVolume, loops:sLoop}, true));
        }

        private function onEnterFrame(event:EnterFrameEvent):void {
            advanceTime(event.passedTime);
        }
        public function advanceTime(time:Number):void {
	        juggler.advanceTime(time);
        }

        public function disposeTemporarily():void
        {
            if(disposeStatus == false){
                this.visible = false;
                disposeStatus = true;
                clearTimeout(intervalID);
                removeAnimations();
	            removeTouchEvent();
                removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
                trace("Dispose "+screenName);
            }
        }
    }
}
