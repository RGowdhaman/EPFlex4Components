package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import spark.components.ToggleButton;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ImageToggleButton extends ToggleButton
	{
		[Bindable]
		public var image:Class;
		
		[Bindable]
		public var cornerRadius:Number = 2;
		
		[Bindable]
		public var radiusLeft:Number = cornerRadius;
		
		[Bindable]
		public var radiusRight:Number = cornerRadius;
		
		public function ImageToggleButton() {
			super();
		}
	}
}
