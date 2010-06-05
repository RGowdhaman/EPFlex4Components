package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import com.endlesspaths.skins.*;
	
	public class CalloutPanel extends SkinnableContainer
	{
		[Bindable]
		public var arrowPosition:String = "top";
		
		[Bindable]
		public var title:String = "";
		
		[SkinPart(required=false)]
		public var arrowPathTop:Group;
		
		[SkinPart(required=false)]
		public var arrowPathBottom:Group;
		
		[SkinPart(required=false)]
		public var mainRect:Group;
		
		public function CalloutPanel() {
			super();
			
			setStyle("skinClass", Class(CalloutPanelBlackHUDSkin));
		}
		
		override protected function getCurrentSkinState():String {
			return "normal";
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == contentGroup) {
				// TODO: Maybe something goes here.
			} else if(instance == arrowPathBottom) {
				if(arrowPosition == "bottom") {
					arrowPathBottom.visible = true;
				}
			} else if (instance == arrowPathTop) {
				if(arrowPosition == "top") {
					arrowPathTop.visible = true;
				}
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
