package app_events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public static const JUMP_SCREEN:String = "jumpScreen";
		public static const OPTION_SCREEN:String = "optionScreen";
		public static const BACK_PRESSED:String = "backpressed";
		public static const BACK_MOVE:String = "backmove";

		public var params:Object;
		
		public function NavigationEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}