package com.endlesspaths.components
{
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import mx.events.ItemClickEvent;
	import mx.events.SandboxMouseEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.geom.Point;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	import mx.utils.ColorUtil;
	import spark.primitives.Rect;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.TextInput;
	import mx.utils.HSBColor;
	
	import com.endlesspaths.skins.*;
	
	import mx.controls.Alert;
	
	public class ColorSelector extends SkinnableContainer
	{
		[SkinPart(required=true)]public var colorBox:Group;
		[SkinPart(required=true)]public var colorBoxSelector:Group;
		[SkinPart(required=true)]public var colorHues:Group;
		
		[Bindable]public var selectedColor:Number = 0x00F300;
		[Bindable]public var selectedColor_Red:String = "0";
		[Bindable]public var selectedColor_Green:String = "255";
		[Bindable]public var selectedColor_Blue:String = "0";
		[Bindable]public var selectedColorAsHex:String = "00F300";
		[Bindable]public var selectedHue:Number = 0x00F300;
		
		[Bindable]public var textColor:Number = 0xEFEFEF;
		
		[Embed(source="../../../assets/color-picker-cursor.png")]
		[Bindable]public var colorSelectorCursorImage:Class;
		[Bindable]public var cursorOffsetX:Number = -5;
		[Bindable]public var cursorOffsetY:Number = -5;
		
		private var _mouseEventTarget:Group;
		private var _colorBoxMouseX:Number;
		private var _colorBoxMouseY:Number;
		
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
				colorBox.addEventListener(MouseEvent.ROLL_OVER, Shared_MouseOver, false, 0, true);
				colorBox.addEventListener(MouseEvent.MOUSE_DOWN, colorBox_MouseDown, false, 0, true);
			} else if (instance == colorHues) {
				colorHues.addEventListener(MouseEvent.ROLL_OVER, Shared_MouseOver, false, 0, true);
				colorHues.addEventListener(MouseEvent.MOUSE_DOWN, colorHues_MouseDown, false, 0, true);
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
		
		private function Shared_MouseOver(event:MouseEvent):void {
			CursorManager.removeAllCursors();
			CursorManager.setCursor(colorSelectorCursorImage, CursorManagerPriority.HIGH, cursorOffsetX, cursorOffsetY);
			
			if(event.target == colorBox) {
				colorBoxSelector.visible = false;
			}
			
			event.target.removeEventListener(MouseEvent.ROLL_OVER, Shared_MouseOver);
			event.target.addEventListener(MouseEvent.ROLL_OUT, Shared_MouseOut, false, 0, true);
		}
		
		private function Shared_MouseOut(event:MouseEvent):void {
			if(!_mouseEventTarget)
				CursorManager.removeAllCursors();
			
			if(event.target == colorBox) {
				colorBoxSelector.visible = true;
			}
			
			event.target.removeEventListener(MouseEvent.ROLL_OUT, Shared_MouseOut);
			event.target.addEventListener(MouseEvent.ROLL_OVER, Shared_MouseOver, false, 0, true);
		}
		
		private function colorBox_MouseDown(event:MouseEvent):void {
			colorBoxSelector.visible = false;
			
			_mouseEventTarget = colorBox;
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true, 0, true);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, true, 0, true);
			systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpSomewhereHandler, false, 0, true);
		}
		
		protected function system_mouseMoveHandler(event:MouseEvent):void {
			if(!event.buttonDown) {
				event.updateAfterEvent();
				event.stopImmediatePropagation();
				event.preventDefault();

				systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true);
				systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, false);
				systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpSomewhereHandler);
			} else if(_mouseEventTarget) {
				var p:Point = _mouseEventTarget.globalToLocal(new Point(event.stageX, event.stageY));
			
				if(_mouseEventTarget == colorBox) {
					updateSelectedColor(p.x, p.y);
				} else if(_mouseEventTarget == colorHues) {
					updateSelectedHue(p.x, p.y);
				}
				
				event.updateAfterEvent();
			}
		}
	
		protected function system_mouseUpHandler(event:MouseEvent):void {
			event.updateAfterEvent();
			event.stopImmediatePropagation();
			event.preventDefault();
		
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, false);
			systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpSomewhereHandler);
			
			if(_mouseEventTarget) {
				var p:Point = _mouseEventTarget.globalToLocal(new Point(event.stageX, event.stageY));
				
				if(_mouseEventTarget == colorBox) {
					updateSelectedColor(p.x, p.y);
					colorBoxSelector.visible = true;
				} else if(_mouseEventTarget == colorHues) {
					updateSelectedHue(p.x, p.y);
				}
			}
			
			_mouseEventTarget = null;
			CursorManager.removeAllCursors();
		}
		
		protected function system_mouseUpSomewhereHandler(event:SandboxMouseEvent):void {
			event.stopImmediatePropagation();
			event.preventDefault();
		
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler);
			systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpSomewhereHandler);
			
			_mouseEventTarget = null;
		}
		
		private function updateSelectedColor(x:uint, y:uint):void {
			_colorBoxMouseX = x;
			_colorBoxMouseY = y;
			
			if(_colorBoxMouseX >= 10000000) _colorBoxMouseX = 0;
			if(_colorBoxMouseY >= 10000000) _colorBoxMouseY = 0;
			
			if(_colorBoxMouseX < 0) _colorBoxMouseX = 2;
			if(_colorBoxMouseX > colorBox.width - 2) _colorBoxMouseX = colorBox.width - 2;
			
			if(_colorBoxMouseY < 0) _colorBoxMouseY = 2;
			if(_colorBoxMouseY > colorBox.height - 2) _colorBoxMouseY = colorBox.height - 2;
			
			var bmap:BitmapData = new BitmapData(colorBox.width, colorBox.height, false);
			bmap.draw(colorBox);
			
			colorBoxSelector.y = _colorBoxMouseY;
			colorBoxSelector.x = _colorBoxMouseX;
			
			updateSelectedColorValues(bmap.getPixel(colorBoxSelector.x, colorBoxSelector.y));
		}
		
		private function updateSelectedColorValues(color:Number):void {
			removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged);
			
			selectedColor = color;
			selectedColor_Red = ((selectedColor >> 16) & 0xff).toString();
			selectedColor_Green = ((selectedColor >> 8) & 0xff).toString();
			selectedColor_Blue = (selectedColor & 0xff).toString();
			selectedColorAsHex = selectedColor.toString(16).toUpperCase();
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged, false, 0, true);
		}
		
		public function updateSelectedHue(x:uint, y:uint):void {
			if(x >= 10000000) x = 0;
			if(y >= 10000000) y = 0;
			
			if(x < 0) x = 2;
			if(x > colorHues.width - 2) x = colorHues.width - 2;
			
			if(y < 0) y = 2;
			if(y > colorHues.height - 2) y = colorHues.height - 2;
			
			var bmap:BitmapData = new BitmapData(colorHues.width, colorHues.height, false);
			bmap.draw(colorHues);
			
			selectedHue = bmap.getPixel(x, y);
			updateSelectedColor(_colorBoxMouseX, _colorBoxMouseY);
			colorBoxSelector.visible = true;
		}
		
		public function setColorAndHue(color:Number):void {
			updateSelectedColorValues(color);
			
			var hsb:HSBColor = HSBColor.convertRGBtoHSB(color);
			
			colorBoxSelector.x = _colorBoxMouseX = colorBox.width * hsb.saturation;
			colorBoxSelector.y = _colorBoxMouseY = colorBox.height * (1.0 - hsb.brightness);
			colorBoxSelector.visible = true;
			
			hsb.saturation = 1.0;
			hsb.brightness = 1.0;
			selectedHue = HSBColor.convertHSBtoRGB(hsb.hue, hsb.saturation, hsb.brightness);
		}
		
		private function colorHues_Click(event:MouseEvent):void {
			updateSelectedHue(event.localX, event.localY);
		}
		
		private function colorHues_MouseDown(event:MouseEvent):void {
			_mouseEventTarget = colorHues;
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true, 0, true);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, true, 0, true);
			systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpSomewhereHandler, false, 0, true);
		}
	}
}
