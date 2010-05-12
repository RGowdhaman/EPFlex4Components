package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import mx.managers.CursorManager;
	import mx.utils.ColorUtil;
	import spark.primitives.Rect;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ColorSelector extends SkinnableContainer
	{
		[Bindable]
		public var selectedColor:Number = 0x00F300;
		
		[Bindable]
		public var selectedColorAsHex:String = "00F300";
		
		[Bindable]
		public var selectedHue:Number = 0x00F300;
		
		[SkinPart(required=true)]
		public var colorBox:Group;
		
		[SkinPart(required=true)]
		public var colorBoxSelector:Group;
		
		[Bindable]
		[Embed(source="../../../assets/color-picker-cursor.png")]
		public var colorSelectorCursorImage:Class;
		
		[SkinPart(required=true)]
		public var colorHues:Group;
		
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
				colorBox.addEventListener(MouseEvent.MOUSE_OVER, Shared_MouseOver);
				colorBox.addEventListener(MouseEvent.MOUSE_OUT, Shared_MouseOut);
				colorBox.addEventListener(MouseEvent.MOUSE_MOVE, colorBox_MouseMove);
			} else if (instance == colorHues) {
				colorHues.addEventListener(MouseEvent.CLICK, colorHues_Click);
				colorHues.addEventListener(MouseEvent.MOUSE_OVER, Shared_MouseOver);
				colorHues.addEventListener(MouseEvent.MOUSE_OUT, Shared_MouseOut);
				colorHues.addEventListener(MouseEvent.MOUSE_MOVE, colorHues_MouseMove);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == contentGroup) {
				// TODO: Maybe something goes here.
			}
		}
		
		private function colorAsHex_TextChange(event:Event):void {
			
		}
		
		private function Shared_MouseOver(event:MouseEvent):void {
			CursorManager.removeAllCursors();
			CursorManager.setCursor(colorSelectorCursorImage, -5, -5);
			Mouse.hide();
		}
		
		private function Shared_MouseOut(event:MouseEvent):void {
			CursorManager.removeAllCursors();
			Mouse.show();
		}
		
		private function colorBox_Click(event:MouseEvent):void {
			updateSelectedColor(event.localX, event.localY);
		}
		
		private function colorBox_MouseMove(event:MouseEvent):void {
			if(!event.buttonDown || colorBox == null && event.currentTarget != colorBox) {
				return;
			}
			
			updateSelectedColor(event.localX, event.localY);
		}
		
		private function updateSelectedColor(x:uint, y:uint):void {
			var bmap:BitmapData = new BitmapData(colorBox.width, colorBox.height, false);
			bmap.draw(colorBox);
			
			selectedColor = bmap.getPixel(x, y);
			selectedColorAsHex = selectedColor.toString(16).toUpperCase();
			
			colorBoxSelector.y = y;// - (colorBoxSelector.height / 2);
			colorBoxSelector.x = x - (colorBoxSelector.width / 2);
		}
		
		private function updateSelectedHue(x:uint, y:uint):void {
			var bmap:BitmapData = new BitmapData(colorHues.width, colorHues.height, false);
			bmap.draw(colorHues);
			
			selectedHue = bmap.getPixel(x, y);
			updateSelectedColor(colorBox.width-1, 1);
		}
		
		private function colorHues_Click(event:MouseEvent):void {
			updateSelectedHue(event.localX, event.localY);
		}
		
		private function colorHues_MouseMove(event:MouseEvent):void {
			if(!event.buttonDown) {
				return;
			}
			
			updateSelectedHue(event.localX, event.localY);
		}
	}
}
