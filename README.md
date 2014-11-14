Cordova Tapjoy Plugin
=====================

## Basic Usage

	// Call requestTapjoyConnect first thing
	Tapjoy.requestTapjoyConnect(MY_APP_ID, MY_SECRET_KEY, success, error);
	Tapjoy.enableLogging();

	// The TJEventDelegate class wraps a set of callbacks you can override:
	//   eventSuccess: function(){},
	//   eventFailed: function(){},
	//   didRequestAction: function(){},
	//   contentDidAppear: function(){},
	//   contentDidDisappear: function(){}
	var _tjDelegate = new TJEventDelegate(function () {

		var current_points = NaN;
		function diff(newVal, oldVal) {
			if (isNaN(newVal) || isNaN(oldVal)) return 0;
			return newVal - oldVal;
		}
		// Delegate callbacks
		return {
			eventSuccess: function () {
				console.log('eventSuccess');
				Tapjoy.getTapPoints(function (data) {
					current_points = data.points;
				});
			},
			eventFailed: function () {
				Logger.log('Tapjoy event failed');
				current_points = NaN;
			},
			contentDidDisappear: function () {
				Tapjoy.getTapPoints( function (data) {
					console.log("Total Points: " + data.points);
					console.log("Earned Points: " + diff(data.points, current_points));
					current_points = NaN;
				});
			}
		}
	});

	// TJEvent wraps the entire event lifecycle
	var _tjEvent = new TJEvent(MY_EVENT_NAME, MY_EVENT_VALUE, _tjDelegate);

	// Prepare the event
	_tjEvent.send();

	// Show the event
	_tjEvent.show();
