package com.endlesspaths.components
{
	import mx.collections.ArrayList;
	import mx.events.FlexMouseEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	import com.endlesspaths.skins.*;
	
	[SkinState("normal")]
	[SkinState("manual")]
	public class HorizontalListStepper extends SkinnableComponent
	{
		private var _valuePrefix:String = "";
		private var _valuesList:ArrayList = null;
		private var _currentPosition:Number = 1;
		
		[SkinPart(required="true")]
		public var decreaseButton:Button;

		[SkinPart(required="true")]
		public var increaseButton:Button;

		[SkinPart(required="true")]
		public var stepperLabel:Label;
		
		[Bindable]
		[Inspectable(name="Label Font Size", category="Styles", defaultValue=20, type="Number")]
		public var labelFontSize:Number;

		public function HorizontalListStepper() {
			super();
			
			setStyle("skinClass", Class(HorizontalListStepperSkin));
		}
		
		public function set source(val:ArrayList):void {
			_valuesList = val;
		}
		
		public function get currentItem():Object {
			return (_valuesList != null ? _valuesList.getItemAt(_currentPosition) : null);
		}
		
		public function set currentItem(val:Object):void {
			_currentPosition = _valuesList.getItemIndex(val);
		}
		
		public function get currentPosition():Number {
			return _currentPosition;
		}
		
		public function set currentPosition(val:Number):void {
			_currentPosition = val;
			
			if(_currentPosition < 0) {
				_currentPosition = 0;
			} else if(_currentPosition >= _valuesList.length) {
				_currentPosition = 0;
			}
		}
		
		public function set valuePrefix(prefix:String):void {
			_valuePrefix = prefix;
		}
		
		override protected function getCurrentSkinState():String {
			return "normal";
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == decreaseButton) {
				decreaseButton.addEventListener(MouseEvent.CLICK, decreaseButton_click);
			} else if (instance == increaseButton) {
				increaseButton.addEventListener(MouseEvent.CLICK, increaseButton_click);
			} else if (instance == stepperLabel) {
				updateLabel();
			}
		}
		
		private function updateLabel():void {
			if(currentItem.hasOwnProperty("label")) {
				stepperLabel.text = _valuePrefix + currentItem.label;
			} else {
				stepperLabel.text = _valuePrefix + currentItem;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == decreaseButton) {
				decreaseButton.removeEventListener(MouseEvent.CLICK, decreaseButton_click);
			} else if (instance == increaseButton) {
				increaseButton.removeEventListener(MouseEvent.CLICK, increaseButton_click);
			}
		}
		
		private function decreaseButton_click(event:MouseEvent):void {
			currentPosition--;
			
			updateLabel();
		}

		private function increaseButton_click(event:MouseEvent):void {
			currentPosition++;
			
			updateLabel();
		}
	}
}
