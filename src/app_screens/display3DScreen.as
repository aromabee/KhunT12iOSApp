
package app_screens {

	import app_events.Image3DEvent;
	import app_objects.Images3DObject;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	import feathers.controls.LayoutGroup;

	import flash.geom.Point;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import starling.display.BlendMode;

	import starling.display.Button;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;


	public class display3DScreen extends Sprite{

	    public var layout:Sprite;
        public var _bg:LayoutGroup;
        public var _logo:LayoutGroup;
        public var screenName:String;
        public var screenStatus:String;
        private var sAssets:AssetManager;
        private var intervalID:uint;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;
		public var uiBuilder:IUIBuilder;
		public var img_3D:Images3DObject;
		public var dimmer:Sprite;
		public var dimmer_area:Canvas;
		private var obj:Object;

		public var rotation_type:Array;
		public var rotation_360:Image;
		public var rotation_180:Image;
		public var button_exit:Button;
		public var hand_img:Image;

		public var _product:String;
		public var _fullRotate:Boolean;
		public var _startFrame:Number;
		public var _fps:Number;
		public var _autoPlay:Boolean;

        public function display3DScreen() {

        }
		public function init(assets:AssetManager):void{
			screenStatus = "init";
			sAssets = assets;
			obj = [];
			rotation_type = [];

			dimmer = new Sprite();
			addChild(dimmer);
			dimmer_area = new Canvas();
			dimmer_area.beginFill(0x000000, 0.8);
			dimmer_area.drawRectangle(0, 0, Khun_T12.screenWidth, Khun_T12.screenHeight);
			dimmer_area.endFill();
			dimmer.addChild(dimmer_area);
			dimmer.alignPivot();
			dimmer.x =  Khun_T12.screenWidth/2;
			dimmer.y =  Khun_T12.screenHeight/2;
			dimmer.visible = false;

			button_exit = new Button(sAssets.getTexture("button_exit"));
			button_exit.alignPivot();
			this.addChild(button_exit);

			rotation_360 = new Image(sAssets.getTexture("rotation_360"));
			rotation_360.alignPivot();
			rotation_360.touchable = false;
			this.addChild(rotation_360);

			rotation_180 = new Image(sAssets.getTexture("rotation_180"));
			rotation_180.alignPivot();
			rotation_180.touchable = false;
			this.addChild(rotation_180);

			if(Khun_T12.ipadProDisplay == "pro"){
				rotation_360.scale = 1.3;
				rotation_180.scale = 1.3;
				button_exit.scale = 1.3;
			}
			else{
				rotation_360.scale = 0.5*(Khun_T12.scaleFactor*Khun_T12.scaleScreen);
				rotation_180.scale = 0.5*(Khun_T12.scaleFactor*Khun_T12.scaleScreen);
				button_exit.scale = 0.5*(Khun_T12.scaleFactor*Khun_T12.scaleScreen);
			}

			rotation_360.visible = false;
			rotation_180.visible = false;
			button_exit.visible = false;

			hand_img = new Image(sAssets.getTexture("hand_rotation_icon"));
			hand_img.alignPivot();
			addChild(hand_img);
			hand_img.visible = false;

//			startLoad3D("ShowerHead", false, 0, 30, true);
		}
		public function startLoad3D(product:String, fullRotate:Boolean=true,
		                            startFrame:Number=0, fps:Number=12, autoPlay:Boolean=false):void{

			_product = product;
			_fullRotate = fullRotate;
			_startFrame = startFrame;
			_fps = fps;
			_autoPlay = autoPlay;

			dimmer.scale = 0;
			dimmer.visible = true;
			rotation_360.alpha = 0;
			rotation_180.alpha = 0;
			button_exit.alpha = 0;

			clearTimeout(intervalID);
			var scaleValue:Number = Khun_T12.ipadProDisplay == "pro"? 1.3 : Khun_T12.scaleScreen;

			button_exit.x = button_exit.width/2 + (18*scaleValue);
			button_exit.y = button_exit.height/2  + (18*scaleValue);

			rotation_360.x = Khun_T12.screenWidth - rotation_360.width/2 - (23*scaleValue);
			rotation_360.y = rotation_360.height/2 + (19*scaleValue);
			rotation_180.x = Khun_T12.screenWidth - rotation_360.width/2 - (23*scaleValue);
			rotation_180.y = rotation_360.height/2 + (19*scaleValue);

			rotation_type = [];
			_fullRotate == true ? rotation_type.push(rotation_360) : rotation_type.push(rotation_180);

			hand_img.visible = false;
			hand_img.scale = Khun_T12.scaleScreen;
			hand_img.x = (stage.stageWidth)/2;
			hand_img.y = stage.stageHeight - (hand_img.width/2) + (140*scaleValue);
//			hand_img.y = hand_img.width/2;

			animateDimmer();
		}
		public function animateDimmer():void {
			TweenLite.to(dimmer, 0.1, {scaleX:1, scaleY:0.4, delay:0.02, ease:Linear});
			TweenLite.to(dimmer, 0.25, {scaleX:1, scaleY:1, delay:0.12, ease:Cubic.easeOut, onComplete:create3DImages});
		}
		public function create3DImages():void {
			obj.fullRotate = _fullRotate;
			obj.autoPlay = _autoPlay;
			if(img_3D && img_3D.settingComplete == true){
				img_3D.disposeObject();
			}
			img_3D = new Images3DObject();
			img_3D.createGallery(sAssets, _product, _fullRotate, _startFrame, _fps, _autoPlay);
			addChild(img_3D);
			img_3D.x = (stage.stageWidth)/2;
			img_3D.y = (stage.stageHeight)/2;
			addEventListener(Event.ENTER_FRAME, chk3D);
		}
		public function chk3D(e:Event):void{
			if(img_3D.settingComplete == true){
				removeEventListener(Event.ENTER_FRAME, chk3D);
				button_exit.addEventListener(Event.TRIGGERED, onTriggered);

				hand_img.alpha = 0;
				rotation_type[0].visible = true;
				button_exit.visible = true;
				hand_img.visible = true;

				TweenLite.to(rotation_type[0], 0.8, {alpha:1, ease:Quint.easeOut});
				TweenLite.to(button_exit, 0.8, {alpha:1, ease:Quint.easeOut});
				TweenLite.to(hand_img, 1, {alpha:1, delay:0.3, ease:Quint.easeOut});

				intervalID = setTimeout(function():void{
					TweenLite.to(hand_img, 0.8, {alpha:0, ease:Quint.easeOut});
					}, 5000);
			}
		}
		public function onTriggered(e:Event):void {
			button_exit.removeEventListener(Event.TRIGGERED, onTriggered);
			remove3D();
		}
		public function remove3D():void{
			if(img_3D){
				img_3D.disposeObject();
			}
			removeAnimation();
			dimmer.visible = false;
			rotation_360.visible = false;
			rotation_180.visible = false;
			button_exit.visible = false;
			hand_img.visible = false;
			this.dispatchEvent(new Image3DEvent(Image3DEvent.REMOVE_3D, null, true));
		}
		private function removeAnimation():void {
			TweenLite.killTweensOf(rotation_360);
			TweenLite.killTweensOf(rotation_180);
			TweenLite.killTweensOf(dimmer);
			TweenLite.killTweensOf(hand_img);
//			TweenLite.killDelayedCallsTo(create3DImages);
		}
		public function advanceTime(time:Number):void {
			if(img_3D) img_3D.advanceTime(time);
//			img_3D.advanceTime(time);
		}
        public function disposeTemporarily():void {
            if(disposeStatus == false){
                disposeStatus = true;
                clearTimeout(intervalID);
	            removeAnimation();
	            removeEventListener(Event.ENTER_FRAME, chk3D);
                trace("Dispose "+screenName);
            }
        }
    }
}
