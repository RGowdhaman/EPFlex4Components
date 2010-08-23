package com.endlesspaths.components
{
	import mx.controls.Alert;
	
	import flash.events.MouseEvent;
	import mx.core.UIComponent;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import com.endlesspaths.skins.*;
	
	public class StatefulPopUpAnchor extends SkinnableContainer
	{
		[Bindable]public var activatorElement:UIComponent = null;
		[Bindable]public var popUpPosition:String = "top";
		
		[Bindable]public var displayPopUp:Boolean = false;
		
		private var _lastTimePopUpClosed:Number = -1;
		
		[SkinPart]public var popUpAnchor:AutoPopUpAnchor;
		
		public function StatefulPopUpAnchor() {
			super();
			
			setStyle("skinClass", Class(StatefulPopUpAnchorSkin));
		}
		
		override protected function getCurrentSkinState():String {
			var currentTime:Number = (new Date()).getTime();
			if(displayPopUp == true && (_lastTimePopUpClosed + 250) > currentTime) {
				displayPopUp = false;
				return "normal";
			}
			
			return (displayPopUp ? "opened" : "normal");
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == popUpAnchor) {
				popUpAnchor.addEventListener('popUpStateChange', popUpAnchor_popUpOpenChange, false, 0, true);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == popUpAnchor) {
				popUpAnchor.removeEventListener('popUpStateChange', popUpAnchor_popUpOpenChange);
			}
		}
		
		protected function popUpAnchor_popUpOpenChange(event:Event):void {
			if(displayPopUp == false) {
				_lastTimePopUpClosed = (new Date).getTime();
			}
			
			invalidateSkinState();
		}
	}
}
