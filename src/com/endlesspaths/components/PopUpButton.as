package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import com.endlesspaths.skins.*;
	
	public class PopUpButton extends SkinnableContainer
	{
		[Bindable]public var arrowPosition:String = "top";
		[Bindable]public var color:Number = 0x000000;
		[Bindable]public var label:String = "";
		[Bindable]public var image:Class = null;
		[Bindable]public var popUpPosition:String = "below";
		[Bindable]public var title:String = "";
		
		public function PopUpButton() {
			super();
			
			setStyle("skinClass", Class(PopUpButtonSkin));
		}
		
		override protected function getCurrentSkinState():String {
			return "normal";
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == contentGroup) {
				// TODO: Maybe something goes here.
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == contentGroup) {
				// TODO: Maybe something goes here.
			}
		}
	}
}
