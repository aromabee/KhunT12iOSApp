package app_events
{
	import starling.events.Event;
	
	public class ScreenEvent extends Event
	{
		public static const DISPLAY_PAGE:String = "displayPage";
        public static const FIRST_PAGE:String = "firstPage";
        public static const PAGE_LIGHT_FX:String = "pageLightFx";
        public static const PAGE_MOVE_FX:String = "pageMoveFx";
		public static const PAGE_MOVE_COMPLETE:String = "pageMoveComplete";

		public var params:Object;
		
		public function ScreenEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}