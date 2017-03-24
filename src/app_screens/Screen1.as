
package app_screens {
	import app_events.SoundsEvent;

	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quint;

	import feathers.controls.LayoutGroup;

	import flash.utils.clearTimeout;

	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;

	public class Screen1 extends Sprite{

	    public var layout:Sprite;
        public var _bg:Image;
        public var _logo:LayoutGroup;
        public var logoY:Number;

        public var screenName:String;
        public var screenStatus:String;
//        private var sAssets:AssetManager;
        private var intervalID:uint;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;
        private var _juggler:Juggler;
		public var uiBuilder:IUIBuilder;


        public function Screen1() {

        }
        public function initialize(assets:AssetManager):void
        {
            screenName = "Screen 1";
            trace("Welcome to "+screenName);
//            sAssets = assets;
	        _juggler = new Juggler();
            this.visible = false;
            drawScreen();
        }
        private function drawScreen():void
        {
            trace("Drawing "+screenName+" .......");
            addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

	        if(Khun_T12.ipadProDisplay == "pro"){
		        layout = Root.uiBuilder.create(ParsedLayouts.screen1_layout_pro, false, this) as Sprite;
	        }
	        else{
		        layout = Root.uiBuilder.create(ParsedLayouts.screen1_layout, false, this) as Sprite;
	        }
	        addChild(layout);

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
	        logoY = _logo.y;
	        _logo.y = logoY + 50;
	        _logo.alpha = 0;
//            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
	        playAnimationIn();
        }

        public function playAnimationIn():void{
	        TweenMax.to(_logo, 1.5, {alpha:1, y:logoY, ease:Quint.easeOut, onComplete:removeAnimations});
//	        _juggler.tween(_logo, 1.8, {alpha:1, y:logoY, transition: Transitions.EASE_OUT, onComplete:removeAnimations})
        }
        public function playAnimationOut():void{

        }
        private function removeAnimations():void{
	        TweenMax.killTweensOf(_logo);
//	        removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }
        public function playSound(sName:String, sVolume:Number=0.8, sLoop:Boolean=false):void{
            this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {soundName:sName, volume:sVolume, loops:sLoop}, true));
        }
//        private function onEnterFrame(event:EnterFrameEvent):void {
//            advanceTime(event.passedTime);
//        }
//        public function advanceTime(time:Number):void {
//	        _juggler.advanceTime(time);
//        }
        public function disposeTemporarily():void {
            if(disposeStatus == false){
                this.visible = false;
                disposeStatus = true;
                clearTimeout(intervalID);
                removeAnimations();
//                removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
                trace("Dispose "+screenName);
            }
        }
    }
}
