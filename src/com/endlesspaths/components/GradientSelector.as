package com.endlesspaths.components
{
	import mx.collections.ArrayList;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class GradientSelector extends SkinnableComponent
	{
		[Bindable]
		public var selectedColors:ArrayList;
		
		[SkinPart]
		public var gradientSlide:
		
		public function GradientSelector() {
			super();
		}
		
		private function handleAddCorrectPoint(e:MouseEvent):void {
		    var newValue:Number = idCorrectSlider.minimum + (e.localX / idCorrectSlider.width) * (idCorrectSlider.maximum - idCorrectSlider.minimum);
		    newValue = int(newValue * 100)/100;
		    if (!(e.target is SliderThumb))
		    {
		        latestCorrect = newValue;
		        idCorrectSlider.thumbCount++;
		        var arr:Array = idCorrectSlider.values;
		        arr.push(newValue);
		        idCorrectSlider.values = arr.sort();
		        idCorrectSlider.invalidateProperties();

		        trace('Correct: ' + e.localX + " , new: " + newValue + " values: " + idCorrectSlider.values);
		        update();
		    }
		}
	}
}
