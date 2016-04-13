/*
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
 * @param eventSuccess           Function called when the event is sent successfully.
 * @param eventFailed            Function called when an error occurs.
 * @param contentDidAppear       Function called when event content is in view.
 * @param contentDidDisappear    Function called when event content is removed from view.
 * @param didRequestAction       Function called when an action was successfully requested.
 */
var TJEventDelegate = function(callbacks) {
    this.eventSuccessFn = callbacks.eventSuccess;
    this.eventFailedFn = callbacks.eventFailed;
    this.contentDidAppearFn = callbacks.contentDidAppear;
    this.contentDidDisappearFn = callbacks.contentDidDisappear;
    this.didRequestActionFn = callbacks.didRequestAction;
};

/**
 * Called when the event is sent successfully
 *
 * @param tjEvent       The TJEvent that was sent
 * @param contentIsAvailable  true if content is available, otherwise false
 */
TJEventDelegate.prototype.sendEventSucceeded = function(tjEvent, contentIsAvailable) {
    if (this.eventSuccessFn) this.eventSuccessFn(tjEvent, contentIsAvailable);
};

/**
 * Called when an error occurs while sending the event
 *
 * @param tjEvent       The TJEvent that was sent
 * @param errorMsg      The error that occurred
 */
TJEventDelegate.prototype.sendEventFailed = function(tjEvent, errorMsg) {
    if (this.eventFailedFn) this.eventFailedFn(tjEvent, errorMsg);
};

/**
 * Called when content has been shown
 *
 * @param tjEvent       The TJEvent that was sent
 */
TJEventDelegate.prototype.contentDidAppear = function(tjEvent) {
    if (this.contentDidAppearFn) this.contentDidAppearFn(tjEvent);
};

/**
 * Called when content has been dismissed
 *
 * @param tjEvent       The TJEvent that was sent
 */
TJEventDelegate.prototype.contentDidDisappear = function(tjEvent) {
    if (this.contentDidDisappearFn) this.contentDidDisappearFn(tjEvent);
};

/**
 * Called when an action is requested of your app
 *
 * @param tjEvent         The TJEvent that was sent
 * @param tjEventRequest  The TJEventRequest object describing the request
 */
TJEventDelegate.prototype.didRequestAction = function(tjEvent, tjEventRequest) {
    if (this.didRequestActionFn) this.didRequestActionFn(tjEvent, tjEventRequest);
};

module.exports = TJEventDelegate;
