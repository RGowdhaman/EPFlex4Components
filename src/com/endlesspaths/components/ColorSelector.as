package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import mx.utils.ColorUtil;
	import spark.primitives.Rect;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ColorSelector extends SkinnableContainer
	{
		[Bindable]
		public var selectedColor:Number = 0x00F300;
		
		[SkinPart(required="true")]
		public var colorBox:Group;
		
		public function ColorSelector() {
			super();
		}
		
		override protected function getCurrentSkinState():String {
			return "normal";
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == colorBox) {
				colorBox.addEventListener(MouseEvent.CLICK, colorBox_Click);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == contentGroup) {
				// TODO: Maybe something goes here.
			}
		}
		
		private function colorBox_Click(event:MouseEvent):void {
			var spr:BitmapData = colorBox as BitmapData;
			selectedColor = spr.getPixel(event.localX, event.localY);
		}
	}
}
