import Toybox.Activity;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class RaceTargetPaceView extends WatchUi.DataField {
    // TODO: Create a flexible input for this information
    var _dictPaces = {1=>"8:00", 2=>"7:45", 3=>"7:30", 4=>"7:15", 5=>"7:00", 6=>"6:45", 7=>"6:30"};
    var _currentMile = 1;
    var _targetPace = "--";
    var _currentPace = "--";

    // Set the label of the data field here.
    function initialize() {
        DataField.initialize();
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        var distance = info.elapsedDistance;
        // var distance = 1609.34 * 2.5; // For testing, simulate 2.5 miles completed

        if (distance == null) {
            _targetPace = "--";
            _currentPace = "--";
            return;
        }

        // Convert distance to miles
        var milesCompleted = distance / 1609.34;

        // Determine the current mile
        _currentMile = Math.floor(milesCompleted).toNumber() + 1;

        // Get target pace for the current mile
        if (_dictPaces.hasKey(_currentMile)) {
            _targetPace = _dictPaces[_currentMile];
        } else {
            _targetPace = "--"; // Default pace if beyond defined paces
        }

        // Get current pace from activity info
        // currentSpeed is in meters per second, convert to pace (min/mile)
        var currentSpeed = info.currentSpeed;

        if (currentSpeed != null && currentSpeed > 0) {
            // Convert m/s to min/mile
            var paceSeconds = 1609.34 / currentSpeed;
            var paceMinutes = Math.floor(paceSeconds / 60).toNumber();
            var remainderSeconds = paceSeconds - (paceMinutes * 60);
            var paceRemainingSeconds = remainderSeconds.toNumber();

            _currentPace = paceMinutes.format("%d") + ":" + paceRemainingSeconds.format("%02d");
        } else {
            _currentPace = "8:00";//"--";
        }

        return;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // Set background color
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        // Draw label at the top
        dc.drawText(width / 2, 15, Graphics.FONT_MEDIUM, "Mile " + _currentMile, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw target pace in the center, large
        dc.drawText(width / 2, height / 2 - 65, Graphics.FONT_SYSTEM_NUMBER_HOT, _targetPace, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(width / 2, height / 2 - 10, Graphics.FONT_XTINY, "Target", Graphics.TEXT_JUSTIFY_CENTER);

        // Set the line color
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);

        // Draw a horizontal line across the middle
        // Example: From (0, screenHeight / 2) to (screenWidth, screenHeight / 2)
        dc.drawLine(0, height / 1.68, width, height / 1.68);


        // Draw current pace below
        dc.drawText(width / 2, height / 2 + 30, Graphics.FONT_SYSTEM_NUMBER_HOT, _currentPace, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(width / 2, height / 2 + 85, Graphics.FONT_XTINY, "Current", Graphics.TEXT_JUSTIFY_CENTER);
    }

}