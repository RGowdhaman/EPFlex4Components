package com.endlesspaths.components
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
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
		public var selectedColor_Red:Number = 0;
		[Bindable]
		public var selectedColor_Green:Number = 255;
		[Bindable]
		public var selectedColor_Blue:Number = 0;
		
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
		private var cursorOffsetX:Number = -5;
		private var cursorOffsetY:Number = -5;
		
		[SkinPart(required=true)]
		public var colorHues:Group;
		
		private var prevMouseX:Number;
		private var prevMouseY:Number;
		
		public function ColorSelector() {
			super();
		}
		
		override protected function getCurrentSkinState():String {
			return "normal";
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == colorBox) {
/*				colorBox.addEventListener(MouseEvent.CLICK, colorBox_Click);*/
				colorBox.addEventListener(MouseEvent.MOUSE_OVER, Shared_MouseOver);
				colorBox.addEventListener(MouseEvent.MOUSE_OUT, Shared_MouseOut);
				
				colorBox.addEventListener(MouseEvent.MOUSE_DOWN, colorBox_MouseDown);
			} else if (instance == colorHues) {
/*				colorHues.addEventListener(MouseEvent.CLICK, colorHues_Click);*/
				colorHues.addEventListener(MouseEvent.MOUSE_OVER, Shared_MouseOver);
				colorHues.addEventListener(MouseEvent.MOUSE_OUT, Shared_MouseOut);
				
				colorHues.addEventListener(MouseEvent.MOUSE_DOWN, colorHues_MouseDown);
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
			CursorManager.setCursor(colorSelectorCursorImage, CursorManagerPriority.HIGH, cursorOffsetX, cursorOffsetY);
		}
		
		private function Shared_MouseOut(event:MouseEvent):void {
			CursorManager.removeAllCursors();
		}
		
		private function colorBox_Click(event:MouseEvent):void {
			updateSelectedColor(event.localX, event.localY);
		}
		
		private function colorBox_MouseDown(event:MouseEvent):void {
			colorBoxSelector.visible = false;
		
			colorBox.addEventListener(MouseEvent.MOUSE_UP, colorBox_MouseUp);
			colorBox.addEventListener(MouseEvent.MOUSE_MOVE, colorBox_MouseMove);
		}
		
		private function colorBox_MouseUp(event:MouseEvent):void {
			colorBox.removeEventListener(MouseEvent.MOUSE_UP, colorBox_MouseUp);
			colorBox.removeEventListener(MouseEvent.MOUSE_MOVE, colorBox_MouseMove);
			
			updateSelectedColor(event.localX, event.localY);
			colorBoxSelector.visible = true;
			event.updateAfterEvent();
		}
		
		private function colorBox_MouseMove(event:MouseEvent):void {
			updateSelectedColor(event.localX, event.localY);
			event.updateAfterEvent();
		}
		
		private function updateSelectedColor(x:uint, y:uint):void {
			var bmap:BitmapData = new BitmapData(colorBox.width, colorBox.height, false);
			bmap.draw(colorBox);
			
			colorBoxSelector.y = y + cursorOffsetY;
			colorBoxSelector.x = x + cursorOffsetX;
			
			selectedColor = bmap.getPixel(colorBoxSelector.x, colorBoxSelector.y);
			selectedColor_Red = (selectedColor & 0xff0000) >> 16;
			selectedColor_Green = (selectedColor & 0x00ff00) >> 8;
			selectedColor_Blue = (selectedColor & 0x0000ff);
			selectedColorAsHex = selectedColor.toString(16).toUpperCase();
		}
		
		private function updateSelectedHue(x:uint, y:uint):void {
			var bmap:BitmapData = new BitmapData(colorHues.width, colorHues.height, false);
			bmap.draw(colorHues);
			
			selectedHue = bmap.getPixel(x, y);
			updateSelectedColor(colorBox.width, 0);
			colorBoxSelector.visible = true;
		}
		
		private function colorHues_Click(event:MouseEvent):void {
			updateSelectedHue(event.localX, event.localY);
		}
		
		private function colorHues_MouseDown(event:MouseEvent):void {
			colorHues.addEventListener(MouseEvent.MOUSE_UP, colorHues_MouseUp);
			colorHues.addEventListener(MouseEvent.MOUSE_MOVE, colorHues_MouseMove);
		}
		
		private function colorHues_MouseUp(event:MouseEvent):void {
			colorHues.removeEventListener(MouseEvent.MOUSE_UP, colorHues_MouseUp);
			colorHues.removeEventListener(MouseEvent.MOUSE_MOVE, colorHues_MouseMove);
		}
		
		private function colorHues_MouseMove(event:MouseEvent):void {
			if(!event.buttonDown) {
				return;
			}
			
			updateSelectedHue(event.localX, event.localY);
		}
	}
}
