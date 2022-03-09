import com.greensock.*;
import com.greensock.plugins.*;
import com.greensock.easing.*;

// by osmosis-wrench 2022
class spin extends MovieClip
{
	var meterDuration:Number;
	var percent:Number;
	
	var spinner:MovieClip;
	var spinner_mask: MovieClip;
	var spinner_half: MovieClip;

	var MeterTimeline:TimelineLite;

	function spin()
	{
		super();
		meterDuration = 3; //duration of the animation in seconds
		MeterTimeline = new TimelineLite({paused:true});
		percent = 360 / 100; //set to increments of 1%, could make this smaller if you want I think.
	}
	
	function onLoad(): Void
	{
		setMeterPercent(0);
		updateMeterPercent(100);
	}
	
	// sets the meter percentage to a specific value, think of it like jumping straight to that value without a tween.
	public function setMeterPercent(DesiredPercent:Number):Void
	{
		MeterTimeline.clear();
		DesiredPercent = doValueClamp(DesiredPercent);
		spinner._rotation = percent * DesiredPercent;
		checkApplyMask();
	}
	
	// makes the meter tween to a specific value
	public function updateMeterPercent(DesiredPercent:Number):Void
	{
		DesiredPercent = doValueClamp(DesiredPercent);
		if (!MeterTimeline.isActive())
		{
			MeterTimeline.clear();
			MeterTimeline.progress(0);
			MeterTimeline.restart();
		}
		MeterTimeline.to(spinner,meterDuration,{_rotation:(percent * DesiredPercent),onUpdate:doUpdate, onUpdateParams:[this], onComplete:doComplete, onCompleteParams:[this], onReverseComplete:doComplete, onReverseCompleteParams:[this], onStart:doStart, onStartParams:[this], ease:Linear.easeNone})
		MeterTimeline.play();
	}
	
	public function checkApplyMask(): Void
	{
		if (spinner._rotation <= 0){
			spinner_mask._rotation = 0;
			spinner_half._alpha = 100;
		} else {
			spinner_mask._rotation = 180;
			spinner_half._alpha = 0;
		}
	}
	
	// clamp values > 100 at 100 and values <= 0 to 0.01;
	// because of how flash handles angles, we let 0% == 0.01 so that it still appears to be 0 but it doesn't break our mask check.
	public function doValueClamp(clampValue:Number):Number
	{
		return clampValue > 100 ? 100 : (clampValue <= 0 ? 0.01 : clampValue);
	}
	
	// fires when a TweenLite makes a new stage in the tween.
	private function doUpdate(mc: MovieClip): Void
	{
		mc.checkApplyMask();
	}
	
	// fires when a TweenLite completes the tween ( both forwards and reverse )
	public function doComplete(mc: MovieClip): Void
	{
		trace("end");
	}
	
	// fires when a TweenLite starts the tween.
	public function doStart(mc: MovieClip): Void
	{
		trace("start");
	}
}