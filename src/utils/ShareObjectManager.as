package utils {

	import com.jacksonkr.utils.swipeDirection;

	import flash.display.Sprite;
	import flash.net.SharedObject;

	public class ShareObjectManager extends Sprite {

		protected static const SHARED_OBJECT_NAME:String = 'appSession';
//		public var sessionKey:String = "";
//		public var appData:Object;
		public static var firstLaunchAppStatus:Boolean;
		public static var latestScreenNum:Number;
		public static var latestPageNum:Number;
		public static var _data:Object;


		public function ShareObjectManager() {
			firstLaunchAppStatus = false;
			init();
		}
		public static function init(): void {
			_data = {};
			getDatabase();
		}
		public static function getDatabase(): void{
			var sharedObj:SharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
			_data.latestScreenNum =  latestScreenNum = sharedObj.data.latestScreenNum;
			_data.latestPageNum =  latestPageNum = sharedObj.data.latestPageNum;
			_data.firstLaunchAppStatus =  firstLaunchAppStatus = sharedObj.data.firstLaunchAppStatus;
		}
		public static function get firstLaunch(): Boolean { return firstLaunchAppStatus; }
		public static function get latestScreen(): Number { return latestScreenNum; }
		public static function get latestPage(): Number { return latestPageNum; }

		public static function set firstLaunch(appValue:Boolean): void {
			_data.firstLaunchAppStatus =  appValue;
			firstLaunchAppStatus = appValue;
			updateDatabase(_data);
		}
		public static function set latestScreen(appValue:Number): void {
			_data.latestScreenNum =  appValue;
			latestScreenNum = appValue;
			updateDatabase(_data);
		}
		public static function set latestPage(appValue:Number): void {
			_data.latestPageNum =  appValue;
			latestPageNum = appValue;
			updateDatabase(_data);
		}
		public static function updateDatabase(updatedData:Object): void {
			var sharedObj:SharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
			sharedObj.data.firstLaunchAppStatus = updatedData.firstLaunchAppStatus;
			sharedObj.data.latestPageNum = updatedData.latestPageNum;
			sharedObj.data.latestScreenNum = updatedData.latestScreenNum;
			sharedObj.flush();
		}
		public static function clearDatabase(): void {
			var sharedObj:SharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
			sharedObj.clear();
			sharedObj.flush();
		}
	}
}
