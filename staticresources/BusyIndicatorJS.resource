    // Use this to show a busy indicator with a modal background before making a
    // call to a javascript function. Here is a sample:
    //  <apex:commandButton onClick="return showBusyThenCallScript('goToStep2');" value="Next" />
    //  <apex:actionFunction name="goToStep2" action="{!step2}" />
    // 
    // Returning false to the command button disables the default button click functionality
    // which on some browsers submits the current page.
    //  
    function showBusyThenCallScript(fn)
    {
        var busyIndicator = document.getElementById('busyIndicator');
        busyIndicator.style.display = 'block';
        window[fn]();
        return false;
    }

    // Use this function to hide the busy indicator.  This will be needed if you are staying
    // on the same page after the server call returns.  If you are redirecting to another
    // page this is not needed.
    //
    function hideBusy()
    {
        var busyIndicator = document.getElementById('busyIndicator');
	busyIndicator.style.display = 'none';
    }
