
package app_screens {
	import app_events.NavigationEvent;
	import app_events.SoundsEvent;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	import feathers.controls.LayoutGroup;

	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;

	public class HUDControlScreen extends Sprite{

	    public var layout:Sprite;
        public var _last_page_label:LayoutGroup;
		public var _option_button:LayoutGroup;
		public var _resuming_text:LayoutGroup;
		public var _option_icon:Button;
		private var pageNum:TextField;
		private var totalPageNum:TextField;

		public var tempLabelY1:Number;
		public var tempLabelY2:Number;
		public var textSize:Number;

        public var screenName:String;
        public var screenStatus:String;
        private var intervalID:uint;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;

		public var uiBuilder:IUIBuilder;

		private var intervalID_Label:uint;
		private var intervalID_text:uint;

        public function HUDControlScreen() {

        }
        public function initialize(assets:AssetManager):void {
	        screenName = "Screen 1";
	        trace("Welcome to "+screenName);
	        var sAssets:AssetManager = assets;
	        this.visible = false;
	        drawScreen();
        }
		private function drawScreen():void {
			trace("Drawing "+screenName+" .......");
			addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

			textSize = 20;

			if(Khun_T12.ipadProDisplay == "pro"){
				layout = Root.uiBuilder.create(ParsedLayouts.hud_control_layout_pro, false, this) as Sprite;
				textSize = 30;
			}
			else{
				layout = Root.uiBuilder.create(ParsedLayouts.hud_control_layout, false, this) as Sprite;
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
//			textFormat.size = Khun_T12.scaleScreen< 1 ? 20*Khun_T12.scaleScreen: 18;
//	        textFormat.bold = true;
//	        textFormat.italic = true;
			textFormat.kerning = true;
			textFormat.letterSpacing = 0;
			textFormat.verticalAlign = "bottom";
			textFormat.color = 0x000000;

			pageNum = new TextField(600, 40);
			pageNum.format = textFormat;
			pageNum.format.horizontalAlign = "left";
			pageNum.alpha = 0.5;
			pageNum.x = Khun_T12.scaleScreen< 1 ? 10*Khun_T12.scaleScreen: 15;
			pageNum.y = Khun_T12.screenHeight - (pageNum.height+5);
//			pageNum.y = 5;
			addChild(pageNum);

			totalPageNum = new TextField(200, 40);
			totalPageNum.format = textFormat;
			totalPageNum.format.horizontalAlign = "right";
			totalPageNum.alpha = 0.5;
			totalPageNum.x = Khun_T12.screenWidth - totalPageNum.width - (10*Khun_T12.scaleScreen);
			totalPageNum.y = Khun_T12.screenHeight - (totalPageNum.height + 5);
//			totalPageNum.y = 5;
			addChild(totalPageNum);

		}
		public function chkDrawScreenComplete(e:Event):void{
			if(layout && pageNum && totalPageNum){
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
	        pageNum.visible = false;
	        _last_page_label.visible = false;
	        _resuming_text.visible = false;
            initScreen();
            this.visible = true;
        }
		public function setPageNumber(screenName:String, currentP:Number, TotalP:Number, totalPage:Number):void{
			TweenLite.killDelayedCallsTo(hideText);
			pageNum.text = screenName + " : " + String(currentP+1) + " of " + String(TotalP);
			totalPageNum.text = String(totalPage+1) + " of 23";
			displayText();
			if(totalPage+1 >= 23){
				TweenLite.killDelayedCallsTo(hideLastPageLabel);
				displayLastPageLabel();
			}
			else{
				TweenLite.killDelayedCallsTo(hideLastPageLabel);
				hideLastPageLabel();
			}
		}
		public function displayText():void{
			pageNum.visible = true;
			totalPageNum.visible = true;
			TweenLite.delayedCall(3, hideText);
		}
		public function hideText():void{
			pageNum.visible = false;
			totalPageNum.visible = false;
		}
		public function displayLastPageLabel():void{
			tempLabelY1 = _last_page_label.y;
			tempLabelY2 = tempLabelY1 + _last_page_label.height + 20;
			_last_page_label.y = tempLabelY2;
			_last_page_label.visible = true;
			TweenLite.to(_last_page_label, 0.2, {y:tempLabelY1, ease:Quint.easeOut});
			TweenLite.delayedCall(2, hideLastPageLabel);
		}
		public function hideLastPageLabel():void{
			_last_page_label.visible = false;
		}
        public function initScreen():void{
            screenStatus = "init";
	        _option_icon.addEventListener(Event.TRIGGERED, displayOption);
        }
		private function displayOption(event:Event):void{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.OPTION_SCREEN, null, true));
		}
        public function playAnimationIn():void{

        }
        public function playAnimationOut():void{

        }
        private function removeAnimations():void{
	        TweenLite.killDelayedCallsTo(hideLastPageLabel);
	        TweenLite.killDelayedCallsTo(hideText);
        }
        public function playSound(sName:String, sVolume:Number=0.8, sLoop:Boolean=false):void{
            this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {soundName:sName, volume:sVolume, loops:sLoop}, true));
        }

        public function disposeTemporarily():void {
            if(disposeStatus == false){
                this.visible = false;
                disposeStatus = true;
                removeAnimations();
                trace("Dispose "+screenName);
            }
        }
    }
}
