// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license


#import <Cordova/CDVPlugin.h>
#import <Foundation/Foundation.h>
#import <Tapjoy/Tapjoy.h>
#import <Tapjoy/TJEvent.h>

//EVENTS
static NSString* const TJ_SEND_EVENT_COMPLETE = @"TJ_SEND_EVENT_COMPLETE";
static NSString* const TJ_SEND_EVENT_COMPLETE_WITH_CONTENT = @"TJ_SEND_EVENT_COMPLETE_WITH_CONTENT";
static NSString* const TJ_SEND_EVENT_FAIL = @"TJ_SEND_EVENT_FAIL";
static NSString* const TJ_CONTENT_DID_SHOW = @"TJ_CONTENT_DID_SHOW";
static NSString* const TJ_CONTENT_DID_DISAPPEAR = @"TJ_CONTENT_DID_DISAPPEAR";
static NSString* const TJ_DID_REQUEST_ACTION = @"TJ_DID_REQUEST_ACTION";

@interface TapjoyPlugin : CDVPlugin <TJCAdDelegate, TJCVideoAdDelegate, TJEventDelegate>
{
}

@property (nonatomic, retain) NSMutableDictionary *keyFlagValueDict;
@property (nonatomic, copy) NSString* connectCallbackID;            /*!< The callback ID for the Tapjoy Connect call. */
@property (nonatomic, copy) NSString* fullScreenAdCallbackID;       /*!< The callback ID for Full Screen Ad. */
@property (nonatomic, copy) NSString* tapPointsCallbackID;          /*!< The callback ID for retrieving Tap Points. */
@property (nonatomic, copy) NSString* spendTapPointsCallbackID;     /*!< The callback ID for spending Tap Points. */
@property (nonatomic, copy) NSString* awardTapPointsCallbackID;     /*!< The callback ID for awarding Tap Points. */
@property (nonatomic, copy) NSString* videoAdDelegateCallbackID;    /*!< The callback ID for Video Ad Delegate. */
@property (nonatomic, copy) NSString* displayAdCallbackID;          /*!< The callback ID for Display Ad. */
@property (nonatomic, copy) NSString* offersCallbackID;             /*!< The callback ID for Offer Wall. */
@property (nonatomic, assign, getter=shouldDisplayAdAutoRefresh) BOOL enableDisplayAdAutoRefresh;
@property (nonatomic, copy) NSString* displayAdSize;
@property (nonatomic, assign) CGRect displayAdFrame;
@property (nonatomic, retain) NSMutableDictionary *eventsDict;
@property (nonatomic, retain) NSMutableDictionary *callbackDict;
@property (nonatomic, retain) NSMutableDictionary *eventRequestDict;

- (BOOL)hasKeyFlag;

- (void)setFlagKeyValue:(CDVInvokedUrlCommand*)command;

- (void)requestTapjoyConnect:(CDVInvokedUrlCommand*)command;

- (void)setUserID:(CDVInvokedUrlCommand*)command;

- (void)actionComplete:(CDVInvokedUrlCommand*)command;

- (void)showOffers:(CDVInvokedUrlCommand*)command;

- (void)showOffersWithCurrencyID:(CDVInvokedUrlCommand*)command;

- (void)getTapPoints:(CDVInvokedUrlCommand*)command;

- (void)spendTapPoints:(CDVInvokedUrlCommand*)command;

- (void)awardTapPoints:(CDVInvokedUrlCommand*)command;

- (void)getFullScreenAd:(CDVInvokedUrlCommand*)command;

- (void)getFullScreenAdWithCurrencyID:(CDVInvokedUrlCommand*)command;

- (void)showFullScreenAd:(CDVInvokedUrlCommand*)command;

- (void)setVideoCacheCount:(CDVInvokedUrlCommand*)command;

- (void)setVideoAdDelegate:(CDVInvokedUrlCommand*)command;

- (void)cacheVideos:(CDVInvokedUrlCommand*)command;

- (void)sendIAPEvent:(CDVInvokedUrlCommand*)command;

- (void)getDisplayAd:(CDVInvokedUrlCommand*)command;

- (void)showDisplayAd:(CDVInvokedUrlCommand*)command;

- (void)hideDisplayAd:(CDVInvokedUrlCommand*)command;

- (void)enableDisplayAdAutoRefresh:(CDVInvokedUrlCommand*)command;

- (void)moveDisplayAd:(CDVInvokedUrlCommand*)command;

- (void)setDisplayAdSize:(CDVInvokedUrlCommand*)command;

// Tapjoy Events
- (void)createEvent:(CDVInvokedUrlCommand*)command;

- (void)sendEvent:(CDVInvokedUrlCommand*)command;

- (void)showEvent:(CDVInvokedUrlCommand*)command;

- (void)enableEventAutoPresent:(CDVInvokedUrlCommand*)command;

- (void)eventRequestCompleted:(CDVInvokedUrlCommand*)command;

- (void)eventRequestCancelled:(CDVInvokedUrlCommand*)command;

- (void)sendEventComplete:(NSString*)guid withContent:(BOOL)contentIsAvailable;
- (void)sendEventFail:(NSString*)guid error:(NSError*)error;
- (void)contentWillAppear:(NSString*)guid;
- (void)contentDidAppear:(NSString*)guid;
- (void)contentWillDisappear:(NSString*)guid;
- (void)contentDidDisappear:(NSString*)guid;
- (void)event:(NSString*)guid didRequestAction:(TJEventRequest*)request;

@end
