package {

	import app_events.Image3DEvent;
	import app_events.NavigationEvent;
	import app_events.ScreenEvent;
	import app_events.SoundsEvent;

	import app_screens.HUDControlScreen;
	import app_screens.InstructionScreen;
	import app_screens.OptionScreen;
	import app_screens.Section1;
	import app_screens.Section2;
	import app_screens.Section3;
	import app_screens.Section4;
	import app_screens.Section5;
	import app_screens.display3DScreen;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.FlowLayout;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.plasticsturgeon.StarlingTimer;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import starlingbuilder.engine.IUIBuilder;
	import starlingbuilder.engine.LayoutLoader;
	import starlingbuilder.engine.UIBuilder;
	import starlingbuilder.engine.tween.DefaultTweenBuilder;
	import starlingbuilder.extensions.filters.ColorFilter;
	import starlingbuilder.extensions.uicomponents.ContainerButton;

	import utils.ShareObjectManager;

	public class Root extends Sprite
    {
        private static var sAssets:AssetManager;

        public var screen_bg:Image;
        public var logo_img:Image;
        private static var main_menu_prevID:Number;
        private static var main_menu_currentID:Number;
        private static var targetScreenName:String;
        private var totalTime:Number;
        private static var sounds_manager:SoundsControl;
        private var juggler:Juggler;
        private var touchPosition:Point;
        private var _RootObject:Vector.<Object> = new Vector.<Object>();
        private var i:Number;
        private var l:Number;
        private var intervalID:uint;
		private var delayPauseBG:uint;
        private var currentAppScreen:String;
        public var xmlLoader:URLLoader = new URLLoader();
        public var timerCount:StarlingTimer;
        public var screensaver_idle_time:StarlingTimer;
        
        private var isPause:Boolean;
        private var isAwake:Boolean;

	    public static var app_status:String;
        
        private var pushScreen:String;
        private var popScreen:String;
        private var pushScreenID:Number;
        private var popScreenID:Number;

        private static var screenCID:Number;
        private static var screenPID:Number;
	    private static var pageID:Number;
        private static var totalSection:Number;

        private var starsDirection:String = "";
        private var starsFxContainer:Sprite;

		public static const linkers:Array = [Sprite3D, ContainerButton, LayoutGroup, AnchorLayout, FlowLayout,
									HorizontalLayout, VerticalLayout, TiledRowsLayout, BlurFilter, ColorFilter];
		public static var uiBuilder:IUIBuilder;
		public static var layout_loader:LayoutLoader;

		public var section1:Section1;
		public var section2:Section2;
		public var section3:Section3;
		public var section4:Section4;
		public var section5:Section5;
	    public var option_screen:OptionScreen;
	    public var hud_control_screen:HUDControlScreen;
	    public var display_3d_screen:display3DScreen;

	    public static var instruction_screen:InstructionScreen;

	    public var screenName:Array;
	    public var screenPageNum:Array;
	    public var infoText:TextField;
	    public var allCurrentPage:Number;
	    public static var touchState:String;


        public function Root() {
            //super();
            //this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        //---------------------------------------------------- Start App Here !!! -----------------
        public function start(assets:AssetManager):void {
            sAssets = assets;

	        app_status = "start";

            sounds_manager = new SoundsControl();
            sounds_manager.initialize(sAssets);

	        app_status = "load database";

	        new ShareObjectManager();
	        trace("Database ----------------- >>> "+
			        ShareObjectManager.firstLaunch,
			        ShareObjectManager.latestScreen,
			        ShareObjectManager.latestPage
	        );

	        app_status = "initialize";

	        juggler = new Juggler();

            var _assetMediator:AssetMediator = new AssetMediator(sAssets);
            uiBuilder = new UIBuilder(_assetMediator, false, null, null, new DefaultTweenBuilder());
            layout_loader = new LayoutLoader(EmbeddedLayouts, ParsedLayouts);

            pushScreen = "";
            popScreen = "";
            pushScreenID = -1;
            popScreenID = -1;
	        screenCID = 0;

	        screenName = ["Khun by yoo", "KITCHEN", "BATHROOM", "SANITARY", "PUBLIC RESTROOM"];
	        screenPageNum = [2, 7, 3, 8, 3];

	        app_status = "load configuration";
            //----------------------------------- Load XML file --------------------------
            xmlLoader.addEventListener(flash.events.Event.COMPLETE, getConfig);
            xmlLoader.load(new URLRequest("config/config.xml"));

            //----------------------------------- Set Feathers Theme --------------------------
//            new MetalWorksMobileTheme();
//			new MetalWorksMobileCustom();

            timerCount = new StarlingTimer(Starling.juggler, 1000);

        }

        //--------------------------------- Get XML Data ------------------------------------------------------
        public function getConfig(e:flash.events.Event): void {
            XML.ignoreWhitespace = true;
            var config:XML = new XML(e.target.data);
            var myXmlStr:String = config.toString();
            var xmlnsPattern:RegExp = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
            myXmlStr = myXmlStr.replace(xmlnsPattern, "");
            config = new XML(myXmlStr);

//             var screensaverIdleTime:Number = Number(config.APP_SETTING.screensaver_idle_time)*1000;
//            screensaver_idle_time = new StarlingTimer(Starling.juggler, screensaverIdleTime ,1);
	        app_status = "draw objects";
            drawObject();
        }

        public function drawObject():void {
            //------------------------------------- Draw App Screens -------------------------------
//             screen_bg = new Image(sAssets.getTexture("splash_screen"));
//             this.addChild(screen_bg);
            section1 = new Section1();
            section1.initialize(sAssets);
            addChild(section1);
            _RootObject.push(section1);

            section2 = new Section2();
            section2.initialize(sAssets);
            addChild(section2);
            _RootObject.push(section2);

            section3 = new Section3();
            section3.initialize(sAssets);
            addChild(section3);
            _RootObject.push(section3);

            section4 = new Section4();
            section4.initialize(sAssets);
            addChild(section4);
            _RootObject.push(section4);

            section5 = new Section5();
            section5.initialize(sAssets);
            addChild(section5);
            _RootObject.push(section5);

            totalSection = _RootObject.length;

	        hud_control_screen = new HUDControlScreen();
	        hud_control_screen.initialize(sAssets);
	        addChild(hud_control_screen);

	        option_screen = new OptionScreen();
	        option_screen.initialize(sAssets);
	        addChild(option_screen);
	        option_screen.x = -stage.stageWidth;


	        display_3d_screen = new display3DScreen();
	        addChild(display_3d_screen);
	        display_3d_screen.init(sAssets);

	        instruction_screen = new InstructionScreen();
	        instruction_screen.initialize(sAssets);
	        addChild(instruction_screen);
	        instruction_screen.visible = false;

            this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
	        this.addEventListener(NavigationEvent.JUMP_SCREEN, onJumpScreen);
	        this.addEventListener(NavigationEvent.OPTION_SCREEN, displayOption);
            this.addEventListener(ScreenEvent.DISPLAY_PAGE, onChangePageOfScreen);
            this.addEventListener(ScreenEvent.FIRST_PAGE, onChangePageOfScreen);
            this.addEventListener(ScreenEvent.PAGE_MOVE_COMPLETE, onChangePageOfScreen);

	        this.addEventListener(Image3DEvent.DISPLAY_3D, display3DImage);
	        this.addEventListener(Image3DEvent.REMOVE_3D, remove3DImage);

            this.addEventListener(SoundsEvent.PLAY_SOUND, onPlaySound);
            this.addEventListener(SoundsEvent.PAUSE_SOUND, onPauseSound);
            this.addEventListener(SoundsEvent.RESUME_SOUND, onResumeSound);
            this.addEventListener(SoundsEvent.STOP_SOUND, onStopSound);
            
             addEventListener(starling.events.Event.ENTER_FRAME, chkScreensComplete);
        }
        //--------------------------------- Check All Pages Draw Complete -------------------------------------------------
        private function chkScreensComplete(event:starling.events.Event):void{
            if(_RootObject.length > 0) {
                var completeCount:int = 0;
                for(i=0, l=_RootObject.length; i<l; ++i){
                    if(_RootObject[0].drawScreenComplete == true) {
                        completeCount++;
                    }
                }
                if(completeCount == _RootObject.length){
                    removeEventListener(starling.events.Event.ENTER_FRAME, chkScreensComplete);
                    trace("all screens are complete");
	                app_status = "ready";
	                pushScreen = "";
	                popScreen = "";
	                pushScreenID = -1;
	                popScreenID = -1;
//	                ShareObjectManager.clearDatabase();
	                startApp();
                }
            }
        }

        public function startApp():void{
//            disposeAllScreens();
	        app_status = "start running app";
	        resetScreen();
            for(i=0, l=_RootObject.length; i<l; ++i){
                _RootObject[i].x =0;
                _RootObject[i].y =0;
            }
	        hud_control_screen.startScreen();
	        hud_control_screen.visible = true;
			trace("latestScreen = "+ShareObjectManager.latestScreen, "latestPage = "+ShareObjectManager.latestPage);
	        if(pushScreenID >-1 && _RootObject[pushScreenID].currentScreen > -1){
//		        intervalID = setTimeout(resumeToScreen, 1000);
		        hud_control_screen._resuming_text.visible = true;
		        setTimeout(resumeToScreen, 600);
	        }
	        else{
		        gotoMainScreen();
		        if(!ShareObjectManager.firstLaunch) setTimeout(displayInstruction, 1000);
	        }
	        addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }
	    public function resumeToScreen():void{
		    app_status = "resume app";
		    hud_control_screen._resuming_text.visible = false;
		    // resume from database
		    /*this.dispatchEvent(new NavigationEvent(NavigationEvent.JUMP_SCREEN, {
			    _id:ShareObjectManager.latestScreen,
			    _name:"Section"+String(ShareObjectManager.latestScreen+1),
			    _idPge:ShareObjectManager.latestPage
		    }, true));*/

		    //resume from running
		    this.dispatchEvent(new NavigationEvent(NavigationEvent.JUMP_SCREEN, {
			    _id:pushScreenID,
			    _name:"Section"+String(pushScreenID+1),
			    _idPge:_RootObject[pushScreenID].currentScreen
		    }, true));
	    }

		private function gotoMainScreen():void{
			app_status = "section1";
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {_id:0, _name:"section1"}, true));
		}

        public function disposeAllScreens():void
        {
	        app_status = "dispose all";
            for(i=0, l=_RootObject.length; i<l; ++i){
                if(i != pushScreenID){
                    _RootObject[i].disposeTemporarily();
                }
            }
        }

	    public function resetScreen(forceReset:Boolean=false):void {
		    for(i=0, l=_RootObject.length; i<l; ++i){
			    _RootObject[i].disposeTemporarily();
		    }
		    display_3d_screen.visible = false;
		    display_3d_screen.remove3D();
		    display_3d_screen.disposeTemporarily();
		    hud_control_screen.visible = false;
		    instruction_screen.disposeTemporarily();
		    trace(app_status);
		    if(app_status != "option" || forceReset == true){
			    option_screen.visible = false;
			    removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		    }
//		    TweenMax.killDelayedCallsTo(setPageBlur);
	    }

	    private function displayOption(event:NavigationEvent):void {
		    app_status = "option";
		    hud_control_screen.visible = false;
		    popScreen = pushScreen;
		    popScreenID = pushScreenID;
		    option_screen.startScreen();
		    option_screen.x = -stage.stageWidth;
		    option_screen.y = 0;
		    option_screen.visible = true;
		    var _screenData:Object = {};
		    _screenData._screen = _RootObject[pushScreenID];
		    _screenData._screenNum = pushScreenID;
		    _screenData._pageNum = _RootObject[pushScreenID].currentScreen;
		    trace(_screenData._screenNum, _screenData._pageNum);
		    option_screen.addPrevScreen(_screenData);
		    TweenMax.to(option_screen, 0.4, {x:0, ease:Cubic.easeOut});
		    TweenMax.to(_RootObject[pushScreenID], 0.4, {x:stage.stageWidth, ease:Cubic.easeOut, onComplete:resetScreen});
	    }

	    public static function displayInstruction():void{
		    app_status = "instruction";
		    instruction_screen.visible = true;
		    instruction_screen.startScreen();
//		    if(!ShareObjectManager.firstLaunch) ShareObjectManager.firstLaunch = true;
			 ShareObjectManager.firstLaunch = true;
	    }
	    public function display3DImage(event:Image3DEvent):void{
		    app_status = "display 3D image";
		    display_3d_screen.startLoad3D(event.params._productName, event.params._isFullRotate, event.params._startFrame, 30, false);
		    _RootObject[pushScreenID].removeTouchEvent();
		    hud_control_screen.visible = false;
		    display_3d_screen.visible = true;
		    _RootObject[pushScreenID].setBlurFX();
//		    TweenMax.delayedCall(0.3, setPageBlur);
	    }
	    public function remove3DImage(event:Image3DEvent):void{
		    hud_control_screen.visible = true;
		    display_3d_screen.disposeTemporarily();
		    if(pushScreenID>-1){
			    _RootObject[pushScreenID].setTouchEvent();
			    _RootObject[pushScreenID].removeBlurFX();
		    }
	    }
		/*public function setPageBlur():void{
			_RootObject[pushScreenID].setBlurFX();
		}*/
        public static function get assets():AssetManager { return sAssets; }
        
        public static function get currentScreenID():Number { return screenCID; }

	    public static function get currentPageID():Number { return pageID; }

        public static function get prevScreenID():Number { return screenPID; }

        public static function get totalContentSection():Number { return totalSection; }

	    public static function get touchStatus():String { return touchState;}

	    public static function set touchStatus(touchInfo:String):void {touchState = touchInfo;}

        private function onChangeScreen(event:NavigationEvent):void {
	        app_status = "change screen";
            popScreen = pushScreen;
            pushScreen = event.params._name;
            popScreenID = pushScreenID;
            pushScreenID = event.params._id;
            screenCID = pushScreenID;
            screenPID = popScreenID;
            trace(pushScreenID, popScreenID, pushScreen, popScreen);

            switch (event.params._name)
            {
                case "section1":
                    currentAppScreen = "section1";
                    if(popScreenID == -1){
		                section1.x = 0;
		                section1.y = 0;
		                section1.startScreen();
		                section1.playScreen(true);
	                }
                    else{
                         changeScreen(_RootObject[pushScreenID], _RootObject[popScreenID]);
                    }
                    break;
                default:
                    currentAppScreen = pushScreen;
                    changeScreen(_RootObject[pushScreenID], _RootObject[popScreenID]);
            }
        }
	    private function onJumpScreen(event:NavigationEvent):void {
		    app_status = "jump to screen";
		    hud_control_screen.visible = true;
		    popScreen = pushScreen;
		    pushScreen = event.params._name;
		    popScreenID = pushScreenID;
		    pushScreenID = event.params._id;
		    screenCID = pushScreenID;
		    screenPID = popScreenID;
		    pageID = Number(event.params._idPge);
		    trace(event.params._id, event.params._name, event.params._idPge);

		    _RootObject[screenCID].x = stage.stageWidth;
		    _RootObject[screenCID].y = 0;
		    _RootObject[screenCID].setPage(pageID);
		    TweenMax.to(_RootObject[screenCID], 0.4, {x:0, ease:Cubic.easeOut,
			    onComplete:playScreen, onCompleteParams:[true]});
		    TweenMax.to(option_screen, 0.4, {x:-stage.stageWidth, ease:Cubic.easeOut});
	    }

        public function onChangePageOfScreen(event:ScreenEvent):void{
            if(event.type == ScreenEvent.DISPLAY_PAGE){
                _RootObject[pushScreenID].gotoPage(event.params.pageNum);
            }
            else if(event.type == ScreenEvent.FIRST_PAGE){
                _RootObject[pushScreenID].firstPage();
            }
            else if(event.type == ScreenEvent.PAGE_MOVE_COMPLETE) {
	            setPageNumber();
            }
        }
        public function playScreen(isJump:Boolean=false):void {
	        app_status = "section"+String(pushScreenID+1);
            _RootObject[pushScreenID].playScreen();
	        if(isJump == false){
		        disposeAllScreens();
		        if(popScreenID >= 0) _RootObject[popScreenID].disposeTemporarily();
	        }
	        setPageNumber();
	        option_screen.visible = false;
        }
	    public function setPageNumber():void {
		    allCurrentPage = 0;
		    for(i=0, l=pushScreenID; i<l; ++i) {
			    allCurrentPage += screenPageNum[i];
		    }
		    allCurrentPage += _RootObject[pushScreenID].currentScreen;
		    hud_control_screen.setPageNumber(
				    screenName[pushScreenID],
				    _RootObject[pushScreenID].currentScreen,
				    _RootObject[pushScreenID].totalScreen,
				    allCurrentPage
		    );
		    ShareObjectManager.latestScreen = pushScreenID;
		    ShareObjectManager.latestPage = Number(_RootObject[pushScreenID].currentScreen);
	    }
	    public function product1_position():Point{
		    var p_point:Point = null;
		    if(pushScreenID == 3){
			    p_point =_RootObject[pushScreenID]._product_img1_position;
		    }
		    return p_point;
	    }
	    public function product2_position():Point{
		    var p_point:Point = null;
		    if(pushScreenID == 3){
			    p_point =_RootObject[pushScreenID]._product_img2_position;
		    }
		    return p_point;
	    }
        public function changeScreen(targetScreen:Object, currentScreen:Object):void {
            if(targetScreen == null) return;
	        if(screenCID > screenPID){
		        targetScreen.startScreen();
		        targetScreen.x = stage.stageWidth;
		        targetScreen.y = 0;
		        TweenMax.to(targetScreen, 0.4, {x:0, ease:Cubic.easeOut, onComplete:playScreen});
		        if(screenPID >= 0){
			        TweenMax.to(currentScreen, 0.4, {x:-(stage.stageWidth+50), ease:Cubic.easeOut});
		        }
	        }
	        else if(screenCID < screenPID){
		        targetScreen.setLastPage();
		        targetScreen.x = -stage.stageWidth;
		        targetScreen.y = 0;
		        TweenMax.to(targetScreen, 0.4, {x:0, ease:Cubic.easeOut, onComplete:playScreen});
		        if(screenPID >= 0){
			        TweenMax.to(currentScreen, 0.4, {x:stage.stageWidth, ease:Cubic.easeOut});
		        }
	        }
        }


	    ////---------------------- Sound Part From Event-------------------------------------------------------------
	    private static function onPlaySound(event:SoundsEvent):void
	    {
		    sounds_manager.playSound(event.params);
	    }
	    private static function onPauseSound(event:SoundsEvent):void
	    {
		    sounds_manager.pauseSound(event.params.soundName);
	    }
	    private static function onResumeSound(event:SoundsEvent):void
	    {
		    sounds_manager.resumeSound(event.params.soundName);
	    }
	    private static function onStopSound(event:SoundsEvent):void
	    {
		    sounds_manager.stopSound(event.params.soundName);
	    }
	    //---------------------- Sounds Part Playing -------------------------------------------------------------
	    public function playSound(sName:String, sVolume:Number=0.8, sLoop:Boolean=false):void{
		    this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {soundName:sName, volume:sVolume, loops:sLoop}, true));
	    }
	    public function pauseSound(sName:String):void{
		    this.dispatchEvent(new SoundsEvent(SoundsEvent.PAUSE_SOUND, {soundName:sName}, true));
	    }
	    public function resumeSound(sName:String):void{
		    this.dispatchEvent(new SoundsEvent(SoundsEvent.RESUME_SOUND, {soundName:sName}, true));
	    }
	    public function stopSound(sName:String):void{
		    this.dispatchEvent(new SoundsEvent(SoundsEvent.STOP_SOUND, {soundName:sName}, true));
	    }

	    private function onEnterFrame(event:EnterFrameEvent):void {
		    display_3d_screen.advanceTime(event.passedTime);

	    }
    }
}