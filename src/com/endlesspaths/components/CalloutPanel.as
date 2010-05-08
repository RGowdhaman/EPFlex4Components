package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class CalloutPanel extends SkinnableContainer
	{
		public function CalloutPanel() {
			super();
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
