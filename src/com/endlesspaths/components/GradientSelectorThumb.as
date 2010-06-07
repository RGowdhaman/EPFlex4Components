package com.endlesspaths.components
{
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import flash.events.MouseEvent;
	import mx.events.ItemClickEvent;
	import mx.events.PropertyChangeEvent;
	import flash.display.BitmapData;
	import spark.primitives.Graphic;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import mx.controls.Alert;
	
	import com.endlesspaths.skins.*;
	
	public class GradientSelectorThumb extends Button
	{
		[Bindable]
		public var selectedColor:Number = 0x000000;
		
		[Bindable]
		public var selectedAlpha:Number = 1.0;
		
		[Bindable]
		public var selectedRatio:Number = 0.5;
		
		[SkinPart]
		public var colorEditorPopup:AutoPopUpAnchor;
		
		public function GradientSelectorThumb() {
			super();
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged);
			addEventListener(MouseEvent.MOUSE_DOWN, colorEditorPopup_MouseDown);
		}
		
		private function boundPropertyChanged(event:PropertyChangeEvent):void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function colorEditorPopup_Click(event:MouseEvent):void {
			colorEditorPopup.popUpOpen = !colorEditorPopup.popUpOpen;
		}
		
		private function colorEditorPopup_MouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.CLICK, colorEditorPopup_Click);
			addEventListener(MouseEvent.MOUSE_MOVE, colorEditorPopup_MouseMove);
		}
		
		protected function colorEditorPopup_MouseMove(event:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, colorEditorPopup_Click);
			removeEventListener(MouseEvent.MOUSE_MOVE, colorEditorPopup_MouseMove);
		}
	}
}
