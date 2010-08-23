package com.endlesspaths.components
{
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
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
		[Bindable]
		public var selectedColors:ArrayList = new ArrayList([
			new GradientColorEntry(1.0, 0xFFAA00, 0.0),
			new GradientColorEntry(1.0, 0xFFAAFF, 0.0)
		]);
		
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
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, boundPropertyChanged, false, 0, true);
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if(instance == gradientTrackContainer) {
				gradientTrackContainer.addEventListener(MouseEvent.CLICK, gradientTrack_Click, false, 0, true);
			} else if(instance == gradientThumbs || instance == gradientTrack) {
				for(var i:int = 0; i < selectedColors.length; i++) {
					var colorObj:GradientColorEntry = selectedColors.getItemAt(i) as GradientColorEntry;
					addGradientThumb(colorObj);
				}
				
				invalidateDisplayList();
			}
		}
		
		protected function boundPropertyChanged(event:PropertyChangeEvent):void {
			if (event.property == "selectedColors" && selectedColors != null) {
				selectedColors.addEventListener(CollectionEvent.COLLECTION_CHANGE, selectedColors_Change, false, 0, true);
			}
		}
		
		protected function selectedColors_Change(event:CollectionEvent):void {
			var i:int;
			
			if(event.kind == CollectionEventKind.ADD) {
				for(i = 0; i < event.items.length; i++) {
					addGradientThumb(event.items[i]);
				}
			} else if(event.kind == CollectionEventKind.REMOVE) {
				for(i = 0; i < event.items.length; i++) {
					var gradientData:GradientColorEntry = event.items[i] as GradientColorEntry;
					var foundThumb:Boolean = false;
					for(i = 0; i < gradientThumbs.numElements; i++) {
						
						if(gradientThumbs.getElementAt(i) is GradientSelectorThumb) {
							var elem:GradientSelectorThumb = gradientThumbs.getElementAt(i) as GradientSelectorThumb;
							
							if(elem.gradientData == gradientData) {
								removeGradientThumb(elem);
								foundThumb = true;
								break;
							}
						}
					}
				}
			} else if(event.kind == CollectionEventKind.REMOVE) {
				// do nothing?
			}
			
			updateGradientTrack();
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
						var newX:int = (trackWidth - (elem.width / 2)) * elem.gradientData.ratio;
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
			
			if(!selectedColors || selectedColors.length == 0) {
				return;
			}
			
			var colors:Array = new Array();
			var alphas:Array = new Array();
			var ratios:Array = new Array();
			
			var _selectedColors:Array = new Array();
			
			var i:int;
			
			for(i = 0; i < gradientThumbs.numElements; i++) {
				if(gradientThumbs.getElementAt(i) is GradientSelectorThumb) {
					var elem:GradientSelectorThumb = gradientThumbs.getElementAt(i) as GradientSelectorThumb;
					_selectedColors.push(elem.gradientData);
				}
			}
			
			_selectedColors.sortOn('ratio')
			
			for(i = 0; i < _selectedColors.length; i++) {
				var colorObj:Object = _selectedColors[i];
				colors.push(colorObj.color);
				alphas.push(colorObj.alpha);
				ratios.push(colorObj.ratio * 255);
			}
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(_unscaledWidth, _unscaledHeight);
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
			g.drawRect(0, 0, _unscaledWidth, _unscaledHeight);
			g.endFill();
		}
		
		private function gradientTrack_Click(event:MouseEvent):void {
			var xRatio:Number = event.localX / gradientTrack.getLayoutBoundsWidth();
			
			selectedColors.addItem(new GradientColorEntry(1.0, 0x000000, xRatio));
		}
		
		private function gradientThumb_Change(event:Event):void {
			/*selectedThumb = event.target as GradientSelectorThumb;
			
			var change:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			change.kind = CollectionEventKind.UPDATE;
			change.items = [selectedThumb,];
			
			selectedColors.dispatchEvent(change);*/
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
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, system_mouseMoveHandler, true, 0, true);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, system_mouseUpHandler, true, 0, true);
			systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, system_mouseUpHandler, false, 0, true);
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
			
			if (newValue != selectedThumb.gradientData.ratio) {
				var newWidth:int = (gradientThumbs.getLayoutBoundsWidth() - (selectedThumb.getLayoutBoundsWidth() / 2)) * newValue;
				if(newWidth > gradientTrack.getLayoutBoundsWidth()) {
					newWidth = gradientTrack.getLayoutBoundsWidth() - 1;
				}
				selectedThumb.x = newWidth;
				selectedThumb.gradientData.ratio = newValue;
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
			
			if(!selectedThumb.visible) {
				selectedColors.removeItem(selectedThumb.gradientData);
			}
			
			selectedThumb = null;
		}
		
		private function addGradientThumb(colorData:GradientColorEntry):GradientSelectorThumb {
			if(!gradientThumbs || !gradientTrack) {
				return null;
			}
			
			var elem:GradientSelectorThumb = new GradientSelectorThumb();
			elem.gradientData = colorData;
			
			gradientThumbs.addElement(elem);
			
			var trackWidth:int = gradientTrack.width;
			var newX:int = (trackWidth - (elem.width / 2)) * elem.gradientData.ratio;
			if(newX > trackWidth) {
				newX = trackWidth - 1;
			}
			elem.move(newX, 0);
		
			elem.addEventListener(Event.CHANGE, gradientThumb_Change, false, 0, true);
			elem.addEventListener(MouseEvent.MOUSE_DOWN, gradientThumb_MouseDown, false, 0, true);
			
			_thumbPositionsDirty = true;
			
			return elem;
		}
		
		private function removeGradientThumb(thumb:GradientSelectorThumb):void {
			if(thumb) {
				thumb.removeEventListener(Event.CHANGE, gradientThumb_Change);
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, gradientThumb_MouseDown);
				
				gradientThumbs.removeElement(thumb);
				
				thumb = null;
			}
		}
	}
}
