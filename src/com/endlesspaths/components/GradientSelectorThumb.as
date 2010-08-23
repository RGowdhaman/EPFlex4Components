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
		public var gradientData:GradientColorEntry;
		
		[SkinPart]
		public var colorEditorPopup:StatefulPopUpAnchor;
		
		public function GradientSelectorThumb() {
			super();
			
			setStyle("skinClass", Class(GradientSelectorThumbSkin));
			
			addEventListener(MouseEvent.MOUSE_DOWN, colorEditorPopup_MouseDown, false, 0, true);
		}
		
		private function colorEditorPopup_Click(event:MouseEvent):void {
			colorEditorPopup.displayPopUp = !colorEditorPopup.displayPopUp;
		}
		
		private function colorEditorPopup_MouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.CLICK, colorEditorPopup_Click, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, colorEditorPopup_MouseMove, false, 0, true);
		}
		
		protected function colorEditorPopup_MouseMove(event:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, colorEditorPopup_Click);
			removeEventListener(MouseEvent.MOUSE_MOVE, colorEditorPopup_MouseMove);
		}
	}
}
