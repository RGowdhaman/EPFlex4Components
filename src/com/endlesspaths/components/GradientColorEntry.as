package com.endlesspaths.components
{	import com.endlesspaths.skins.*;
	
	public class GradientColorEntry
	{
		[Bindable]
		public var color:Number;
		           
		[Bindable] 
		public var alpha:Number;
		           
		[Bindable] 
		public var ratio:Number;
		
		public function GradientColorEntry(_alpha:Number = 1.0, _color:Number = 0x000000, _ratio:Number = 0.5) {
			this.alpha = _alpha;
			this.color = _color;
			this.ratio = _ratio;
		}
	}
}
