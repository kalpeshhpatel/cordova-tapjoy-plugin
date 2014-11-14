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

var Tapjoy = require('./tapjoy'),
    TJEventRequest = require('./TJEventRequest');

/**
 * Creates a new instance of TJEvent
 * @constructor
 *
 * @param eventName           The name of the event
 * @param eventParameter      An optional event 'value'
 * @param eventDelegate       An instance of TJEventDelegate
 */
var TJEvent = function(eventName, eventParameter, eventDelegate) {
    this.eventName = eventName;
    this.eventParameter = eventParameter;
    this.eventCallback = eventCallback;

    Tapjoy.createEvent(this, eventName, eventParameter);
};

/**
 * Sends the event to the server
 */
TJEvent.prototype.send = function(){
    Tapjoy.sendEvent(this.guid);
};

/**
 * Shows the content that was received from the server after sending this event
 */
TJEvent.prototype.show = function(){
    Tapjoy.showEvent(this.guid);
};

TJEvent.prototype.enableAutoPresent = function(autoPresent) {
    Tapjoy.enableEventAutoPresent(this.guid, autoPresent);
};

TJEvent.prototype.triggerSendEventSucceeded = function(contentIsAvailable){
    this.eventCallback.sendEventSucceeded(this, contentIsAvailable);
};

TJEvent.prototype.triggerSendEventFailed = function(errorMsg){
    this.eventCallback.sendEventFailed(this, errorMsg);
};

TJEvent.prototype.triggerContentDidAppear = function(){
    this.eventCallback.contentDidAppear(this);
};

TJEvent.prototype.triggerContentDidDisappear = function(){
    this.eventCallback.contentDidDisappear(this);
};

TJEvent.prototype.triggerDidRequestAction = function(type, identifier, quantity){
    var eventRequest = new TJEventRequest(this.guid, type, identifier, quantity);

    this.eventCallback.didRequestAction(this, eventRequest);
};

module.exports = TJEvent;
