
package app_screens {
	import app_events.NavigationEvent;
	import app_events.SoundsEvent;

	import feathers.controls.LayoutGroup;

	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;


	public class OptionScreen extends Sprite{

	    public var layout:Sprite;
        public var _bg:LayoutGroup;
        public var _back_icon:Button;
		public var _back_button:LayoutGroup;
		public var _buttonGroup:LayoutGroup;
		public var _button_close:LayoutGroup;
		public var _button_instruction:LayoutGroup;

		public var prevScreen:Object;

		public var button_list:Array;
		public var button_down_list:Array;
		public var target_page:Array;
		public var i:Number;
		public var l:Number;
		public var selected_button_id:Number;

        public var screenName:String;
        public var screenStatus:String;
        private var intervalID:uint;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;

		public var uiBuilder:IUIBuilder;

		public var upPosition:Number;
		public var downPosition:Number;


        public function OptionScreen() {

        }
        public function initialize(assets:AssetManager):void {
	        screenName = "Option Screen";
	        trace("Welcome to "+screenName);
//	        var sAssets:AssetManager = assets;
	        button_list = [];
	        button_down_list = [];
	        prevScreen = {};

	        target_page = [{screen:0, page:0}, {screen:1, page:0}, {screen:1, page:3}, {screen:2, page:0},
		        {screen:3, page:0}, {screen:3, page:1}, {screen:3, page:3}, {screen:3, page:5}, {screen:4, page:0},
		        {screen:4, page:2}];
//            this.visible = false;

	        drawScreen();
        }
		private function drawScreen():void
        {
            trace("Drawing "+screenName+" .......");
            addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

	        if(Khun_T12.ipadProDisplay == "pro"){
		        layout = Root.uiBuilder.create(ParsedLayouts.option_screen_layout_pro, false, this) as Sprite;
	        }
	        else{
		        layout = Root.uiBuilder.create(ParsedLayouts.option_screen_layout, false, this) as Sprite;
	        }
	        addChild(layout);

	        layout.scale = Khun_T12.scaleScreen;
	        layout.width = Starling.current.stage.stageWidth;
            layout.height = Starling.current.stage.stageHeight;

	        for(i=1,l=10;i<=l;++i){
		        button_list.push(_buttonGroup.getChildByName("button_"+i) as LayoutGroup);
		        button_down_list.push(button_list[i-1].getChildByName("bg_down") as LayoutGroup);
	        }

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
	        for(i=0,l=button_list.length;i<l;++i){
		        button_list[i].alpha = 0;
	        }
	        playAnimationIn();
//	        TweenLite.delayedCall(0.5, playAnimationIn);
        }

        public function addPrevScreen(_data:Object):void{
	        prevScreen = {};
	        prevScreen = _data;
        }
		public function playAnimationIn():void{
			var TempY1:Number = _button_instruction.y;
			var TempY2:Number = _button_close.y;
			_button_instruction.y = TempY1+50;
			_button_close.y = TempY2+50;
			_button_instruction.alpha = 0;
			_button_close.alpha = 0;

			for(i=0,l=button_list.length;i<l;++i){
				TweenLite.to(button_list[i], 0.6, {alpha:1, ease:Cubic.easeOut, delay:(i*0.03)+0.2});
			}
			TweenLite.to(_button_instruction, 0.5, {alpha:1, y:TempY1, ease:Cubic.easeOut, delay:0.2});
			TweenLite.to(_button_close, 0.5, {alpha:1, y:TempY2, ease:Cubic.easeOut, delay:0.3});

			addTouchEvents();
		}
        public function playAnimationOut():void{

        }
        private function removeAnimations():void{
	        for(i=0,l=button_list.length;i<l;++i){
		        TweenLite.killTweensOf(button_list[i]);
	        }
	        TweenLite.killTweensOf(_button_instruction);
	        TweenLite.killTweensOf(_button_close);
	        TweenLite.killDelayedCallsTo(playAnimationIn);
        }
		private function addTouchEvents():void {
			for(i=0,l=button_list.length;i<l;++i){
				button_list[i].addEventListener(TouchEvent.TOUCH, onTouch);
			}
			_back_icon.addEventListener(Event.TRIGGERED, onTriggered);
			this.addEventListener(TouchEvent.TOUCH, onAreaTouch);

			_button_close.addEventListener(TouchEvent.TOUCH, onTouch);
			_button_instruction.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function removeTouchEvents():void {
			for(i=0,l=button_list.length;i<l;++i){
				button_list[i].removeEventListener(TouchEvent.TOUCH, onTouch);
			}
			_back_icon.removeEventListener(Event.TRIGGERED, onTriggered);
			this.removeEventListener(TouchEvent.TOUCH, onAreaTouch);
			_button_close.removeEventListener(TouchEvent.TOUCH, onTouch);
			_button_instruction.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function onTriggered(event:Event=null):void {
			trace(prevScreen._screenNum, prevScreen._pageNum);
			removeTouchEvents();
			gotoScreen(prevScreen._screenNum, "Section"+ (prevScreen._screenNum+1), prevScreen._pageNum);
		}
		public function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
			if (touch && touch.phase != TouchPhase.HOVER) {
				var touchedButton:Object = event.currentTarget;
				selected_button_id = button_list.indexOf(touchedButton);
				if (touch.phase == TouchPhase.BEGAN) { //on finger down
					if(selected_button_id != -1) {
						button_down_list[selected_button_id].alpha = 1;
					}
					else{
						touchedButton.getChildByName("bg_down").alpha = 1;
					}
				}
				if (touch.phase == TouchPhase.ENDED) { //on finger up
					if(selected_button_id != -1) {
						button_down_list[selected_button_id].alpha = 0;
					}
					else{
						touchedButton.getChildByName("bg_down").alpha = 0;
					}
					var current_touchPosition:Point = touch.getLocation(this);
					if (stage.hitTest(current_touchPosition) == touch.target) {
						intervalID = setTimeout(function ():void {

							if(touchedButton == _button_close){
								removeTouchEvents();
								gotoScreen(prevScreen._screenNum, "Section"+ (prevScreen._screenNum+1), prevScreen._pageNum);
							}
							else if(touchedButton == _button_instruction){
								Root.displayInstruction();
							}
							else{
								removeTouchEvents();
								trace(selected_button_id, target_page[selected_button_id].screen,
										target_page[selected_button_id].page);
								gotoScreen(
										target_page[selected_button_id].screen,
										"Section"+(target_page[selected_button_id].screen+1),
										target_page[selected_button_id].page
								);
							}
						}, 100);
					}
				}
			}
		}

		public function onAreaTouch(event:TouchEvent):void {
			var current_touchPosition:Point;
			var sTouch:Touch = event.getTouch(stage);
			if (sTouch && sTouch.phase != TouchPhase.HOVER) {
				current_touchPosition = sTouch.getLocation(this);
				if(sTouch.phase == TouchPhase.BEGAN){
					downPosition = current_touchPosition.x;
					trace("down", current_touchPosition.x);
				}
				if(sTouch.phase == TouchPhase.ENDED){
					upPosition = current_touchPosition.x;
					trace("up", current_touchPosition.x);
					if(Math.abs(upPosition - downPosition) > 35 ) {
						if(upPosition < downPosition){
							onTriggered();
						}
					}
				}
			}
		}
        public function playSound(sName:String, sVolume:Number=0.8, sLoop:Boolean=false):void{
            this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {soundName:sName, volume:sVolume, loops:sLoop}, true));
        }
		public function gotoScreen(targetID:Number, targetName:String, pageID:Number=0):void{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.JUMP_SCREEN, {
				_id:targetID, _name:targetName, _idPge:pageID}, true));
		}
        public function disposeTemporarily():void {
            if(disposeStatus == false){
//                this.visible = false;
                disposeStatus = true;
                clearTimeout(intervalID);
                removeAnimations();
	            removeTouchEvents();
	            this.x = -Khun_T12.screenWidth;
                trace("Dispose "+screenName);
            }
        }
    }
}
