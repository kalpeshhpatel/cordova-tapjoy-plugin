// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license


#import "TapjoyPlugin.h"
#import "TapjoyEventPlugin.h"

@implementation TapjoyPlugin

- (void)requestTapjoyConnect:(CDVInvokedUrlCommand*)command
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CONNECT_FAILED object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_DAILY_REWARD_RESPONSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_DAILY_REWARD_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_OFFERS_RESPONSE_NOTIFICATION_ERROR object:nil];

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFeaturedAppResponse:)
																name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
														  selector:@selector(getUpdatedPoints:) 
																name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(spendUpdatedPoints:) 
																name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(awardUpdatedPoints:) 
																name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION 
															 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFullScreenAdResponse:)
                                                                name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION
                                                             object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDailyRewardAdResponse:)
                                                                name:TJC_DAILY_REWARD_RESPONSE_NOTIFICATION
                                                             object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
														  selector:@selector(getUpdatedPointsError:)
																name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(spendUpdatedPointsError:) 
																name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(awardUpdatedPointsError:) 
																name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR
															 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                          selector:@selector(getFullScreenAdError:)
                                                                name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION_ERROR
                                                             object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                                          selector:@selector(getDailyRewardAdError:)
                                                                name:TJC_DAILY_REWARD_RESPONSE_NOTIFICATION_ERROR
                                                             object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                                          selector:@selector(showOffersError:)
                                                                name:TJC_OFFERS_RESPONSE_NOTIFICATION_ERROR
                                                             object:nil];
	self.connectCallbackID =command.callbackId;
	
	NSString *appID = [command.arguments objectAtIndex:0];
	NSString *secretKey = [command.arguments objectAtIndex:1];
	
    _displayAdSize = TJC_DISPLAY_AD_SIZE_320X50;
    _displayAdFrame = CGRectMake(0, 0, 320, 50);
    
	[Tapjoy setPlugin:@"phonegap"];
    
    [self.commandDelegate runInBackground:^{
        if([self hasKeyFlag]){
            [Tapjoy requestTapjoyConnect:appID secretKey:secretKey options:_keyFlagValueDict];
        }
        else{
            [Tapjoy requestTapjoyConnect:appID secretKey:secretKey];
        }
    }];

}

- (BOOL)hasKeyFlag
{
    if (_keyFlagValueDict)
        return YES;
	return NO;
}

- (void)setFlagKeyValue:(CDVInvokedUrlCommand*)command
{
    NSString *key = [command.arguments objectAtIndex:0];
    NSString *value = [command.arguments objectAtIndex:1];
    
	if (!_keyFlagValueDict)
		_keyFlagValueDict = [[NSMutableDictionary alloc] init];
	[_keyFlagValueDict setObject:value forKey:key];

}

- (void)setUserID:(CDVInvokedUrlCommand*)command
{	
	NSString *userID = [command.arguments objectAtIndex:0];
	
	[Tapjoy setUserID:userID];
}


- (void)actionComplete:(CDVInvokedUrlCommand*)command
{
	NSString *actionID = [command.arguments objectAtIndex:0];
	
	[Tapjoy actionComplete:actionID];
}

- (void)showOffers:(CDVInvokedUrlCommand*)command
{
    self.offersCallbackID = command.callbackId;
	[Tapjoy showOffersWithViewController:self.viewController];
}


- (void)showOffersWithCurrencyID:(CDVInvokedUrlCommand*)command
{
    self.offersCallbackID = command.callbackId;
    
	NSString *currencyID = [command.arguments objectAtIndex:0];
	id selector = [command.arguments objectAtIndex:1];
	BOOL selectorBool = [selector boolValue];
	
	[Tapjoy showOffersWithCurrencyID:currencyID withCurrencySelector:selectorBool];
}


- (void)getTapPoints:(CDVInvokedUrlCommand*)command
{
	self.tapPointsCallbackID = command.callbackId;
	
	NSLog(@"tap points callback ID: %@", self.tapPointsCallbackID);
	
	[Tapjoy getTapPoints];
}


- (void)spendTapPoints:(CDVInvokedUrlCommand*)command
{
	self.spendTapPointsCallbackID = command.callbackId;
	
	NSString *amountString = [command.arguments objectAtIndex:0];
	int amount = [amountString intValue];
	
	[Tapjoy spendTapPoints:amount];
}


- (void)awardTapPoints:(CDVInvokedUrlCommand*)command
{
	self.awardTapPointsCallbackID = command.callbackId;
	
	NSString *amountString = [command.arguments objectAtIndex:0];
	int amount = [amountString intValue];
	
	[Tapjoy awardTapPoints:amount];	
}



- (void)getFeaturedApp:(CDVInvokedUrlCommand*)command
{
	self.featuredAppCallbackID = command.callbackId;
	
	[Tapjoy getFeaturedApp];
}


- (void)getFeaturedAppWithCurrencyID:(CDVInvokedUrlCommand*)command
{
	self.featuredAppCallbackID = command.callbackId;
	
	NSString *currencyID = [command.arguments objectAtIndex:0];
	
	[Tapjoy getFeaturedAppWithCurrencyID:currencyID];
}


- (void)setFeaturedAppDisplayCount:(CDVInvokedUrlCommand*)command
{
	NSString *displayCountString = [command.arguments objectAtIndex:0];
	int displayCount = [displayCountString intValue];
	
	[Tapjoy setFeaturedAppDisplayCount:displayCount];
}


- (void)showFeaturedAppFullScreenAd:(CDVInvokedUrlCommand*)command
{
	[Tapjoy showFeaturedAppFullScreenAd];
}


- (void)initVideoAd:(CDVInvokedUrlCommand*)command
{
	[Tapjoy initVideoAdWithDelegate:self];
}


- (void)setVideoCacheCount:(CDVInvokedUrlCommand*)command
{
	NSString *displayCountString = [command.arguments objectAtIndex:0];
	int displayCount = [displayCountString intValue];
	
	[Tapjoy setVideoCacheCount:displayCount];
}

- (void)getFullScreenAd:(CDVInvokedUrlCommand*)command
{
    self.fullScreenAdCallbackID = command.callbackId;
	
	[Tapjoy getFullScreenAd];
}

- (void)getFullScreenAdWithCurrencyID:(CDVInvokedUrlCommand*)command
{
    self.fullScreenAdCallbackID = command.callbackId;
	
	NSString *currencyID = [command.arguments objectAtIndex:0];
	
	[Tapjoy getFullScreenAdWithCurrencyID:currencyID];
}

- (void)showFullScreenAd:(CDVInvokedUrlCommand*)command
{
    [Tapjoy showFullScreenAd];
}

- (void)getDailyRewardAd:(CDVInvokedUrlCommand*)command
{
    self.dailyRewardAdCallbackID = command.callbackId;
    
    [Tapjoy getDailyRewardAd];
}

- (void)getDailyRewardAdWithCurrencyID:(CDVInvokedUrlCommand*)command
{
    self.dailyRewardAdCallbackID = command.callbackId;
    
    NSString *currencyID = [command.arguments objectAtIndex:0];
    
    [Tapjoy getDailyRewardAdWithCurrencyID:currencyID];
    
}

- (void)showDailyRewardAd:(CDVInvokedUrlCommand*)command
{
    [Tapjoy showDailyRewardAd];
}

- (void)cacheVideos:(CDVInvokedUrlCommand*)command
{
    [Tapjoy cacheVideosWithDelegate:self];
}

- (void)setVideoAdDelegate:(CDVInvokedUrlCommand*)command
{
    self.videoAdDelegateCallbackID = command.callbackId;
    [Tapjoy setVideoAdDelegate:self];
}

- (void)sendIAPEvent:(CDVInvokedUrlCommand*)command
{
    NSString *name = [command.arguments objectAtIndex:0];
    NSString *price = [command.arguments objectAtIndex:1];
    NSString *quantity = [command.arguments objectAtIndex:2];
    NSString *currencyCode = [command.arguments objectAtIndex:3];
    
    [Tapjoy sendIAPEvent:name price:[price floatValue] quantity:[quantity intValue] currencyCode:currencyCode];
}

- (void)getDisplayAd:(CDVInvokedUrlCommand*)command
{
    self.displayAdCallbackID = command.callbackId;
    
    [Tapjoy getDisplayAdWithDelegate:self];
}

- (void)showDisplayAd:(CDVInvokedUrlCommand*)command
{
    TJCAdView *adView = [Tapjoy getDisplayAdView];
    [adView setFrame:_displayAdFrame];
    [self.viewController.view addSubview:(UIView *)adView];
}

- (void)hideDisplayAd:(CDVInvokedUrlCommand*)command
{
    UIView *adView = (UIView*)[Tapjoy getDisplayAdView];
	
	[adView removeFromSuperview];
}

- (void)enableDisplayAdAutoRefresh:(CDVInvokedUrlCommand*)command
{
    id enable = [command.arguments objectAtIndex:0];
    BOOL enableBool = [enable boolValue];
    _enableDisplayAdAutoRefresh = enableBool;
}

- (void)moveDisplayAd:(CDVInvokedUrlCommand*)command
{
    // adjust frame
    NSString* xString = [command.arguments objectAtIndex:0];
    NSString* yString = [command.arguments objectAtIndex:1];
    _displayAdFrame.origin = CGPointMake([xString intValue], [yString intValue]);
    
    // move view
    TJCAdView *adView = [Tapjoy getDisplayAdView];
    [adView setFrame:_displayAdFrame];
}

- (void)setDisplayAdSize:(CDVInvokedUrlCommand*)command
{
    _displayAdSize = [command.arguments objectAtIndex:0];
}

- (void)getUpdatedPoints:(NSNotification*)notifyObj
{
	NSNumber *tapPoints = notifyObj.object;
	NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	NSLog(@"%@", tapPointsStr);
	
	NSString *stringToReturn = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	NSLog(@"tap points callback ID: %@", self.tapPointsCallbackID);
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.tapPointsCallbackID]];
}


- (void)getUpdatedPointsError:(NSNotification*)notifyObj
{
	NSLog(@"Tap Points error");
	
	NSString *stringToReturn = @"Get Tap Points Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.tapPointsCallbackID]];
}


- (void)spendUpdatedPoints:(NSNotification*)notifyObj
{
	NSNumber *tapPoints = notifyObj.object;
	NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	NSLog(@"%@", tapPointsStr);
	
	NSString *stringToReturn = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.spendTapPointsCallbackID]];
}


- (void)spendUpdatedPointsError:(NSNotification*)notifyObj
{
	NSLog(@"Spend Tap Points error");
	
	NSString *stringToReturn = @"Spend Tap Points Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.spendTapPointsCallbackID]];
}


- (void)awardUpdatedPoints:(NSNotification*)notifyObj
{
	NSNumber *tapPoints = notifyObj.object;
	NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	NSLog(@"%@", tapPointsStr);
	
	NSString *stringToReturn = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.awardTapPointsCallbackID]];
}


- (void)awardUpdatedPointsError:(NSNotification*)notifyObj
{
	NSLog(@"Spend Tap Points error");
	
	NSString *stringToReturn = @"Award Tap Points Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.awardTapPointsCallbackID]];
}


- (void)getFeaturedAppResponse:(NSNotification*)notifyObj
{
    // TODO: fix these lines
	// notifyObj will be returned as Nil in case of internet error or unavailibity of featured App 
	// or its Max Number of count has exceeded its limit
//	TJCFeaturedAppModel *featuredApp = notifyObj.object;
//	NSLog(@"Featured App Name: %@, Cost: %@, Description: %@, Amount: %d", featuredApp.name, featuredApp.cost, featuredApp.description, featuredApp.amount);
//	NSLog(@"Featured App Image URL %@ ", featuredApp.iconURL);
	
	NSString *stringToReturn = @"Featured App Successful";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.featuredAppCallbackID]];
}

- (void)getFullScreenAdResponse:(NSNotification*)notifyObj
{
	NSString *stringToReturn = @"Full Screen Ad Successful";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.fullScreenAdCallbackID]];
}

- (void)getFullScreenAdError:(NSNotification*)notifyObj
{
	NSString *stringToReturn = @"Full Screen Ad Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.fullScreenAdCallbackID]];
}

- (void)getDailyRewardAdResponse:(NSNotification*)notifyObj
{

	NSString *stringToReturn = @"Daily Reward Ad Successful";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.dailyRewardAdCallbackID]];
}



- (void)getDailyRewardAdError:(NSNotification*)notifyObj
{
    NSString *stringToReturn = @"Daily Reward Ad Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.dailyRewardAdCallbackID]];
    
}
     
- (void)showOffersError:(NSNotification*)notifyObj
{
    NSString *stringToReturn = @"Show Offers Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.offersCallbackID]];
}

- (void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
	
	NSString *stringToReturn = @"Connect Successful";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.connectCallbackID]];
}


- (void)tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");	
	
	NSString *stringToReturn = @"Connect Failed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
																	  messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.connectCallbackID]];
}

#pragma mark Tapjoy Video Ads Delegate Methods

- (void)videoAdBegan
{
    NSString *stringToReturn = @"Video Ad Began";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.videoAdDelegateCallbackID]];
}


- (void)videoAdClosed
{
    NSString *stringToReturn = @"Video Ad Closed";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.videoAdDelegateCallbackID]];
}

- (void)videoAdError:(NSString *)errorMsg
{
    NSString *stringToReturn = @"Video Ad Error";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.videoAdDelegateCallbackID]];
}




#pragma mark Tapjoy Display Ads Delegate Methods

- (void)didReceiveAd:(TJCAdView*)adView
{
    NSString *stringToReturn = @"Display Ad Successful";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toSuccessCallbackString:self.displayAdCallbackID]];
}


- (void)didFailWithMessage:(NSString*)msg
{
    NSString *stringToReturn = @"Display Ad Error";
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:stringToReturn];
	
	[self writeJavascript:[pluginResult toErrorCallbackString:self.displayAdCallbackID]];
}


- (NSString*)adContentSize
{
	return _displayAdSize;
}

- (BOOL)shouldRefreshAd
{
    return [self shouldDisplayAdAutoRefresh];
}

#pragma mark Tapjoy Event Methods

- (void)createEvent:(CDVInvokedUrlCommand*)command
{
    NSString *guid = [command.arguments objectAtIndex:0];
    NSString *name = [command.arguments objectAtIndex:1];
    NSString *eventParameter = [command.arguments objectAtIndex:2];
    
    // Create dictionary if its empty
	if (!_eventsDict)
		_eventsDict = [[NSMutableDictionary alloc] init];
    
    if(!_callbackDict)
        _callbackDict = [[NSMutableDictionary alloc] init];
    
    // Save off callbacks in dict to workaround weird release/crash issues
    TapjoyEventPlugin *tjevt = [TapjoyEventPlugin createEventWithGuid:guid plugin:self];
        [_callbackDict setObject:tjevt forKey:guid];
    
    // TODO: allow for string param to be used
	TJEvent *evt = [TJEvent eventWithName:name delegate:tjevt];
	[_eventsDict setObject:evt forKey:guid];
}

- (void)sendEvent:(CDVInvokedUrlCommand*)command
{
    // TODO: nil check
    NSString *guid = [command.arguments objectAtIndex:0];
    
    NSLog(@"Send Event GUID: %@",guid);
    NSLog(@"Event %@",[_eventsDict objectForKey:guid]);
    
    [self.commandDelegate runInBackground:^{
        [[_eventsDict objectForKey:guid] send];
    }];
}

- (void)showEvent:(CDVInvokedUrlCommand*)command
{
	// TODO: nil check
    NSString *guid = [command.arguments objectAtIndex:0];
    
    //TODO: Modify to use a different view controller...not the root view
    UIViewController* viewCntrl = [UIApplication sharedApplication].keyWindow.rootViewController;
	[[_eventsDict objectForKey:guid] presentContentWithViewController:viewCntrl];
}

#pragma mark - Tapjoy Static Event Delegate Methods

- (void)sendEventComplete:(NSString *)guid withContent:(BOOL)contentIsAvailable
{
	if (contentIsAvailable)
    {
        NSString *jsCall = [NSString stringWithFormat: @"Tapjoy.sendEventCompleteWithContent('%@');", guid];
        [self writeJavascript:jsCall];
    }
	else
    {
        NSString *jsCall = [NSString stringWithFormat: @"Tapjoy.sendEventComplete('%@');", guid];
        [self writeJavascript:jsCall];
    } 
	
}

- (void)sendEventFail:(NSString *)guid error:(NSError*)error
{
    NSString *jsCall = [NSString stringWithFormat: @"Tapjoy.sendEventFail('%@');", guid];
    [self writeJavascript:jsCall];
}

- (void)contentWillAppear:(NSString *)guid
{
    
}

- (void)contentDidAppear:(NSString *)guid
{
    
}

- (void)contentWillDisappear:(NSString *)guid
{
    
}

- (void)contentDidDisappear:(NSString *)guid
{
    
}

- (void)event:(NSString *)guid didRequestAction:(TJEventRequest*)request
{
    
}


@end
