
package app_screens {
	import app_events.SoundsEvent;

	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;


	public class InstructionScreen extends Sprite{

	    public var layout:Sprite;
		private var textLeft:TextField;
		private var textRight:TextField;

        public var screenName:String;
        public var screenStatus:String;
//        private var sAssets:AssetManager;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;
		public var uiBuilder:IUIBuilder;
		public var textSize:Number;


        public function InstructionScreen() {

        }
        public function initialize(assets:AssetManager):void
        {
            screenName = "Instruction screen";
            trace("Welcome to "+screenName);
            this.visible = false;

            drawScreen();
        }
        private function drawScreen():void {
	        trace("Drawing "+screenName+" .......");
	        addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

	        textSize = 20;

	        if(Khun_T12.ipadProDisplay == "pro"){
		        layout = Root.uiBuilder.create(ParsedLayouts.instruction_page_layout_pro, false, this) as Sprite;
		        textSize = 30;
	        }
	        else{
		        layout = Root.uiBuilder.create(ParsedLayouts.instruction_page_layout, false, this) as Sprite;
		        if(Khun_T12.screenWidth < Khun_T12.appWidth){
			        textSize = 16;
		        }
	        }
	        addChild(layout);

	        layout.scale = Khun_T12.scaleScreen;
	        layout.width = Starling.current.stage.stageWidth;
	        layout.height = Starling.current.stage.stageHeight;

	        var textFormat:TextFormat = new TextFormat();
	        textFormat.font = "SF UI Text Regular";
	        textFormat.size = textSize;
//	        textFormat.size = Khun_T12.scaleScreen< 1 ? 20*Khun_T12.scaleScreen: 18;
//	        textFormat.bold = true;
//	        textFormat.italic = true;
	        textFormat.kerning = true;
	        textFormat.letterSpacing = 0;
	        textFormat.verticalAlign = "bottom";
	        textFormat.color = 0xffffff;

	        textLeft = new TextField(600, 30);
	        textLeft.format = textFormat;
	        textLeft.format.horizontalAlign = "left";
	        textLeft.x = Khun_T12.scaleScreen< 1 ? 10*Khun_T12.scaleScreen: 15;
	        textLeft.y = Khun_T12.screenHeight - (textLeft.height+5);
//	        textLeft.y = 5;
	        addChild(textLeft);

	        textRight = new TextField(200, 30);
	        textRight.format = textFormat;
	        textRight.format.horizontalAlign = "right";
	        textRight.x = Khun_T12.screenWidth - textRight.width - (10*Khun_T12.scaleScreen);
	        textRight.y = Khun_T12.screenHeight - (textRight.height + 5);
//	        textRight.y = 5;
	        addChild(textRight);

        }
		public function chkDrawScreenComplete(e:Event):void{
            if(layout && textLeft && textRight){
                trace("Draw "+screenName+" Complete");
                removeEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);
                drawScreenComplete = true;
            }
        }
        public function startScreen():void{
            trace(screenName+" Start Now!");
            screenStatus = "start";
            disposeStatus = false;
            initScreen();
            this.visible = true;
        }
        public function initScreen():void{
            screenStatus = "init";
	        textLeft.text = "SANITARY - 3/8";
	        textRight.text = "15/23";

	        this.addEventListener(TouchEvent.TOUCH, removeInstruction);
        }
		public function removeInstruction(e:TouchEvent):void{
			var sTouch:Touch = e.getTouch(stage);
			if (sTouch && sTouch.phase) {
				if(sTouch.phase == TouchPhase.ENDED) { //on finger up
					this.visible = false;
				}
			}
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
        public function disposeTemporarily():void {
            if(disposeStatus == false){
                this.visible = false;
                disposeStatus = true;
	            this.removeEventListener(TouchEvent.TOUCH, removeInstruction);
                removeAnimations();
                trace("Dispose "+screenName);
            }
        }
    }
}
