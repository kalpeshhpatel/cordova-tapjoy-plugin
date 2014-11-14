// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license
//

#import "TapjoyPlugin.h"
#import "TapjoyEventPlugin.h"


@implementation TapjoyPlugin

#pragma mark - Public API

- (void)requestTapjoyConnect:(CDVInvokedUrlCommand *)command
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CONNECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_OFFERS_RESPONSE_NOTIFICATION_ERROR object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:)
                                                 name:TJC_CONNECT_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:)
                                                 name:TJC_CONNECT_FAILED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpdatedPoints:)
                                                 name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spendUpdatedPoints:)
                                                 name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(awardUpdatedPoints:)
                                                 name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION
                                               object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFullScreenAdResponse:)
                                                 name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION
                                               object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpdatedPointsError:)
                                                 name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spendUpdatedPointsError:)
                                                 name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(awardUpdatedPointsError:)
                                                 name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR
                                               object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFullScreenAdError:)
                                                 name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION_ERROR
                                               object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOffersError:)
                                                 name:TJC_OFFERS_RESPONSE_NOTIFICATION_ERROR
                                               object:nil];

    NSLog(@"Name: %@, ID: %@", command.methodName, command.callbackId);
    self.connectCallbackID = command.callbackId;

    NSString *appID = [command.arguments objectAtIndex:0];
    NSString *secretKey = [command.arguments objectAtIndex:1];

    displayAdSize = TJC_DISPLAY_AD_SIZE_320X50;
    displayAdFrame = CGRectMake(0, 0, 320, 50);

    [[Tapjoy sharedTapjoyConnect] setPlugin:@"phonegap"];
    NSLog(@"Conncting via Tapjoy SDK %@", [Tapjoy getVersion]); // <-- getVersion not working

    [Tapjoy setVideoAdDelegate:self];

    [self.commandDelegate runInBackground:^{
        if([self hasKeyFlags]){
            [Tapjoy requestTapjoyConnect:appID secretKey:secretKey options:self.keyFlagValueDict];
        } else {
            [Tapjoy requestTapjoyConnect:appID secretKey:secretKey];
        }
    }];
}


- (void)setFlagKeyValue:(CDVInvokedUrlCommand *)command
{
    NSString *key = [command.arguments objectAtIndex:0];
    id value = [command.arguments objectAtIndex:1];

    [self.keyFlagValueDict setObject:value forKey:key];
    [self sendPluginOK:command];
}

/**
 * Assigns a user ID for this user/device. This is used to identify the user in your application.
 *
 * @param userID The user ID you wish to assign to this device.
 */
- (void)setUserID:(CDVInvokedUrlCommand *)command
{
    NSString *userID = [command.arguments objectAtIndex:0];
    [Tapjoy setUserID:userID];

    // TODO: Report server success/error
}

#pragma mark -

/**
 * Toggle logging to the console.
 *
 * @param enable YES to enable logging, NO otherwise.
 */
- (void)enableLogging:(CDVInvokedUrlCommand *)command
{
    BOOL enable = [[command.arguments objectAtIndex:0] boolValue];
    [Tapjoy enableLogging:enable];
}

/**
 * Informs the Tapjoy server that the specified Pay-Per-Action was completed.
 * Should be called whenever a user completes an in-game action.
 *
 * @param actionID The action ID of the completed action.
 */
- (void)actionComplete:(CDVInvokedUrlCommand *)command
{
    NSString *actionID = [command.arguments objectAtIndex:0];
    [Tapjoy actionComplete:actionID];

    // TODO: Report server success/error
}

#pragma mark -

/**
 * Initiates the request to POST the IAP data.
 *
 * @param name The name of the In-App-Purchase (IAP) item that this event should track.
 * @param price The amount that the item was sold for.
 * @param quantity The number of items for this purchase.
 * @param currencyCode The currency code, such as USD.
 */
- (void)sendIAPEvent:(CDVInvokedUrlCommand *)command
{
    NSString *name = [command.arguments objectAtIndex:0];
    NSString *price = [command.arguments objectAtIndex:1];
    NSString *quantity = [command.arguments objectAtIndex:2];
    NSString *currencyCode = [command.arguments objectAtIndex:3];

    [Tapjoy sendIAPEvent:name price:[price floatValue] quantity:[quantity intValue] currencyCode:currencyCode];

    // TODO: Report server success/error
}

#pragma mark -

/**
 * Allocates and initializes a TJCOffersWebView.
 */
- (void)showOffers:(CDVInvokedUrlCommand *)command
{
    self.offersCallbackID = command.callbackId;

    [Tapjoy showOffersWithViewController:self.viewController];
}

/**
 * Allocates and initializes a TJCOffersWebView. This is only used when multiple currencies are enabled.
 *
 * @param currencyID The id of the currency to show in the offer wall.
 * @param isSelectorVisible Specifies whether to display the currency selector in the offer wall.
 */
- (void)showOffersWithCurrencyID:(CDVInvokedUrlCommand *)command
{
    self.offersCallbackID = command.callbackId;

    NSString *currencyID = [command.arguments objectAtIndex:0];
    BOOL selector = [[command.arguments objectAtIndex:1] boolValue];

    [Tapjoy showOffersWithCurrencyID:currencyID withCurrencySelector:selector];
}

#pragma mark -

/**
 * Requests for Tap Points (Virtual Currency) notify via TJC_TAP_POINTS_RESPONSE_NOTIFICATION notification.
 */
- (void)getTapPoints:(CDVInvokedUrlCommand *)command
{
    self.tapPointsCallbackID = command.callbackId;

    [Tapjoy getTapPoints];
}

/**
 * Updates the virtual currency for the user with the given spent amount of currency.
 *
 * If the spent amount exceeds the current amount of currency the user has, nothing will happen.
 * @param points The amount of currency to subtract from the current total amount of currency the user has.
 */
- (void)spendTapPoints:(CDVInvokedUrlCommand *)command
{
    self.spendTapPointsCallbackID = command.callbackId;

    NSString *amountStr = [command.arguments objectAtIndex:0];
    if ([self isInt:amountStr]){
        [Tapjoy spendTapPoints:[amountStr intValue]];
    } else {
        [self sendPluginError:command message:@"Points must be an integer"];
    }
}

/**
 * Updates the virtual currency for the user with the given awarded amount of currency.
 *
 * @param points The amount of currency to add to the current total amount of currency the user has.
 */
- (void)awardTapPoints:(CDVInvokedUrlCommand *)command
{
    self.awardTapPointsCallbackID = command.callbackId;

    NSString *amountStr = [command.arguments objectAtIndex:0];
    if ([self isInt:amountStr]){
        [Tapjoy awardTapPoints:[amountStr intValue]];
    } else {
        [self sendPluginError:command message:@"Points must be an integer"];
    }
}

/*
#pragma mark - Deprecated API Methods

- (void)getFullScreenAd:(CDVInvokedUrlCommand *)command
{
    self.fullScreenAdCallbackID = command.callbackId;

    [Tapjoy getFullScreenAd];
}

- (void)getFullScreenAdWithCurrencyID:(CDVInvokedUrlCommand *)command
{
    self.fullScreenAdCallbackID = command.callbackId;

    NSString *currencyID = [command.arguments objectAtIndex:0];
    [Tapjoy getFullScreenAdWithCurrencyID:currencyID];
}

- (void)showFullScreenAd:(CDVInvokedUrlCommand *)command
{
    [Tapjoy showFullScreenAd];
}

- (void)cacheVideos:(CDVInvokedUrlCommand *)command
{
    [Tapjoy cacheVideosWithDelegate:self];
}

- (void)setVideoCacheCount:(CDVInvokedUrlCommand *)command
{
    NSString *displayCountString = [command.arguments objectAtIndex:0];
    int displayCount = [displayCountString intValue];

    [Tapjoy setVideoCacheCount:displayCount];
}
*/

#pragma mark -

/**
 * What does this do...?
 */
- (void)getDisplayAd:(CDVInvokedUrlCommand *)command
{
    self.displayAdCallbackID = command.callbackId;

    [Tapjoy getDisplayAdWithDelegate:self];
}

/**
 * @param size Should be a string formatted HxW, like "320x50"
 */
- (void)setDisplayAdSize:(CDVInvokedUrlCommand *)command
{
    // TODO: Check value with a regex
    displayAdSize = [command.arguments objectAtIndex:0];
}

- (void)moveDisplayAd:(CDVInvokedUrlCommand *)command
{
    NSString *xString = [command.arguments objectAtIndex:0];
    NSString *yString = [command.arguments objectAtIndex:1];

    // Adjust frame
    if ([self isInt:xString] && [self isInt:yString]) {
        displayAdFrame.origin = CGPointMake([xString intValue], [yString intValue]);
    }
    // Move view
    [[Tapjoy getDisplayAdView] setFrame:displayAdFrame];
}

// TODO: Does this work?
- (void)showDisplayAd:(CDVInvokedUrlCommand *)command
{
    TJCAdView *adView = [Tapjoy getDisplayAdView];
    [adView setFrame:displayAdFrame];
    [self.viewController.view addSubview:adView];
}

// TODO: Does this work?
- (void)hideDisplayAd:(CDVInvokedUrlCommand *)command
{
    UIView *adView = [Tapjoy getDisplayAdView];
    [adView removeFromSuperview];
}

- (void)enableDisplayAdAutoRefresh:(CDVInvokedUrlCommand *)command
{
    BOOL enable = [[command.arguments objectAtIndex:0] boolValue];
    self.enableDisplayAdAutoRefresh = enable;
}

/**
 * Dismisses both offer wall and fullscreen ads.
 */
- (void)dismissContent:(CDVInvokedUrlCommand *)command
{
    [Tapjoy dismissContent];

    // TODO: This should also notify appropriate event delegate callbacks
    [self sendPluginOK:command];
}


#pragma mark - Event API

/**
 * Create an event and store it, along with its callback, by a front-end generated guid.
 */
- (void)createEvent:(CDVInvokedUrlCommand *)command
{
    NSString *guid = [command.arguments objectAtIndex:0];
    NSString *name = [command.arguments objectAtIndex:1];
    NSString *eventParam = [command.arguments objectAtIndex:2];

    // Save callbacks in dict to workaround weird release/crash issues
    TapjoyEventPlugin *tjevt = [TapjoyEventPlugin createEventWithGuid:guid plugin:self];
    [self.callbackDict setObject:tjevt forKey:guid];

    // Log the event
    NSLog(@"Create Event guid:%@, name:%@, eventParam:%@", guid, name, eventParam);

    TJEvent *evt = nil;
    if ([self isEmpty:eventParam]) {
        evt = [TJEvent eventWithName:name delegate:tjevt];
    } else {
        evt = [TJEvent eventWithName:name value:eventParam delegate:tjevt];
    }
    [self.eventsDict setObject:evt forKey:guid];

    [self sendPluginOK:command];
}


- (void)sendEvent:(CDVInvokedUrlCommand *)command
{
    NSString *guid = [command.arguments objectAtIndex:0];

    NSLog(@"Send Event with GUID: %@", guid);
    NSLog(@"Event: %@", [self.eventsDict objectForKey:guid]);

    [self.commandDelegate runInBackground:^{
        [[self.eventsDict objectForKey:guid] send];
    }];

    // TODO: Report server success/error
}

- (void)showEvent:(CDVInvokedUrlCommand *)command
{
    NSString *guid = [command.arguments objectAtIndex:0];

    // TODO: Modify to use a different view controller... not the root view
    UIViewController *viewCntrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[self.eventsDict objectForKey:guid] presentContentWithViewController:viewCntrl];

    [self sendPluginOK:command];
}


- (void)enableEventAutoPresent:(CDVInvokedUrlCommand *)command
{
    NSString *guid = [command.arguments objectAtIndex:0];
    id autoPresent = [command.arguments objectAtIndex:1];

    [[self.eventsDict objectForKey:guid] setPresentAutomatically:[autoPresent boolValue]];
}


- (void)eventRequestCompleted:(CDVInvokedUrlCommand *)command
{
    NSString *guid = [command.arguments objectAtIndex:0];
    TJEventRequest *request = [self.eventRequestDict objectForKey:guid];
    if (request)
    {
        NSLog(@"Sending TJEventRequest completed");
        [request completed];
    }

    // TODO: Report server success/error
}

- (void)eventRequestCancelled:(CDVInvokedUrlCommand *)command
{
    NSString *guid = [command.arguments objectAtIndex:0];
    TJEventRequest *request = [self.eventRequestDict objectForKey:guid];
    if (request)
    {
        NSLog(@"Sending TJEventRequest cancelled");
        [request cancelled];
    }

    // TODO: Report server success/error
}


#pragma mark -
#pragma mark - Connection Hooks

- (void)tjcConnectSuccess:(NSNotification *)notifyObj
{
    NSLog(@"Tapjoy connect Succeeded");

    NSString *stringToReturn = @"Connect Successful";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.connectCallbackID]];
}

- (void)tjcConnectFail:(NSNotification *)notifyObj
{
    NSLog(@"Tapjoy connect Failed");

    NSString *stringToReturn = @"Connect Failed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.connectCallbackID]];
}


#pragma mark - Currency Hooks

- (void)getUpdatedPoints:(NSNotification *)notifyObj
{
    NSNumber *tapPoints = notifyObj.object;

    NSString *stringToReturn = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    NSLog(@"Tap Points Callback ID: %@", self.tapPointsCallbackID);

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.tapPointsCallbackID]];
}

- (void)getUpdatedPointsError:(NSNotification *)notifyObj
{
    NSLog(@"Tap Points error");

    NSString *stringToReturn = @"Get Tap Points Failed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.tapPointsCallbackID]];
}

#pragma mark -

- (void)spendUpdatedPoints:(NSNotification *)notifyObj
{
    NSNumber *tapPoints = notifyObj.object;

    NSString *stringToReturn = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.spendTapPointsCallbackID]];
}

- (void)spendUpdatedPointsError:(NSNotification *)notifyObj
{
    NSLog(@"Spend Tap Points error");

    NSString *stringToReturn = @"Spend Tap Points Failed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.spendTapPointsCallbackID]];
}

#pragma mark -

- (void)awardUpdatedPoints:(NSNotification *)notifyObj
{
    NSNumber *tapPoints = notifyObj.object;
    NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
    NSLog(@"%@", tapPointsStr);

    NSString *stringToReturn = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.awardTapPointsCallbackID]];
}

- (void)awardUpdatedPointsError:(NSNotification *)notifyObj
{
    NSLog(@"Spend Tap Points error");

    NSString *stringToReturn = @"Award Tap Points Failed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.awardTapPointsCallbackID]];
}

/*
#pragma mark - Full Screen Hooks

- (void)getFullScreenAdResponse:(NSNotification *)notifyObj
{
    NSString *stringToReturn = @"Full Screen Ad Successful";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.fullScreenAdCallbackID]];
}

- (void)getFullScreenAdError:(NSNotification *)notifyObj
{
    NSString *stringToReturn = @"Full Screen Ad Failed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.fullScreenAdCallbackID]];
}
*/

#pragma mark - Offers Hooks

- (void)showOffersError:(NSNotification *)notifyObj
{
    NSString *stringToReturn = @"Show Offers Failed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.offersCallbackID]];
}


#pragma mark -
#pragma mark - Properties

- (BOOL)hasKeyFlags
{
    return [_keyFlagValueDict count] > 0;
}

- (NSMutableDictionary *)keyFlagValueDict
{
    if (!_keyFlagValueDict) {
        _keyFlagValueDict = [[NSMutableDictionary alloc] init];
    }
    return _keyFlagValueDict;
}

- (NSMutableDictionary *)callbackDict
{
    if (!_callbackDict) {
        _callbackDict = [[NSMutableDictionary alloc] init];
    }
    return _callbackDict;
}

- (NSMutableDictionary *)eventsDict
{
    if (!_eventsDict) {
        _eventsDict = [[NSMutableDictionary alloc] init];
    }
    return _eventsDict;
}

- (NSMutableDictionary *)eventRequestDict
{
    if (!_eventRequestDict) {
        _eventRequestDict = [[NSMutableDictionary alloc] init];
    }
    return _eventRequestDict;
}


#pragma mark - Cordova Helpers

/**
 * Does input consist only of the digits 0 through 9?
 */
- (BOOL)isInt:(NSString *)numberStr
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [numberStr rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

/**
 * Check for null|empty|false command args
 */
- (BOOL)isEmpty:(NSString *)commandArg
{
    return !commandArg || commandArg == (id)[NSNull null] || commandArg.length == 0;
}

/**
 * Run the command's status_ok callback
 */
- (void)sendPluginOK:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
 * Run the command's status_error callback
 */
- (void)sendPluginError:(CDVInvokedUrlCommand *)command message:(NSString *)message
{
    CDVPluginResult *pluginResult = nil;
    NSString *error = [NSString stringWithFormat:@"Error in TapjoyPlugin: %@", message];
    NSLog(@"%@", error);

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
 * Debug all JavaScript calls
 */
- (void)writeTapjoyJavaScript:(NSString *)jsString
{
    NSLog(@"%@", jsString);
    [self writeJavascript:jsString];
}


#pragma mark -
#pragma mark - TJCAdDelegate

- (void)didReceiveAd:(TJCAdView *)adView
{
    NSString *stringToReturn = @"Display Ad Successful";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.displayAdCallbackID]];
}


- (void)didFailWithMessage:(NSString *)msg
{
    NSString *stringToReturn = @"Display Ad Error";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.displayAdCallbackID]];
}

- (NSString *)adContentSize
{
    return displayAdSize;
}

- (BOOL)shouldRefreshAd
{
    return [self shouldDisplayAdAutoRefresh];
}


#pragma mark - TJCVideoAdDelegate

- (void)videoAdBegan
{
    NSString *stringToReturn = @"Video Ad Began";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    // FIXME: This is just wrong... (?)
    // These are independent events, not result callbacks
    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.videoAdDelegateCallbackID]];
}

- (void)videoAdCompleted
{
    NSString *stringToReturn = @"Video Ad Completed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.videoAdDelegateCallbackID]];
}

- (void)videoAdClosed
{
    NSString *stringToReturn = @"Video Ad Closed";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toSuccessCallbackString:self.videoAdDelegateCallbackID]];
}

- (void)videoAdError:(NSString *)errorMsg
{
    NSString *stringToReturn = @"Video Ad Error";
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];

    [self writeTapjoyJavaScript:[pluginResult toErrorCallbackString:self.videoAdDelegateCallbackID]];
}




#pragma mark - TJEventDelegate (Static)

- (void)event:(NSString *)guid didRequestAction:(TJEventRequest *)request
{
    [self.eventRequestDict setObject:request forKey:guid];

    NSString *js = [NSString stringWithFormat:@"Tapjoy.eventDidRequestAction('%@', '%u', '%@', '%d');", guid, request.type, request.identifier, request.quantity];
    [self writeTapjoyJavaScript:js];
}

#pragma mark -

- (void)sendEventComplete:(NSString *)guid withContent:(BOOL)contentIsAvailable
{
    NSString *js = nil;
    if (contentIsAvailable) {
        js = [NSString stringWithFormat:@"Tapjoy.sendEventCompleteWithContent('%@');", guid];
    } else {
        js = [NSString stringWithFormat:@"Tapjoy.sendEventComplete('%@');", guid];
    }
    [self writeTapjoyJavaScript:js];
}

- (void)sendEventFail:(NSString *)guid error:(NSError*)error
{
    NSString *js = [NSString stringWithFormat:@"Tapjoy.sendEventFail('%@');", guid];
    [self writeTapjoyJavaScript:js];
}

- (void)contentWillAppear:(NSString *)guid
{
    NSString *js = [NSString stringWithFormat:@"Tapjoy.eventContentWillAppear('%@');", guid];
    [self writeTapjoyJavaScript:js];
}

- (void)contentDidAppear:(NSString *)guid
{
    NSString *js = [NSString stringWithFormat:@"Tapjoy.eventContentDidAppear('%@');", guid];
    [self writeTapjoyJavaScript:js];
}

- (void)contentWillDisappear:(NSString *)guid
{
    NSString *js = [NSString stringWithFormat:@"Tapjoy.eventContentWillDisappear('%@');", guid];
    [self writeTapjoyJavaScript:js];
}

- (void)contentDidDisappear:(NSString *)guid
{
    NSString *js = [NSString stringWithFormat:@"Tapjoy.eventContentDidDisappear('%@');", guid];
    [self writeTapjoyJavaScript:js];
}

@end
