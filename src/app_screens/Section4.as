package app_screens {
    import app_events.ScreenEvent;

    import com.greensock.easing.Quad;

    import flash.geom.Point;
    import flash.utils.clearTimeout;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;

    import starling.core.Starling;
	import starling.display.BlendMode;


	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
    import starling.display.Sprite3D;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.utils.AssetManager;
    import starling.animation.Juggler;
    import starling.animation.Transitions;

    import app_events.SoundsEvent;
    import app_events.NavigationEvent;

    import com.greensock.TweenMax;
    import com.greensock.easing.*;


    public class Section4 extends Sprite {


        public var screenContainer:Sprite3D;

        public var screen13:Screen13;
        public var screen14:Screen14;
        public var screen15:Screen15;
        public var screen16:Screen16;
        public var screen17:Screen17;
        public var screen18:Screen18;
        public var screen19:Screen19;
        public var screen20:Screen20;

        private var touch:Touch;
        private var current_touchPosition:Point;

        private var screenName:String;
        private var screenStatus:String;

        public var totalScreen:Number;
        public var currentScreen:Number;
        public var prevScreen:Number;

        private var sAssets:AssetManager;

        private var prvTouched:Number = 0;
        private var currentTouched:Number = 0;
        private var distance:Number;
        private var startTouchTime:Number = 0;
        private var endTouchTime:Number = 0;
        private var elapsedTime:Number = 0;
        private var picDownPosition:Point;
        private var picUpPosition:Point;
        private var currentTouchPosition:Point;

        private var screenArray:Array;
        private var intervalID:uint;
        private var i:Number;
        private var l:Number;
        private var disposeStatus:Boolean = false;
        public var drawScreenComplete:Boolean = false;

        private var _stageWidth:Number;
        private var _stageHeight:Number;
	    public var _product_img1_position:Point;
	    public var _product_img2_position:Point;
        

        public function Section4() {
            //
        }
        public function initialize(assets:AssetManager):void
        {
            _stageWidth = Khun_T12.screenWidth;
            _stageHeight = Khun_T12.screenHeight;

            screenName = "Section 4";
            trace("Welcome to "+screenName);

            totalScreen = 0;

            sAssets = assets;
            screenArray = [];
            this.visible = false;
            drawScreen();

        }

        private function drawScreen():void
        {
            trace("Drawing "+screenName+" Screen.......");
            addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

            screenContainer = new Sprite3D();
            this.addChild(screenContainer);

            screen13 = new Screen13();
            screen13.initialize(sAssets);
	        screenContainer.addChild(screen13);
	        screenArray.push(screen13);

            screen14 = new Screen14();
            screen14.initialize(sAssets);
            screenContainer.addChild(screen14);
            screenArray.push(screen14);

            screen15 = new Screen15();
            screen15.initialize(sAssets);
            screenContainer.addChild(screen15);
            screenArray.push(screen15);

            screen16 = new Screen16();
            screen16.initialize(sAssets);
            screenContainer.addChild(screen16);
            screenArray.push(screen16);

            screen17 = new Screen17();
            screen17.initialize(sAssets);
            screenContainer.addChild(screen17);
            screenArray.push(screen17);

            screen18 = new Screen18();
            screen18.initialize(sAssets);
            screenContainer.addChild(screen18);
            screenArray.push(screen18);

            screen19 = new Screen19();
            screen19.initialize(sAssets);
            screenContainer.addChild(screen19);
            screenArray.push(screen19);

            screen20 = new Screen20();
            screen20.initialize(sAssets);
            screenContainer.addChild(screen20);
            screenArray.push(screen20);


            for(i=0, l=screenArray.length; i<l; ++i){
                screenArray[i].x = _stageWidth*i;
                screenArray[i].y = 0;
            }

	        totalScreen = screenArray.length;


        }

        public function chkDrawScreenComplete(e:Event):void{
            var sCount:int = 0;
            if(screenArray.length <= 0){
                return;
            }
            for(i=0, l=screenArray.length; i<l; ++i){
		        if(screenArray[i].drawScreenComplete == true){
			        sCount++;
                    if(sCount >= screenArray.length){
	                    trace("Draw "+screenName+" Screen Complete");
	                    removeEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);
	                    drawScreenComplete = true;
                        return;
                    }
		        }
	        }
        }

        public function startScreen():void{
            setTouchEvent();
            screenStatus = "start";
            disposeStatus = false;
//            removeTouchEvent();
            removeAnimations();
            initScreen();
            this.visible = true;

        }
        public function initScreen():void{

            screenContainer.x = 0;
            screenContainer.y = 0;
            prevScreen = -1;
            currentScreen = 0;

            for(i=0, l=screenArray.length; i<l; ++i){
                screenArray[i].startScreen();
            }
	        setPageInvisible();
//            screenArray[1].visible = false;
        }
	    public function setPage(_page:Number):void{
		    trace("set page", _page);
		    setTouchEvent();
		    screenStatus = "start";
		    disposeStatus = false;
		    prevScreen = _page-1;
		    currentScreen = _page;
		    screenContainer.x = -(_stageWidth*currentScreen);
		    screenContainer.y = 0;

		    for(i=0, l=screenArray.length; i<l; ++i){
			    screenArray[i].startScreen();
		    }
		    if(currentScreen == 2 || currentScreen == 4 || currentScreen == 7){
			    _product_img1_position = product1_position();
			    _product_img2_position = product2_position();
			    trace(product1_position());
			    trace(product2_position());
		    }
		    setPageInvisible();
		    this.visible = true;
	    }
        public function setLastPage():void{
            setTouchEvent();
            screenStatus = "start";
            disposeStatus = false;
            prevScreen = totalScreen;
            currentScreen = totalScreen-1;
            screenContainer.x = -(_stageWidth*currentScreen);
            screenContainer.y = 0;

            for(i=0, l=screenArray.length; i<l; ++i){
                screenArray[i].startScreen();
            }
	        setPageInvisible();
            this.visible = true;
        }

        public function playScreen():void{
	        screenArray[currentScreen].initScreen();
        }
        public function playAnimationIn():void{

        }
	    public function removeAnimations():void{
		    TweenMax.killTweensOf(screenContainer);
        }
        private function nextContent():void {
            prevScreen = currentScreen;
            currentScreen++;
            if(currentScreen == totalScreen){
                if(Root.currentScreenID < Root.totalContentSection-1){
                    var nextSectionID:Number = Root.currentScreenID+1;
                    gotoScreen(nextSectionID, String("section"+(nextSectionID+1)));
                }
                else{
                    currentScreen--;
                    TweenMax.to(screenContainer, 0.4, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                        onComplete:gotoPageComplete});
                }
            }
            else{
                TweenMax.to(screenContainer, 0.4, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                    onComplete:gotoPageComplete});
            }
        }
        private function prevContent():void {
            prevScreen = currentScreen;
            currentScreen--;
            if(currentScreen < 0){
                if(Root.currentScreenID > 0){
                    var nextSectionID:Number = Root.currentScreenID-1;
                    gotoScreen(nextSectionID, String("section"+(nextSectionID+1)));
                }
                else{
                    currentScreen = 0;
                    TweenMax.to(screenContainer, 0.4, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                        onComplete:gotoPageComplete});
                }
            }
            else{
                TweenMax.to(screenContainer, 0.4, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                    onComplete:gotoPageComplete});
            }
        }

        public function gotoPage(pNum:Number):void {
            prevScreen = currentScreen;
            currentScreen = pNum;
            TweenMax.to(screenContainer, 0.4, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                onComplete:gotoPageComplete});
        }

        private function gotoPageComplete():void {
	        if(screenContainer.x != -(_stageWidth*currentScreen)){
		        TweenMax.to(screenContainer, 0.1, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut});
	        }
	        setPageInvisible();
            setTouchEvent();
	        screenArray[currentScreen].initScreen();
	        if(currentScreen == 2 || currentScreen == 4 || currentScreen == 7){
		        _product_img1_position = product1_position();
		        _product_img2_position = product2_position();
		        trace(product1_position());
		        trace(product2_position());
	        }
	        Root.touchStatus = "";
	        this.dispatchEvent(new ScreenEvent(ScreenEvent.PAGE_MOVE_COMPLETE, null, true));
        }

	    public function setTouchEvent():void{
            this.addEventListener(TouchEvent.TOUCH, onScreenTouch);
        }
	    public function removeTouchEvent():void{
		    this.removeEventListener(TouchEvent.TOUCH, onScreenTouch);
        }

        private function onScreenTouch(event:TouchEvent):void {
            var sTouch:Touch = event.getTouch(stage);
            if (sTouch && sTouch.phase != TouchPhase.HOVER) {
                currentTouchPosition = sTouch.getLocation(this);

                if(sTouch.phase == TouchPhase.BEGAN){ //on finger down
	                setPageVisible();
                    TweenMax.killTweensOf(screenContainer);
                    startTouchTime = getTimer();
                    picDownPosition = currentTouchPosition;
                    prvTouched = currentTouchPosition.x;
                    currentTouched = currentTouchPosition.x;
                }
                if(sTouch.phase == TouchPhase.MOVED){ //on finger moved
                    prvTouched = currentTouched;
                    currentTouched = currentTouchPosition.x;
                    distance = currentTouched - prvTouched;
                    screenContainer.x += (int(distance));
                }
                if(sTouch.phase == TouchPhase.ENDED){ //on finger up
                    endTouchTime = getTimer();
                    elapsedTime = endTouchTime - startTouchTime;
                    picUpPosition = currentTouchPosition;

                    if(picDownPosition == null) return;

                    if(elapsedTime < 400){
                        if(Math.abs(picUpPosition.x - picDownPosition.x) > 30) {
                            trace("swipe");
	                        Root.touchStatus = "swipe";
                            picUpPosition.x > picDownPosition.x ? prevContent() : nextContent();
                        }
                        else{
                            trace("touch");
	                        Root.touchStatus = "touch";
                            TweenMax.to(screenContainer, 0.2, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                                onComplete:gotoPageComplete});
                        }
                    }
                    else{
                        if(Math.abs(picUpPosition.x - picDownPosition.x) >= stage.stageWidth/2.5){
                            trace("long drag");
	                        Root.touchStatus = "long drag";
                            picUpPosition.x > picDownPosition.x ? prevContent() : nextContent();
                        }
                        else{
                            trace("short drag");
	                        Root.touchStatus = "short drag";
                            TweenMax.to(screenContainer, 0.2, {x:-(_stageWidth*currentScreen), ease:Cubic.easeOut,
                                onComplete:gotoPageComplete});
                        }
                    }
                }
            }
        }
	    public function setPageVisible():void {
		    screenArray[currentScreen].visible = true;
		    if(currentScreen+1 < screenArray.length) screenArray[currentScreen+1].visible = true;
		    if(currentScreen-1 >= 0) screenArray[currentScreen-1].visible = true;
	    }
	    public function setPageInvisible():void {
		    for(i=0, l=screenArray.length; i<l; ++i){
			    (i == currentScreen) ? screenArray[i].visible = true : screenArray[i].visible = false;
		    }
	    }
	    public function setBlurFX():void {
		    var _blurFX:BlurFilter = new BlurFilter(1,1,1);
		    _blurFX.padding.setTo();
		    screenArray[currentScreen].filter = _blurFX;
	    }
	    public function removeBlurFX():void {
		    if(screenArray[currentScreen].filter != null){
			    screenArray[currentScreen].filter.dispose();
			    screenArray[currentScreen].filter = null;
		    }
	    }
        public function playSound(sName:String, sVolume:Number=0.8, sLoop:Boolean=false):void{
            this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {soundName:sName, volume:sVolume, loops:sLoop}, true));
        }
	    public function gotoScreen(targetID:Number, targetName:String):void{
		    this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {_id:targetID, _name:targetName}, true));
	    }
	    public function product1_position():Point{
            var p_point:Point = screenArray[currentScreen]._product_img1_position;
		    return p_point;
	    }
	    public function product2_position():Point{
		    var p_point:Point = screenArray[currentScreen]._product_img2_position;
		    return p_point;
	    }
        public function disposeTemporarily():void
        {
            if(disposeStatus == false){
                for(i=0, l=screenArray.length; i<l; ++i){
                    screenArray[i].disposeTemporarily();
                }
                this.visible = false;
                disposeStatus = true;
                clearTimeout(intervalID);
                removeTouchEvent();
	            removeAnimations();
                trace("Dispose "+screenName+" Screen.....");
            }
        }
    }
}
