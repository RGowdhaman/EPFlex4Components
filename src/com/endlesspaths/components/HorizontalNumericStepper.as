package com.endlesspaths.components
{
	import mx.events.FlexMouseEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import mx.events.FlexEvent;
	import spark.events.TextOperationEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	import com.endlesspaths.skins.*;
	
	[Event(name="change", type="spark.events.TextOperationEvent")]
	
	[SkinState("normal")]
	[SkinState("manual")]
	public class HorizontalNumericStepper extends SkinnableComponent
	{
		private var _valuePrefix:String = "";
		private var _numericValue:Number = 1;
		private var _canManualEdit:Boolean = false;
		private var _isManualEdit:Boolean = false;
		
		[SkinPart(required="true")]
		public var decreaseButton:Button;

		[SkinPart(required="true")]
		public var increaseButton:Button;

		[SkinPart(required="true")]
		public var numericLabel:Label;
		
		[SkinPart(required="true")]
		public var numericManualEdit:TextInput;
		
		[Bindable]
		[Inspectable(name="Label Font Size", category="Styles", defaultValue=20, type="Number")]
		public var labelFontSize:Number;

		public function HorizontalNumericStepper() {
			super();
			
			setStyle("skinClass", Class(HorizontalNumericStepperSkin));
		}
		
		public function get numericValue():Number {
			return _numericValue;
		}
		
		public function set numericValue(val:Number):void {
			if(_numericValue < 0) {
				_numericValue = 0;
			}
			
			_numericValue = val;
		}
		
		public function set valuePrefix(prefix:String):void {
			_valuePrefix = prefix;
		}
		
		override protected function getCurrentSkinState():String {
			return (_isManualEdit == true ? "manual" : "normal");
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == decreaseButton) {
				decreaseButton.addEventListener(MouseEvent.CLICK, decreaseButton_click, false, 0, true);
			} else if (instance == increaseButton) {
				increaseButton.addEventListener(MouseEvent.CLICK, increaseButton_click, false, 0, true);
			} else if (instance == numericLabel) {
				updateLabel();
				
				numericLabel.doubleClickEnabled = numericLabel.buttonMode = true;
				numericLabel.addEventListener(MouseEvent.DOUBLE_CLICK, numericLabel_Click, false, 0, true);
			} else if(instance == numericManualEdit) {
				numericManualEdit.addEventListener(MouseEvent.DOUBLE_CLICK, numericManualEdit_Click, false, 0, true);
				numericManualEdit.addEventListener(FlexEvent.ENTER, numericManualEdit_Click, false, 0, true);
			}
			
			if(numericManualEdit != null && numericLabel != null) {
				_canManualEdit = true;
			}
		}
		
		private function updateLabel():void {
			numericLabel.text = _valuePrefix + numericValue;
			
			this.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == decreaseButton) {
				decreaseButton.removeEventListener(MouseEvent.CLICK, decreaseButton_click);
			} else if (instance == increaseButton) {
				increaseButton.removeEventListener(MouseEvent.CLICK, increaseButton_click);
			} else if(instance == numericManualEdit) {
				numericManualEdit.removeEventListener(MouseEvent.DOUBLE_CLICK, numericManualEdit_Click);
			} else if(instance == numericLabel) {
				numericLabel.removeEventListener(MouseEvent.DOUBLE_CLICK, numericLabel_Click);
			}
		}
		
		private function decreaseButton_click(event:MouseEvent):void {
			numericValue--;
			
			updateLabel();
		}

		private function increaseButton_click(event:MouseEvent):void {
			numericValue++;
			
			updateLabel();
		}
		
		private function numericLabel_Click(event:MouseEvent):void {
			if(_canManualEdit == false) {
				return;
			}
			
			_isManualEdit = true;
			numericManualEdit.text = ""+ numericValue;
			numericManualEdit.height = numericLabel.height;
			numericManualEdit.width = numericLabel.width;	
			numericManualEdit.setFocus();
			
			invalidateSkinState();
		}
		
		private function numericManualEdit_Click(event:Event):void {
			_isManualEdit = false;
			
			try {
				numericValue = parseInt(numericManualEdit.text);
			} catch(error:Error) {
				
			}
			
			this.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, numericManualEdit_Click);
			
			updateLabel();
			invalidateSkinState();
		}
	}
}
