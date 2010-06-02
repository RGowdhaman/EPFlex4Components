package com.endlesspaths.components
{
	import mx.core.IFlexDisplayObject;
	import flash.events.Event;
	import mx.events.FlexMouseEvent;
	import spark.components.PopUpAnchor;
	
	public class AutoPopUpAnchor extends PopUpAnchor
	{
		[Bindable]
		public var priority:Number = 0;
		
		private var _previousPopUp:Object = null;
		private var _childrenPopUpsOpen:Number = 0;
		
		private var _mouseEventTimeout:Number = 0;
		private var _previousMouseEvent:FlexMouseEvent = null;
		
		public static var POPUP_OPENED:String = "childPopUpOpened";
		public static var POPUP_CLOSED:String = "childPopUpClosed";
		public static var POPUP_MAX:Number = 99;
		
		public function AutoPopUpAnchor() {
			super();
			
			addEventListener('popUpChanged', PopUp_Change);
		}
		
		[Bindable ("popUpOpen")]
		public function set popUpOpen(value:Boolean):void {
			displayPopUp = value;
			dispatchEvent(new Event("popUpOpen"));
			if(displayPopUp) {
				dispatchEvent(new Event(POPUP_OPENED, true));
			} else {
				dispatchEvent(new Event(POPUP_CLOSED, true));
			}
		}
		
		public function get popUpOpen():Boolean {
			return displayPopUp;
		}
		
		private function PopUp_Change(event:Event):void {
			if(_previousPopUp != null) {
				_previousPopUp.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside);
				_previousPopUp.removeEventListener(POPUP_OPENED, childPopUpOpened);
				_previousPopUp.removeEventListener(POPUP_CLOSED, childPopUpClosed);
				_previousPopUp = null;
			}
			// cache the reference for future use.
			_previousPopUp = popUp;
			
			popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside, false, POPUP_MAX - _childrenPopUpsOpen);
			popUp.addEventListener(POPUP_OPENED, childPopUpOpened);
			popUp.addEventListener(POPUP_CLOSED, childPopUpClosed);
		}
		
		private function popUp_MouseDownOutside(event:FlexMouseEvent):void {
			trace('open: '+ popUpOpen +', children: '+ _childrenPopUpsOpen);
			if(popUpOpen == true && _childrenPopUpsOpen < 1) {
				popUpOpen = false;
			}
		}
		
		private function popUpRebindEvent():void {
			popUp.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside);
			popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside, false, POPUP_MAX - _childrenPopUpsOpen);
		}
		
		private function childPopUpOpened(event:Event):void {
			_childrenPopUpsOpen += 1;
			trace('child popup opened');
			popUpRebindEvent();
		}
		
		private function childPopUpClosed(event:Event):void {
			_childrenPopUpsOpen -= 1;
			trace('child popup closed');
			popUpRebindEvent();
		}
	}
}
