package com.endlesspaths.components
{
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import flash.events.MouseEvent;
	import mx.events.ItemClickEvent;
	import mx.events.SandboxMouseEvent;
	import mx.events.FlexEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import spark.primitives.Graphic;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import mx.controls.Alert;
	
	import com.endlesspaths.skins.*;
	
	public class GradientSelector extends SkinnableComponent
	{
		[Bindable(Event.CHANGE)]
		public function get selectedColors():Array {
			var _list:Array = new Array();
			
			for(var i:int = 0; i < gradientThumbs.numElements; i++) {
				if(gradientThumbs.getElementAt(i) is GradientSelectorThumb && gradientThumbs.getElementAt(i).visible) {
					var elem:GradientSelectorThumb = gradientThumbs.getElementAt(i) as GradientSelectorThumb;
					_list.push({
						alpha: elem.selectedAlpha,
						color: elem.selectedColor,
						ratio: elem.selectedRatio
					});
				}
			}
			
			_list.sortOn('ratio');
			
			return _list;
		}
		
		private var _selectedColors:Array;
		public function set selectedColors(_list:Array):void {
			_selectedColors = _list;
			
			for(var i:int = 0; i < _list.length; i++) {
				addNewGradientThumb(_list[i].color, _list[i].alpha, _list[i].ratio);
			}
			
			_thumbPositionsDirty = true;
		}
		
		[Bindable]
		public var selectedThumb:GradientSelectorThumb;
		private var _clickOffset:Point;
		private var _thumbPositionsDirty:Boolean = false;
		private var _unscaledWidth:int;
		private var _unscaledHeight:int;
		
		[SkinPart]
		public var gradientTrack:Graphic;
		
		[SkinPart]
		public var gradientTrackContainer:Group;
		
		[SkinPart]
		public var gradientThumbs:Group;
		
		[SkinPart]
		public var info:Label;
		
		public function GradientSelector() {
			super();
			
			setStyle("skinClass", Class(GradientSelectorSkin));
			
			selectedColors = new Array({alpha: 1.0, color: 0xFFAA00, ratio: 0.0},
										{alpha: 1.0, color: 0xFFAAFF, ratio: 1.0});
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if(instance == gradientTrackContainer) {
				gradientTrackContainer.addEventListener(MouseEvent.CLICK, gradientTrack_Click);
			} else if(instance == gradientThumbs || instance == gradientTrack) {
				selectedColors = _selectedColors;
				invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_unscaledWidth = unscaledWidth;
			_unscaledHeight = unscaledHeight;
			
			if(_thumbPositionsDirty) {
				_thumbPositionsDirty = false;
				var trackWidth:int = _unscaledWidth - 12;
				for(var i:int = 0; i < gradientThumbs.numElements; i++) {
					if(gradientThumbs.getElementAt(i) is GradientSelectorThumb) {
						var elem:GradientSelectorThumb = gradientThumbs.getElementAt(i) as GradientSelectorThumb;
						var newX:int = (trackWidth - (elem.width / 2)) * elem.selectedRatio;
						if(newX > trackWidth) {
							newX = trackWidth - 1;
						}
					
						elem.move(newX, 0);
					}
				}
			}
			
			updateGradientTrack();
		}
		
		public function updateGradientTrack():void {
			var g:Graphics = gradientTrack.graphics;
			g.clear();
			
			if(selectedColors.length == 0) {
				return;
			}
			
			var colors:Array = new Array();
			var alphas:Array = new Array();
			var ratios:Array = new Array();
			
			for(var i:int = 0; i < selectedColors.length; i++) {
				colors.push(selectedColors[i].color);
				alphas.push(selectedColors[i].alpha);
				ratios.push(selectedColors[i].ratio * 255);
			}
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(_unscaledWidth, _unscaledHeight);
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
			g.drawRect(0, 0, _unscaledWidth, _unscaledHeight);
			g.endFill();
		}
		
		private function gradientTrack_Click(event:MouseEvent):void {
			var xRatio:Number = event.localX / gradientTrack.getLayoutBoundsWidth();
			
			addNewGradientThumb(0x000000, 1.0, xRatio);
			
			updateGradientTrack();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function gradientThumb_Change(event:Event):void {
			updateGradientTrack();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function pointToValue(x:Number, y:Number):Number
		{
			if (!selectedThumb || !gradientTrack)
				return 0;
			
			var range:Number = 1.0;
			var thumbRange:Number = gradientTrack.getLayoutBoundsWidth() - selectedThumb.getLayoutBoundsWidth();
			return ((thumbRange != 0) ? (x / thumbRange) * range : 0);
		}
		
		protected function gradientThumb_MouseDown(event:MouseEvent):void {
			selectedThumb = event.target as GradientSelectorThumb;
			_clickOffset = selectedThumb.globalToLocal(new Point(event.stageX, event.stageY));
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, true);
			systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpHandler);
			
			dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
		}
		
		protected function system_mouseMoveHandler(event:MouseEvent):void {
			var p:Point = gradientTrack.globalToLocal(new Point(event.stageX, event.stageY));
			var newValue:Number = pointToValue(p.x - _clickOffset.x, p.y - _clickOffset.y);
			
			/* the mouse has gone too far below the track and thumb, so we assume the user wants to delete it. */
			selectedThumb.visible = !(p.y >= (gradientTrack.getLayoutBoundsHeight() + selectedThumb.getLayoutBoundsHeight() + 15));
			
			/* the new value is beyond our threashold, ignore it. */
			if(newValue < 0) {
				newValue = 0;
			} else if(newValue > 1.0) {
				newValue = 1.0;
			}
			
			if (newValue != selectedThumb.selectedRatio) {
				var newWidth:int = (gradientThumbs.getLayoutBoundsWidth() - (selectedThumb.getLayoutBoundsWidth() / 2)) * newValue;
				if(newWidth > gradientTrack.getLayoutBoundsWidth()) {
					newWidth = gradientTrack.getLayoutBoundsWidth() - 1;
				}
				selectedThumb.x = newWidth;
				selectedThumb.selectedRatio = newValue;
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			event.updateAfterEvent();
		}
	
		protected function system_mouseUpHandler(event:MouseEvent):void {
			if(!selectedThumb || selectedThumb == null) {
				return;
			}
			
			event.updateAfterEvent();
			event.stopImmediatePropagation();
			event.preventDefault();
		
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, false);
			systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpHandler);
		
			dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
			
			if(!selectedThumb.visible) {
				removeGradientThumb(selectedThumb);
			}
			
			selectedThumb = null;
		}
		
		private function addNewGradientThumb(_color:uint, _alpha:Number, _ratio:Number):GradientSelectorThumb {
			if(!gradientThumbs || !gradientTrack) {
				return null;
			}
			
			var elem:GradientSelectorThumb = new GradientSelectorThumb();
			elem.setStyle("skinClass", Class(GradientSelectorThumbSkin));
			elem.selectedAlpha = _alpha;
			elem.selectedColor = _color;
			elem.selectedRatio = _ratio;
			
			gradientThumbs.addElement(elem);
			
			var trackWidth:int = gradientTrack.width;
			var newX:int = (trackWidth - (elem.width / 2)) * _ratio;
			if(newX > trackWidth) {
				newX = trackWidth - 1;
			}
			elem.move(newX, 0);
			
			elem.addEventListener(Event.CHANGE, gradientThumb_Change);
			elem.addEventListener(MouseEvent.MOUSE_DOWN, gradientThumb_MouseDown, false, 0);
			
			return elem;
		}
		
		private function removeGradientThumb(thumb:GradientSelectorThumb):void {
			if(thumb) {
				thumb.removeEventListener(Event.CHANGE, gradientThumb_Change);
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, gradientThumb_MouseDown);
				gradientThumbs.removeElement(thumb);
				
				thumb = null;
				
				invalidateDisplayList();
			}
		}
	}
}
