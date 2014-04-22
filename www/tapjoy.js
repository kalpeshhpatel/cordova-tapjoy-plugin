// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license


var Tapjoy = function() {
}

Tapjoy = function() {
	Tapjoy.serviceName = "TapjoyPlugin";
    Tapjoy.eventDict = {};
};

Tapjoy.prototype.TJC_DISPLAY_AD_SIZE_320X50 = "320x50";
Tapjoy.prototype.TJC_DISPLAY_AD_SIZE_640X100 = "640x100";
Tapjoy.prototype.TJC_DISPLAY_AD_SIZE_768X90	= "768x90";


// iOS settings for collection of MAC address. Use this with the TJC_OPTION_COLLECT_MAC_ADDRESS option.
Tapjoy.prototype.MacAddressOptionOn = "0";                      // Enables collection of MAC address.
Tapjoy.prototype.MacAddressOptionOffWithVersionCheck = "1";     //Disables collection of MAC address for iOS versions 6.0 and above.
Tapjoy.prototype.MacAddressOptionOff = "2";                     //Completely disables collection of MAC address. THIS WILL EFFECTIVELY DISABLE THE SDK FOR IOS VERSIONS BELOW 6.0!

/**
 * Initialize Tapjoy Connect
 *
 * @param appID				The Tapjoy App ID.
 * @param secretKey			The Tapjoy Secret Key.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.requestTapjoyConnect = function(appID, secretKey, successCallback, failureCallback) {
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
Tapjoy.prototype.requestTapjoyConnectWithFlags = function(appID, secretKey, flags, successCallback, failureCallback) {
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
Tapjoy.prototype.setUserID = function(userID, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "setUserID",
                        [userID]);
};

/**
 * Use for advertising your app if it is a Paid App.  Call after requestTapjoyConnect.
 * 
 * @param paidAppActionID	The Tapjoy Paid App Action ID for this offer.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.enablePaidAppWithActionID = function(paidAppActionID, successCallback, failureCallback) {
	return cordova.exec(
				successCallback,			 
				failureCallback,						
				Tapjoy.serviceName,				
				'enablePaidAppWithActionID',								
				[paidAppActionID]);
};


/**
 * Pay Per Action.
 *
 * @param actionID			PPA ID.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.actionComplete = function(actionID, successCallback, failureCallback) {
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
Tapjoy.prototype.showOffers = function(successCallback, failureCallback) {
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
Tapjoy.prototype.showOffersWithCurrencyID = function(currencyID, selector, successCallback, failureCallback) {
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
Tapjoy.prototype.getTapPoints = function(successCallback, failureCallback) {
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
Tapjoy.prototype.spendTapPoints = function(amount, successCallback, failureCallback) {
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
Tapjoy.prototype.awardTapPoints = function(amount, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "awardTapPoints",
                        [amount]);
};


/**
 * @deprecated Use getFullScreenAd instead.
 * Get Featured Ad
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.getFeaturedApp = function(successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "getFeaturedApp",
                        []);
};


/**
 * @deprecated Use getFullScreenAdWithCurrencyID instead.
 * Get Featured Ad with a currency ID
 *
 * @param currencyID		The Tapjoy currencyID
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.getFeaturedAppWithCurrencyID = function(currencyID, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "getFeaturedAppWithCurrencyID",
                        [currencyID]);
};


/**
 * Sets the maximum number of times to display the same (unique) featured ad
 *
 * @param count				Maximum number of times to show the same featured ad unit
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.setFeaturedAppDisplayCount = function(count, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "setFeaturedAppDisplayCount",
                        [count]);
};


/**
 * @deprecated Use showFullScreenAd instead.
 * Shows the featured ad.  Call after getting a success from getFeaturedApp(...)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.showFeaturedAppFullScreenAd = function(successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "showFeaturedAppFullScreenAd",
                        []);
};

/**
 * Get a Full Screen Ad.
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.getFullScreenAd = function(successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "getFullScreenAd",
                        []);
};


/**
 * Get Full Screen Ad with a currency ID
 *
 * @param currencyID		The Tapjoy currencyID
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.getFullScreenAdWithCurrencyID = function(currencyID, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "getFullScreenAdWithCurrencyID",
                        [currencyID]);
};

/**
 * Shows the full screen ad.  Call after getting a success from getFullScreenAd(...)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.showFullScreenAd = function(successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "showFullScreenAd",
                        []);
};

/**
 * @deprecated getDailyRewardAd is deprecated
 * Get a Daily Reward.
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.getDailyRewardAd = function(successCallback, failureCallback) {
	return cordova.exec(
                         successCallback,
                         failureCallback,
                         Tapjoy.serviceName,
                         "getDailyRewardAd",
                         []);
};


/**
 * @deprecated getDailyRewardAdWithCurrencyID is deprecated
 * Get Daily Reward with a currency ID
 *
 * @param currencyID		The Tapjoy currencyID
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.getDailyRewardAdWithCurrencyID = function(currencyID, successCallback, failureCallback) {
	return cordova.exec(
                         successCallback,
                         failureCallback,
                         Tapjoy.serviceName,
                         "getDailyRewardAdWithCurrencyID",
                         [currencyID]);
};


/**
 * @deprecated showDailyRewardAd is deprecated
 * Shows the daily reward.  Call after getting a success from getDailyReward(...)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.showDailyRewardAd = function(successCallback, failureCallback) {
	return cordova.exec(
                         successCallback,			 
                         failureCallback,						
                         Tapjoy.serviceName,				
                         "showDailyRewardAd",								
                         []);
};

/**
 * Initializes video ads.  Call to have video ads available in the Marketplace.
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.initVideoAd = function(successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "initVideoAd",
                        []);
};


/**
 * Sets the maximum number of videos to cache on the device.
 *
 * @param count				Number of videos to cache on the device.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.setVideoCacheCount = function(count, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,			 
                        failureCallback,						
                        Tapjoy.serviceName,
                        "setVideoCacheCount",								
                        [count]);
};

/**
 * Sets whether to enable caching for videos.  By default this is enabled.
 * 
 * @param enable			TRUE to enable video caching, FALSE to disable video caching.
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.enableVideoCache = function(enable, successCallback, failureCallback) {
	return cordova.exec(
				successCallback,			 
				failureCallback,						
				Tapjoy.serviceName,				
				'enableVideoCache',								
				[enable]);
};

/**
 * Start caching videos (if allowed)
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.cacheVideos = function(successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "cacheVideos",
                        []);
};

/**
 * Sets the video notifier
 * 
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.setVideoNotifier = function(successCallback, failureCallback) {
	return cordova.exec(
			successCallback,
			failureCallback,
			Tapjoy.serviceName,
			'setVideoNotifier',
			[]);
};

/**
 * Sets the video notifier
 *
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Tapjoy.prototype.setVideoAdDelegate = function(successCallback, failureCallback) {
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
Tapjoy.prototype.sendShutDownEvent = function(successCallback, failureCallback) {
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
Tapjoy.prototype.sendIAPEvent = function(name, price, quantity, currencyCode, successCallback, failureCallback) {
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
Tapjoy.prototype.getDisplayAd = function(successCallback, failureCallback) {
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
Tapjoy.prototype.showDisplayAd = function(successCallback, failureCallback) {
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
Tapjoy.prototype.hideDisplayAd = function(successCallback, failureCallback) {
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
Tapjoy.prototype.enableDisplayAdAutoRefresh = function(enable, successCallback, failureCallback) {
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
Tapjoy.prototype.moveDisplayAd = function(x, y, successCallback, failureCallback) {
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
Tapjoy.prototype.setDisplayAdSize= function(size, successCallback, failureCallback) {
	return cordova.exec(
                        successCallback,
                        failureCallback,
                        Tapjoy.serviceName,
                        "setDisplayAdSize",
                        [size]);
};

///// Tapjoy Events Framework implementation

Tapjoy.sendEventCompleteWithContent = function(guid) {
	if (guid in Tapjoy.eventDict){
		Tapjoy.eventDict[guid].triggerSendEventSucceeded(true);
	}
    
};

Tapjoy.sendEventComplete = function(guid) {
	if(guid in Tapjoy.eventDict){
		Tapjoy.eventDict[guid].triggerSendEventSucceeded(false);
	}
};

Tapjoy.sendEventFail = function(guid, errorMsg) {
	if(guid in Tapjoy.eventDict){
		Tapjoy.eventDict[guid].triggerSendEventFailed(errorMsg);
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

Tapjoy.createEvent = function(tjEvent, eventName, eventParameter) {
	var guid = generateGuid();

	while(guid in Tapjoy.eventDict){
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


//// TJEvent defintion
/**
 * Creates a new instance of TJEvent
 *
 * @param eventName				The name of the event
 * @param eventParameter		String that specifies the additional event value
 * @param eventCallback			An instance of TJEventCallback
 */
var TJEvent = function(eventName, eventParameter, eventCallback) {
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

TJEvent.prototype.triggerSendEventSucceeded = function(contentIsAvailable){
	this.eventCallback.sendEventSucceeded(this, contentIsAvailable);
	
};
TJEvent.prototype.triggerSendEventFailed= function(errorMsg){
	this.eventCallback.sendEventFailed(this, errorMsg);
};

/**
 * Class that handles the responses received upon sending a TJEvent
 *
 * @param eventSuccessFunction 			A function that will be called when the event is sent successfully.
 * @param eventFailedFunction 			A function that will be called when an error occurs while sending the event
 */
var TJEventCallback = function(eventSuccessFunction, eventFailedFunction) {
	this.eventSuccessFunction = eventSuccessFunction;
	this.eventFailedFunction = eventFailedFunction;
};

/**
 * Called when the event is sent successfully
 *
 * @param tjEvent				The TJEvent that was sent
 * @param contentIsAvailable	true if content is available, otherwise false
 */
TJEventCallback.prototype.sendEventSucceeded = function(tjEvent, contentIsAvailable) {
	this.eventSuccessFunction(tjEvent, contentIsAvailable);
};

/**
 * Called when an error occurs while sending the event
 *
 * @param tjEvent				The TJEvent that was sent
 * @param errorMsg				The error that occurred
 */
TJEventCallback.prototype.sendEventFailed = function(tjEvent, errorMsg) {
	this.eventFailedFunction(tjEvent, errorMsg);
};


// Utility functions

function s4() {
	return Math.floor((1 + Math.random()) * 0x10000)
    .toString(16)
    .substring(1);
};

function generateGuid() {
	return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    s4() + '-' + s4() + s4() + s4();
}

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.Tapjoy) {
    window.plugins.Tapjoy = new Tapjoy();
}

if (module.exports) {
    module.exports = new Tapjoy();
}
