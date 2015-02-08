function countdown_timer()
{
	// increase timer
	current_time--;
	document.getElementById('countdown').innerHTML = current_time;
	if(current_time == 0)
	{
		update();
		current_time=updateIntervalsetting;
	}
}

function toggleInterval()
{
	if(document.getElementById('autoupdate_checkbox').checked)
	{
		if(updateInterval==null){update(); current_time=updateIntervalsetting; updateInterval = window.setInterval('countdown_timer()', 1000);} 
		document.getElementById('autoupdate_checkbox_label').innerHTML = 'GPIO states will update in <span id="countdown">10</span> seconds.';
		if(updateInterval!=null){console.log("updateInterval set");}
	}
	else
	{
		if(updateInterval!=null){window.clearInterval(updateInterval);}
		document.getElementById('autoupdate_checkbox_label').innerHTML = 'Auto-Update?';
		updateInterval=null;
		//console.log(updateInterval);
		if(updateInterval==null){console.log("updateInterval cleared");}
	}
}
setTimeout(function(){update()}, 1500);
