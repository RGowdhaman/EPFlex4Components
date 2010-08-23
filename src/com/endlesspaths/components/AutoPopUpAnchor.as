package com.endlesspaths.components
{
	import mx.core.IFlexDisplayObject;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.events.FlexMouseEvent;
	import flash.events.MouseEvent;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import spark.components.PopUpAnchor;
	import mx.controls.Alert;
	import mx.events.ItemClickEvent;
	import spark.events.ElementExistenceEvent;
	import flash.utils.describeType;
	
	import com.endlesspaths.skins.*;
	
	[SkinState("closed")]
	[SkinState("opened")]
	[SkinState("disabled")]
	public class AutoPopUpAnchor extends PopUpAnchor
	{
		private var _previousPopUp:Object = null;
		private var _childrenPopUpsOpen:Number = 0;
		
		public static var POPUP_OPENED:String = "childPopUpOpened";
		public static var POPUP_CLOSED:String = "childPopUpClosed";
		public static var POPUP_MAX:Number = 99;
		
		public function AutoPopUpAnchor() {
			super();
			
			this.addEventListener('popUpChanged', PopUp_Change, false, 0, true);
		}
		
		[Bindable(event='popUpStateChange')]
		public function set popUpOpen(value:Boolean):void {
			displayPopUp = value;
			dispatchEvent(new Event("popUpStateChange"));
			
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
			
			popUp.addEventListener(ItemClickEvent.ITEM_CLICK, popUp_CancelClicks, false, 0, true);
			popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside, false, POPUP_MAX - _childrenPopUpsOpen, true);
			popUp.addEventListener(POPUP_OPENED, childPopUpOpened, false, 0, true);
			popUp.addEventListener(POPUP_CLOSED, childPopUpClosed, false, 0, true);
		}
		
		private function popUp_MouseDownOutside(event:FlexMouseEvent):void {
			if(popUpOpen == true && _childrenPopUpsOpen < 1) {
				popUpOpen = false;
			}
		}
		
		private function popUp_CancelClicks(event:Event):void {
			event.stopImmediatePropagation();
			event.preventDefault();
		}
		
		private function popUpRebindEvent():void {
			popUp.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside);
			popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_MouseDownOutside, false, POPUP_MAX - _childrenPopUpsOpen, true);
		}
		
		private function childPopUpOpened(event:Event):void {
			_childrenPopUpsOpen += 1;
			popUpRebindEvent();
		}
		
		private function childPopUpClosed(event:Event):void {
			_childrenPopUpsOpen -= 1;
			popUpRebindEvent();
		}
	}
}
