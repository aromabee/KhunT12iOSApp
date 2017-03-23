package {

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.StringUtil;
	import starling.utils.SystemUtil;

	import utils.ProgressBar;
	import utils.ScreenSetup;

//	import net.hires.debug.Stats;


    [SWF(width = "768", height = "1024", frameRate = "30", backgroundColor = "#ffffff")]

    public class Khun_T12 extends Sprite {

        public const StageWidth: int = 768;
        public const StageHeight: int = 1024;

	    public static var appWidth:Number;
	    public static var appHeight:Number;
        public static var screenWidth:Number;
        public static var screenHeight:Number;
        public static var scaleScreen:Number;
	    public static var scaleFactor:Number;

        private var mStarling: Starling;
        private var mBackground: Loader;
        private var mProgressBar: ProgressBar;

	    private var intervalID: uint;
	    private var _stage:Stage = stage;

	    public static var ipadProDisplay: String;
        private var multipleTexturePath: String;

        public function Khun_T12() {
	        appWidth = StageWidth;
	        appHeight = StageHeight;

	        ipadProDisplay = "";

	        var screen:ScreenSetup = new ScreenSetup(stage.fullScreenWidth, stage.fullScreenHeight, [1, 2]);
	        var stageSize:Rectangle  = new Rectangle(0, 0, StageWidth, StageHeight);
	        var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);

//	        new CapabilitiesDisplay();
//	        scaleScreen = int((screenSize.width/stageSize.width)*10000)/10000; //fix decimal Ex. x.00, x.000, x.0000
	        screenWidth = screenSize.width;
	        screenHeight = screenSize.height;
	        if(screenWidth == 2048 && screenHeight == 2732) ipadProDisplay = "pro";

	        scaleScreen = screenSize.width/stageSize.width;
	        trace("scale_Screen = "+scaleScreen, ipadProDisplay);

//	        (SystemUtil.isDesktop) ? scaleFactor = Math.round(screen.scale) : scaleFactor = screen.scale;
	        if(ipadProDisplay == "pro"){
		        scaleFactor = 1;
		        scaleScreen = 1;
	        }
	        else{
		        scaleFactor = Math.round(screen.scale);
	        }

	        Starling.multitouchEnabled = true; // useful on mobile devices

	        var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);

//            mStarling = new Starling(Root, stage, screen.viewPort);
	        mStarling = new Starling(Root, stage, viewPort);
	        mStarling.stage.stageWidth    = screenSize.width;
	        mStarling.stage.stageHeight   = screenSize.height;
	        mStarling.skipUnchangedFrames = true;
	        mStarling.simulateMultitouch  = false;
//            mStarling.showStatsAt("left", "top", 3);


	        trace("Custom viewPort Width = " + viewPort.width);
	        trace("Custom viewPort Height = " + viewPort.height);
	        trace("ScreenSetup viewPort Width = " + screen.viewPort.width);
	        trace("ScreenSetup viewPort Height = " + screen.viewPort.height);
	        trace("viewPort screen Width = " + Starling.current.viewPort.width);
	        trace("viewPort screen Height = " + Starling.current.viewPort.height);
	        trace("screen Width = " + screenSize.width);
	        trace("screen Height = " + screenSize.height);
	        trace("ScreenSetup Width = " + screen.stageWidth);
	        trace("ScreenSetup Height = " + screen.stageHeight);
	        trace("starling stage Width = " + Starling.current.stage.stageWidth);
	        trace("starling stage Height = " + Starling.current.stage.stageHeight);
	        trace("stage default App Width = " + stage.stageWidth);
	        trace("stage default App Height = " + stage.stageHeight);
	        trace("scaleFactor = " + scaleFactor);

	        mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function(e:*):void {
		        loadAssets(scaleFactor, startApp);
	        });

	        mStarling.start();
	        initElements(scaleFactor);
        }

	    private function loadAssets(scaleFactor: int, onComplete: Function): void {

	        var appDir: File = File.applicationDirectory;
	        var assets: AssetManager = new AssetManager(scaleFactor);

	        multipleTexturePath = (ipadProDisplay == "pro")?"app_assets/textures/2xpro":"app_assets/textures/"+scaleFactor+"x";

	        assets.verbose = Capabilities.isDebugger;
	        assets.enqueue(
			        appDir.resolvePath("app_assets/sounds"),
			        appDir.resolvePath("app_assets/fonts"),
			        appDir.resolvePath("app_assets/textures/systems"),
			        appDir.resolvePath(StringUtil.format(multipleTexturePath, scaleFactor))
	        );

	        trace("textures path = "+"app_assets/textures/"+scaleFactor+"x"+ipadProDisplay);
	        //assets.enqueue(EmbeddedAssets); //------------------------------------***

	        assets.loadQueue(function (ratio: Number): void {
		        mProgressBar.ratio = ratio;
		        if (ratio == 1) {
			        // now would be a good time for a clean-up
			        System.pauseForGCIfCollectionImminent(0);
			        System.gc();
			        onComplete(assets);
		        }
	        });
        }

	    private function startApp(assets: AssetManager): void {
            var root: Root = mStarling.root as Root;
            root.start(assets);
            setTimeout(removeElements, 150); // delay to make 100% sure there's no flickering.

            if (!SystemUtil.isDesktop) {
                NativeApplication.nativeApplication.addEventListener(
                        flash.events.Event.ACTIVATE, function (e: * ): void {
                            clearInterval(intervalID);
			                _stage.frameRate = 30;
			                mStarling.start();
//			                stage.frameRate = 30;
			                intervalID = setTimeout(function():void{
				                clearInterval(intervalID);
				                root.startApp();//Resume App
			                }, 100);
                        });
                NativeApplication.nativeApplication.addEventListener(
                        flash.events.Event.DEACTIVATE, function (e: * ): void {
			                root.resetScreen(true);
//			                stage.frameRate = 4;
			                intervalID = setTimeout(function():void{
				                clearInterval(intervalID);
				                mStarling.stop(true);
				                _stage.frameRate = 4;
			                }, 300);
                        });
            }
        }
        
        private function initElements(scaleFactor:int): void {
//            var bgPath: String = StringUtil.format(String(multipleTexturePath)+"/splash_screen.jpg", scaleFactor);
	        var bgPath: String;
	        if(ipadProDisplay == "pro"){
		        bgPath ="app_assets/textures/2xpro/splash_screen.jpg";
	        }
	        else{
		        bgPath ="app_assets/textures/"+scaleFactor+"x/splash_screen.jpg";
	        }

            var bgFile: File = File.applicationDirectory.resolvePath(bgPath);
            var bytes: ByteArray = new ByteArray();
            var stream: FileStream = new FileStream();
            stream.open(bgFile, FileMode.READ);
            stream.readBytes(bytes, 0, stream.bytesAvailable);
            stream.close();
            
            mBackground = new Loader();
            mBackground.loadBytes(bytes);
	        mBackground.scaleX = Khun_T12.scaleScreen/Khun_T12.scaleFactor;
	        mBackground.scaleY = Khun_T12.scaleScreen/Khun_T12.scaleFactor;
            mStarling.nativeOverlay.addChild(mBackground);

            mBackground.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
                    function (e: Object): void {
                        (mBackground.content as Bitmap)
                                .smoothing = true;
                        mBackground.x = (screenWidth - mBackground.width)/2;
                        mBackground.y = (screenHeight - mBackground.height)/2;
                    });
            mProgressBar = new ProgressBar(300*scaleScreen, 8*scaleScreen);
            mProgressBar.x = (screenWidth - mProgressBar.width) / 2;
            mProgressBar.y = screenHeight * 0.85;
            mStarling.nativeOverlay.addChild(mProgressBar);
        }
        
        private function removeElements(): void {
            if (mBackground) {
                mStarling.nativeOverlay.removeChild(mBackground);
                mBackground = null;
            }
            if (mProgressBar) {
                mStarling.nativeOverlay.removeChild(mProgressBar);
                mProgressBar = null;
            }
        }
    }
}