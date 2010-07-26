package com.endlesspaths.components
{
	import flash.events.Event;
	import mx.events.FlexMouseEvent;
	import flash.events.MouseEvent;
	import mx.events.ItemClickEvent
	import mx.collections.ArrayList;
	import spark.primitives.Rect;
	import spark.primitives.BitmapImage;
	import spark.components.Button;
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.PopUpAnchor;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import com.endlesspaths.skins.*;
	
	public class ColorSwatchAlphaSelector extends SkinnableContainer
	{
		[Bindable]
		public var selectedAlpha:Number = 1.0;
		
		[Bindable]
		public var hideAlpha:Boolean = false;
		
		[Bindable]
		public var selectedColor:Number = 0xFF0000;
		
		[Bindable]
		public var colorSwatches:ArrayList = new ArrayList();
		
		[SkinPart]
		public var swatchList:DataGroup;
		
		public function ColorSwatchAlphaSelector() {
			super();
			
			setStyle("skinClass", Class(ColorSwatchAlphaSelectorSkin));
			
			this.colorSwatches.addItem({'color': 0xbb070d});
			this.colorSwatches.addItem({'color': 0xe15353});

			this.colorSwatches.addItem({'color': 0xf889a4});
			this.colorSwatches.addItem({'color': 0x8f488f});
			this.colorSwatches.addItem({'color': 0xa186be});

			this.colorSwatches.addItem({'color': 0x048fd6});
			this.colorSwatches.addItem({'color': 0x00996D});

			this.colorSwatches.addItem({'color': 0x5b872a});
			this.colorSwatches.addItem({'color': 0x8cba03});

			this.colorSwatches.addItem({'color': 0xF2E926});
			this.colorSwatches.addItem({'color': 0xf6bd10});

			this.colorSwatches.addItem({'color': 0xFFFFFF});
			this.colorSwatches.addItem({'color': 0xbfbfbf});
			this.colorSwatches.addItem({'color': 0x808080});
			this.colorSwatches.addItem({'color': 0x404040});
			this.colorSwatches.addItem({'color': 0x000000});
		}
		
		override protected function getCurrentSkinState():String {
			return "normal";
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == swatchList) {
				swatchList.addEventListener(ItemClickEvent.ITEM_CLICK, colorSwatchItem_Click);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == swatchList) {
				swatchList.removeEventListener(ItemClickEvent.ITEM_CLICK, colorSwatchItem_Click);
			}
		}
		
		private function colorSwatchItem_Click(event:ItemClickEvent):void {
			selectedColor = event.item.color;
			
			invalidateSkinState();
		}
	}
}
