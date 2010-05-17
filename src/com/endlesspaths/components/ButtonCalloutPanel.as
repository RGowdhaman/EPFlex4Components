package com.endlesspaths.components
{
	import mx.events.FlexMouseEvent;
	import flash.events.MouseEvent;
	import spark.primitives.BitmapImage;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.PopUpAnchor;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ButtonCalloutPanel extends CalloutPanel
	{
		[SkinPart(required="true")]
		public var theButton:Button;
		
		[SkinPart(required="true")]
		public var calloutPanel:PopUpAnchor;
		
		private var _isOpen:Boolean = false;
		
		[Bindable]
		public var label:String = "Button";
/*		public var icon:BitmapImage = null;*/
		
		public function ButtonCalloutPanel() {
			super();
		}
		
		public function open():void {
			_isOpen = true;
			
			invalidateSkinState();
		}
		
		public function close():void {
			_isOpen = false;
			
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String {
			return (_isOpen == true ? "open" : "normal");
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == theButton) {
				// TODO: Maybe something goes here.
				theButton.addEventListener(MouseEvent.CLICK, theButton_Click);
			} else if(instance == calloutPanel) {
				calloutPanel.popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, theButton_Click);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == contentGroup) {
				// TODO: Maybe something goes here.
			}
		}
		
		private function theButton_Click(event:Event):void {
			_isOpen = !_isOpen;
			
			invalidateSkinState();
		}
	}
}
