cordova.define("org.apache.cordova.plugin.TapjoyPlugin.TJEventDelegate", function(require, exports, module) { /*
 *
 * Copyright (C) 2011-2012 by Tapjoy Inc.
 *
 * This file is part of the Tapjoy SDK.
 *
 * By using the Tapjoy SDK in your software, you agree to the
 * terms of the Tapjoy SDK License Agreement.  The Tapjoy SDK
 * is bound by the Tapjoy SDK License Agreement, found here:
 *
 *   https://www.tapjoy.com/sdk/license
 */

/**
 * Creates a new instance of TJEventDelegate
 * @constructor
 *
 * @param eventSuccessFunction          Function to be called when the event is sent successfully.
 * @param eventFailedFunction           Function to be called when an error occurs.
 * @param contentWillAppearFunction     Function to be called when event content will come into view.
 * @param contentDidAppearFunction      Function to be called when event content is in view.
 * @param contentWillDisappearFunction  Function to be called when event content will be removed.
 * @param contentDidDisappearFunction   Function to be called when event content is removed from view.
 * @param didRequestActionFunction      Function to be called when an action was successfully requested.
 */
var TJEventDelegate = function(eventSuccessFunction, eventFailedFunction, contentWillAppearFunction, contentDidAppearFunction, contentWillDisappearFunction, contentDidDisappearFunction, didRequestActionFunction) {
    this.eventSuccessFunction = eventSuccessFunction;
    this.eventFailedFunction = eventFailedFunction;
    this.contentWillAppearFunction = contentWillAppearFunction;
    this.contentDidAppearFunction = contentDidAppearFunction;
    this.contentWillDisappearFunction = contentWillDisappearFunction;
    this.contentDidDisappearFunction = contentDidDisappearFunction;
    this.didRequestActionFunction = didRequestActionFunction;
};

/**
 * Called when the event is sent successfully
 *
 * @param tjEvent       The TJEvent that was sent
 * @param contentIsAvailable  true if content is available, otherwise false
 */
TJEventDelegate.prototype.sendEventSucceeded = function(tjEvent, contentIsAvailable) {
    this.eventSuccessFunction(tjEvent, contentIsAvailable);
};

/**
 * Called when an error occurs while sending the event
 *
 * @param tjEvent       The TJEvent that was sent
 * @param errorMsg      The error that occurred
 */
TJEventDelegate.prototype.sendEventFailed = function(tjEvent, errorMsg) {
    this.eventFailedFunction(tjEvent, errorMsg);
};

/**
 * Called when content has been shown
 *
 * @param tjEvent       The TJEvent that was sent
 */
TJEventDelegate.prototype.contentDidAppear = function(tjEvent) {
    this.contentDidAppearFunction(tjEvent);
};

/**
 * Called when content has been dismissed
 *
 * @param tjEvent       The TJEvent that was sent
 */
TJEventDelegate.prototype.contentDidDisappear = function(tjEvent) {
    this.contentDidDisappearFunction(tjEvent);
};

/**
 * Called when an action is requested of your app
 *
 * @param tjEvent         The TJEvent that was sent
 * @param tjEventRequest  The TJEventRequest object describing the request
 */
TJEventDelegate.prototype.didRequestAction = function(tjEvent, tjEventRequest) {
    this.didRequestActionFunction(tjEvent, tjEventRequest);
};

module.exports = TJEventDelegate;

});
