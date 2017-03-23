package app_events
{
	import starling.events.Event;
	
	public class Image3DEvent extends Event
	{
		public static const SET_STOP:String = "setstop";
		public static const DISPLAY_3D:String = "display3d";
		public static const REMOVE_3D:String = "remove3d";
		public var params:Object;
		
		public function Image3DEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}