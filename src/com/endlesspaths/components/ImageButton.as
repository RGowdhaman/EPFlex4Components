package com.endlesspaths.components
{
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ImageButton extends Button
	{
		[Bindable]
		public var image:Class;
		
		[Bindable]
		public var cornerRadius:Number = 2;
		
		[Bindable]
		public var radiusLeft:Number = cornerRadius;
		
		[Bindable]
		public var radiusRight:Number = cornerRadius;
		
		public function ImageButton() {
			super();
			
			trace('type: '+ typeof(image));
		}
	}
}
