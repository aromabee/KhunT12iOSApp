
package app_screens {
	import app_events.NavigationEvent;
	import app_events.SoundsEvent;

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



	public class Screen11 extends Sprite{

	    public var layout:Sprite;
        public var _bg:Image;
        public var _info:LayoutGroup;

        public var screenName:String;
        public var screenStatus:String;
        private var sAssets:AssetManager;
        private var intervalID:uint;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;

        private var juggler:Juggler;
		public var uiBuilder:IUIBuilder;


        public function Screen11() {
	        super();
        }
        public function initialize(assets:AssetManager):void
        {
            screenName = "Screen 11";
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
		        layout = Root.uiBuilder.create(ParsedLayouts.screen11_layout_pro, false, this) as Sprite;
	        }
	        else{
		        layout = Root.uiBuilder.create(ParsedLayouts.screen11_layout, false, this) as Sprite;
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
            initScreen();
            this.visible = true;

        }
        public function initScreen():void{
            screenStatus = "init";
//            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
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
                removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
                trace("Dispose "+screenName);
            }
        }
    }
}
