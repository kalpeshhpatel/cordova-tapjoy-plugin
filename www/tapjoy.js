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

 var cordova = require('cordova'),
     argscheck = require('cordova/argscheck'),
     utils = require('cordova/utils'),
     exec = require('cordova/exec');

var Tapjoy = {

    serviceName: "TapjoyPlugin",
    eventDict: {},

    TJC_DISPLAY_AD_SIZE_320X50: "320x50",
    TJC_DISPLAY_AD_SIZE_640X100: "640x100",
    TJC_DISPLAY_AD_SIZE_768X90: "768x90",

    // iOS settings for collection of MAC address. Use this with the TJC_OPTION_COLLECT_MAC_ADDRESS option.
    MacAddressOptionOn: "0",                   // Enables collection of MAC address.
    MacAddressOptionOffWithVersionCheck: "1",  // Disables collection of MAC address for iOS versions 6.0 and above.
    MacAddressOptionOff: "2",                  // Completely disables collection of MAC address. THIS WILL EFFECTIVELY DISABLE THE SDK FOR IOS VERSIONS BELOW 6.0!
};

/**
 * Initialize Tapjoy Connect
 *
 * @param appID				The Tapjoy App ID.
 * @param secretKey			The Tapjoy Secret Key.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.requestTapjoyConnect = function(appID, secretKey, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "requestTapjoyConnect",
        [appID, secretKey]);
};

/**
 * Initialize Tapjoy Connect with flags
 *
 * @param appID				The Tapjoy App ID.
 * @param secretKey			The Tapjoy Secret Key.
 * @param flags				Tapjoy Connect flags.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.requestTapjoyConnectWithFlags = function(appID, secretKey, flags, successCallback, failureCallback) {
    // Populate the hashtable.
    for (var name in flags) {
        cordova.exec(
            null,
            null,
            Tapjoy.serviceName,
            "setFlagKeyValue",
            [name, flags[name]]);
    }

    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "requestTapjoyConnect",
        [appID, secretKey]);
};

/**
 * Sets a userID for this device/account.  This can only be used with non-managed currency and must be called before
 * showing the Marketplace, Display ads, Featured ad, etc.
 *
 * @param userID			The ID you wish to use for this user/account.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.setUserID = function(userID, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "setUserID",
        [userID]);
};

/**
 * Enable Tapjoy SDK logging to the console
 *
 * @param enable            True or false
 */
Tapjoy.enableLogging = function(enable) {
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "enableLogging",
        [enable]);
};

/**
 * Use for advertising your app if it is a Paid App.  Call after requestTapjoyConnect.
 *
 * @param paidAppActionID	The Tapjoy Paid App Action ID for this offer.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.enablePaidAppWithActionID = function(paidAppActionID, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "enablePaidAppWithActionID",
        [paidAppActionID]);
};


/**
 * Pay Per Action.
 *
 * @param actionID			PPA ID.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.actionComplete = function(actionID, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "actionComplete",
        [actionID]);
};


/**
 * Show Marketplace
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.showOffers = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "showOffers",
        []);
};


/**
 * Show Marketplace with a currency ID
 *
 * @param currencyID		The Tapjoy currency ID
 * @param selector			Whether to show the currency selector or not
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.showOffersWithCurrencyID = function(currencyID, selector, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "showOffersWithCurrencyID",
        [currencyID, selector]);
};


/**
 * Get Tap Points
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.getTapPoints = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "getTapPoints",
        []);
};


/**
 * Spend Tap Points
 *
 * @param amount			Amount to spend.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.spendTapPoints = function(amount, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "spendTapPoints",
        [amount]);
};


/**
 * Award Tap Points
 *
 * @param amount			Amount to award.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.awardTapPoints = function(amount, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "awardTapPoints",
        [amount]);
};


/**
 * @deprecated Deprecated since version 10.0.0
 * Get a Full Screen Ad.
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.getFullScreenAd = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "getFullScreenAd",
        []);
};


/**
 * @deprecated Deprecated since version 10.0.0
 * Get Full Screen Ad with a currency ID
 *
 * @param currencyID		The Tapjoy currencyID
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.getFullScreenAdWithCurrencyID = function(currencyID, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "getFullScreenAdWithCurrencyID",
        [currencyID]);
};

/**
 * @deprecated Deprecated since version 10.0.0
 * Shows the full screen ad.  Call after getting a success from getFullScreenAd(...)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.showFullScreenAd = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "showFullScreenAd",
        []);
};


/**
 * @deprecated Deprecated since version 10.0.0
 * Sets the maximum number of videos to cache on the device.
 *
 * @param count				Number of videos to cache on the device.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.setVideoCacheCount = function(count, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "setVideoCacheCount",
        [count]);
};


/**
 * @deprecated Deprecated since version 10.0.0
 * Start caching videos (if allowed)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.cacheVideos = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "cacheVideos",
        []);
};

/**
 * @deprecated Deprecated since version 10.0.0
 * Sets the video ad delegate
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.setVideoAdDelegate = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "setVideoAdDelegate",
        []);
};

/**
 * Sends shutdown event.
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.sendShutDownEvent = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        'sendShutDownEvent',
        []);
};


/**
 * Sends IAP event.
 *
 * @param name				Item name.
 * @param price				Item price (real life currency).
 * @param quantity			Quantity of the item purchased.
 * @param currencyCode		Real life currency code purchase was made in.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.sendIAPEvent = function(name, price, quantity, currencyCode, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "sendIAPEvent",
        [name, price, quantity, currencyCode]);
};


/**
 * Get Display Ad
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.getDisplayAd = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "getDisplayAd",
        []);
};

/**
 * Shows the Display Ad. Call after getting a success from getDisplayAd(...)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.showDisplayAd = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "showDisplayAd",
        []);
};

/**
 * Hides the Display Ad
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.hideDisplayAd = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "hideDisplayAd",
        []);
};

/**
 * Enable auto-refresh of the display ad
 *
 * @param enable            Boolean to enable or disable auto-refresh
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.enableDisplayAdAutoRefresh = function(enable, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "enableDisplayAdAutoRefresh",
        [enable]);
};

/**
 * Moves the location of the display ad
 *
 * @param x                 The x coordinate
 * @param y                 The y coordinate
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.moveDisplayAd = function(x, y, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "moveDisplayAd",
        [x, y]);
};

/**
 * Sets the Display ad size. Size value must be one of Tapjoy.TJC_DISPLAY_AD_SIZE_320X50, Tapjoy.TJC_DISPLAY_AD_SIZE_640X100, or Tapjoy.TJC_DISPLAY_AD_SIZE_768X90
 *
 * @param size              Display ad size
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.setDisplayAdSize = function(size, successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "setDisplayAdSize",
        [size]);
};

/**
 * Remove all Tapjoy content from view
 *
 * @param successCallback   The success callback
 * @param failureCallback   The error callback (unused)
 */
Tapjoy.dismissContent = function(successCallback, failureCallback) {
    return cordova.exec(
        successCallback,
        failureCallback,
        Tapjoy.serviceName,
        "dismissContent",
        []);
};


////////////////////////////////
// Tapjoy Events Framework
/////////////////////////////

Tapjoy.sendEventCompleteWithContent = function(guid) {
    if (guid in Tapjoy.eventDict){
        Tapjoy.eventDict[guid].triggerSendEventSucceeded(true);
    }
};

Tapjoy.sendEventComplete = function(guid) {
    if (guid in Tapjoy.eventDict){
        Tapjoy.eventDict[guid].triggerSendEventSucceeded(false);
    }
};

Tapjoy.sendEventFail = function(guid, errorMsg) {
    if (guid in Tapjoy.eventDict){
        Tapjoy.eventDict[guid].triggerSendEventFailed(errorMsg);
    }
};

Tapjoy.eventContentDidAppear = function(guid) {
    if (guid in Tapjoy.eventDict){
        Tapjoy.eventDict[guid].triggerContentDidAppear();
    }
};

Tapjoy.eventContentDidDisappear = function(guid) {
    if (guid in Tapjoy.eventDict){
        Tapjoy.eventDict[guid].triggerContentDidDisappear();
    }
};

Tapjoy.eventDidRequestAction = function(guid, type, identifier, quantity) {
    if (guid in Tapjoy.eventDict){
        Tapjoy.eventDict[guid].triggerDidRequestAction(type, identifier, quantity);
    }
};

Tapjoy.sendEvent = function(guid) {
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "sendEvent",
        [guid]);
};
Tapjoy.showEvent = function(guid) {
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "showEvent",
        [guid]);
};

Tapjoy.enableEventAutoPresent = function(guid, autoPresent) {
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "enableEventAutoPresent",
        [guid, autoPresent]);
};

Tapjoy.createEvent = function(tjEvent, eventName, eventParameter) {
    var guid = generateGuid();

    while (guid in Tapjoy.eventDict){
        guid = generateGuid();
    }

    tjEvent.guid = guid;

    this.eventDict[guid] = tjEvent;

    // Platform Plugin createEvent
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "createEvent",
        [guid, eventName, eventParameter]);
};

Tapjoy.eventRequestCompleted = function(guid) {
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "eventRequestCompleted",
        [guid]);
};

Tapjoy.eventRequestCancelled = function(guid) {
    var responseFunction = function(r){

    }
    return cordova.exec(
        responseFunction,
        responseFunction,
        Tapjoy.serviceName,
        "eventRequestCancelled",
        [guid]);
};


/////////////////////////////
// Utilities
/////////////////////////////

function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
};

function generateGuid() {
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
        s4() + '-' + s4() + s4() + s4();
}


/////////////////////////////
// Exports
/////////////////////////////

/*if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.Tapjoy) {
    window.plugins.Tapjoy = Tapjoy;
}*/

if (module.exports) {
    module.exports = Tapjoy;
}
