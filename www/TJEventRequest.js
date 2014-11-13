cordova.define("org.apache.cordova.plugin.TapjoyPlugin.TJEventRequest", function(require, exports, module) { /*
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
 * Creates a new instance of TJEventRequest
 * @constructor
 *
 * @param guid          The event guid
 * @param type          The type of request
 * @param identifier    Unique request identifier
 * @param quantity      Number of __?__
 */
var TJEventRequest = function(guid, type, identifier, quantity) {
    this.guid = guid;
    this.type = type;
    this.identifier = identifier;
    this.quantity = quantity;
};

TJEventRequest.TYPE_IN_APP_PURHCASE = 1;
TJEventRequest.TYPE_VIRTUAL_GOOD = 2;
TJEventRequest.TYPE_CURRENCY = 3;
TJEventRequest.TYPE_NAVIGATION = 4;

TJEventRequest.prototype.eventRequestCompleted = function() {
    Tapjoy.eventRequestCompleted(this.guid);
 };

TJEventRequest.prototype.eventRequestCancelled = function() {
    Tapjoy.eventRequestCancelled(this.guid);
}

module.exports = TJEventRequest;

});
