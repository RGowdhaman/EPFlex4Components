package com.endlesspaths.components
{
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import mx.events.PropertyChangeEvent;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	import mx.utils.ColorUtil;
	import spark.primitives.Rect;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.TextInput;
	
	import com.endlesspaths.skins.*;
	
	public class ColorSelector extends SkinnableContainer
	{
		[Bindable]
		public var selectedColor:Number = 0x00F300;
		
		[Bindable]
		public var selectedColor_Red:String = "0";
		[Bindable]
		public var selectedColor_Green:String = "255";
		[Bindable]
		public var selectedColor_Blue:String = "0";
		
		[Bindable]
		public var selectedColorAsHex:String = "00F300";
		
		[Bindable]
		public var selectedHue:Number = 0x00F300;
		
		[Bindable]
		public var textColor:Number = 0xEFEFEF;
		
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
		
		[Bindable]public var localMouseX:Number;
		[Bindable]public var localMouseY:Number;
		
		public function ColorSelector() {
			super();
			
			setStyle("skinClass", Class(ColorSelectorSkin));
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged, false, 0, true);
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
				colorHues.addEventListener(MouseEvent.CLICK, colorHues_Click);
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
		
		protected function boundPropertyChanged(event:PropertyChangeEvent):void {
			if (event.property == "selectedColor_Red" || event.property == "selectedColor_Green" || event.property == "selectedColor_Blue") {
				var color:Number = 0xff;
				var r:Number = parseInt(selectedColor_Red);
				var g:Number = parseInt(selectedColor_Green);
				var b:Number = parseInt(selectedColor_Blue);
				
				updateSelectedColorValues(r << 16 | g << 8 | b);
			} else if(event.property == "selectedColorAsHex") {
				updateSelectedColorValues(parseInt("0x"+ selectedColorAsHex));
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
			localMouseX = x;
			localMouseY = y;
			
			if(localMouseX < 0) localMouseX = 0;
			if(localMouseX > colorBox.width - 2) localMouseX = colorBox.width - 2;
			
			if(localMouseY < 0) localMouseY = 0;
			if(localMouseY > colorBox.height - 2) localMouseY = colorBox.height - 2;
			
			var bmap:BitmapData = new BitmapData(colorBox.width, colorBox.height, false);
			bmap.draw(colorBox);
			
			colorBoxSelector.y = localMouseY;
			colorBoxSelector.x = localMouseX;
			
			updateSelectedColorValues(bmap.getPixel(colorBoxSelector.x, colorBoxSelector.y));
		}
		
		private function updateSelectedColorValues(color:Number):void {
			removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged);
			
			selectedColor = color;
			selectedColor_Red = ((selectedColor >> 16) & 0xff).toString(10);
			selectedColor_Green = ((selectedColor >> 8) & 0xff).toString(10);
			selectedColor_Blue = (selectedColor & 0xff).toString(10);
			selectedColorAsHex = selectedColor.toString(16).toUpperCase();
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged, false, 0, true);
		}
		
		public function updateSelectedHue(x:uint, y:uint):void {
			localMouseX = x;
			localMouseY = y;
			var bmap:BitmapData = new BitmapData(colorHues.width, colorHues.height, false);
			bmap.draw(colorHues);
			
			selectedHue = bmap.getPixel(x, y);
			updateSelectedColor(200, 1);
			colorBoxSelector.visible = true;
		}
		
		public function setColorAndHue(color:Number):void {
			updateSelectedColorValues(color);
			selectedHue = color;
		}
		
		private function rgbToHSV(r:Number, g:Number, b:Number):Number {
			r /= 255;
			g /= 255;
			b /= 255;
			
			var h:Number,s:Number,
				min:Number = Math.min(Math.min(r,g),b),
				max:Number = Math.max(Math.max(r,g),b),
				delta:Number = max-min;
			
			switch (max) {
				case min: h=0; break;
				case r:	  h=60*(g-b)/delta;
					if (g<b) {
						h+=360;
					}
					break;
				case g:	  h=(60*(b-r)/delta)+120; break;
				case b:	  h=(60*(r-g)/delta)+240; break;
			}
			
			return h;
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
