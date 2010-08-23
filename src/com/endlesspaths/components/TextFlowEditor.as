package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	import mx.events.PropertyChangeEvent;
	import spark.components.Group;
	import spark.components.TextArea;
	import spark.components.TextSelectionHighlighting;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	import mx.events.FlexEvent;
	import spark.events.IndexChangeEvent;
	
	import com.endlesspaths.skins.*;
	
	public class TextFlowEditor extends SkinnableComponent {
		[Bindable]public var disabled:Boolean = false;
		
		[Bindable]public var selectionAlignmentIndex:Number = 0;
		[Bindable]public var selectionAlignment:String = "left";
		[Bindable]public var selectionFontFamily:String = "Arial";
		[Bindable]public var selectionFontSize:Number = 10;
		[Bindable]public var selectionFontColor:Number = 0x000000;
		[Bindable]public var selectionBold:Boolean = false;
		[Bindable]public var selectionItalic:Boolean = false;
		[Bindable]public var selectionUnderline:Boolean = false;
		
		public var _editor:TextArea;
		
		public function TextFlowEditor() {
			super();
			
			setStyle("skinClass", Class(TextFlowEditorSkin));
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged, false, 0, true);
		}
		
		override protected function getCurrentSkinState():String {
			return (disabled == true ? "disabled" : "normal");
		}
		
		public function get editor():TextArea {
			return _editor;
		}
		
		public function set editor(value:TextArea):void {
			if(_editor != null) {
				_editor.removeEventListener("selectionChange", editor_selectionChangeHandler);
			}
			
			_editor = value;
			_editor.addEventListener("selectionChange", editor_selectionChangeHandler, false, 0, true);
			_editor.selectionHighlighting = TextSelectionHighlighting.ALWAYS;
		}
		
		protected function boundPropertyChanged(event:PropertyChangeEvent):void {
			switch(event.property) {
				case "disabled":
					invalidateSkinState();
					break;
			}
			
			switch(event.property) {
				case "selectionAlignmentIndex":
					switch(selectionAlignmentIndex) {
						case 0:
							selectionAlignment = "left";
							applyFormat("textAlign", TextAlign.LEFT);
							break;
						case 1:
							selectionAlignment = "center";
							applyFormat("textAlign", TextAlign.CENTER);
							break;
						case 2:
							selectionAlignment = "right";
							applyFormat("textAlign", TextAlign.RIGHT);
							break;
						case 3:
							selectionAlignment = "justify";
							applyFormat("textAlign", TextAlign.JUSTIFY);
							break;
					}
					break;
				case "selectionAlignment":
					switch(selectionAlignment) {
						case "left":
							selectionAlignmentIndex = 0;
							applyFormat("textAlign", TextAlign.LEFT);
							break;
						case "center":
							selectionAlignmentIndex = 1;
							applyFormat("textAlign", TextAlign.CENTER);
							break;
						case "right":
							selectionAlignmentIndex = 2;
							applyFormat("textAlign", TextAlign.RIGHT);
							break;
						case "justify":
							selectionAlignmentIndex = 3;
							applyFormat("textAlign", TextAlign.JUSTIFY);
							break;
					}
					break;
				case "selectionFontFamily":
					applyFormat("fontFamily", selectionFontFamily);
					break;
				case "selectionFontSize":
					applyFormat("fontSize", selectionFontSize);
					break;
				case "selectionFontColor":
					applyFormat("color", selectionFontColor);
					break;
				case "selectionBold":
					applyFormatBoolean("fontWeight", FontWeight.BOLD, FontWeight.NORMAL);
					break;
				case "selectionItalic":
					applyFormatBoolean("fontStyle", FontPosture.ITALIC, FontPosture.NORMAL);
					break;
				case "selectionUnderline":
					applyFormatBoolean("textDecoration", TextDecoration.UNDERLINE, TextDecoration.NONE);
					break;
			}
		}
		
		protected function editor_selectionChangeHandler(evt:FlexEvent):void {
			if(_editor == null) {
				return;
			}
			
			var txtLayFmt:TextLayoutFormat = _editor.getFormatOfRange(null, _editor.selectionAnchorPosition, _editor.selectionActivePosition);
		
			switch (txtLayFmt.textAlign) {
				case TextAlign.LEFT:
					selectionAlignmentIndex = 0;
					selectionAlignment = "left";
					break;
				case TextAlign.CENTER:
					selectionAlignmentIndex = 1;
					selectionAlignment = "center";
					break;
				case TextAlign.RIGHT:
					selectionAlignmentIndex = 2;
					selectionAlignment = "right";
					break;
				case TextAlign.JUSTIFY:
					selectionAlignmentIndex = 3;
					selectionAlignment = "justify";
					break;
				default:
					selectionAlignmentIndex = 0;
					selectionAlignment = "left";
					break;
			}
		
			selectionBold = (txtLayFmt.fontWeight == FontWeight.BOLD);
			selectionItalic = (txtLayFmt.fontStyle == FontPosture.ITALIC);
			selectionUnderline = (txtLayFmt.textDecoration == TextDecoration.UNDERLINE);
		
			selectionFontFamily = txtLayFmt.fontFamily;
			selectionFontSize = txtLayFmt.fontSize;
		
			selectionFontColor = txtLayFmt.color;
		
			_editor.setFocus();
		}
		
		public function applyFormat(property:String, newValue:Object):void {
			if(_editor == null) {
				return;
			}
			
			try {
				var txtLayFmt:TextLayoutFormat = _editor.getFormatOfRange(null, editor.selectionAnchorPosition, editor.selectionActivePosition);
				if(txtLayFmt.hasOwnProperty(property)) {
					txtLayFmt[property] = newValue;
				}
				_editor.setFormatOfRange(txtLayFmt, editor.selectionAnchorPosition, editor.selectionActivePosition);
				_editor.setFocus();
			} catch (error:Error) {}
		}
		
		public function applyFormatBoolean(property:String, trueValue:Object, falseValue:Object):void {
			if(_editor == null) {
				return;
			}
			try {
				var txtLayFmt:TextLayoutFormat = _editor.getFormatOfRange(null, editor.selectionAnchorPosition, editor.selectionActivePosition);
				if(txtLayFmt.hasOwnProperty(property)) {
					txtLayFmt[property] = (txtLayFmt[property] == trueValue) ? falseValue : trueValue;
				}
				_editor.setFormatOfRange(txtLayFmt, editor.selectionAnchorPosition, editor.selectionActivePosition);
				_editor.setFocus();
			} catch (error:Error) {}
		}
	}
}
