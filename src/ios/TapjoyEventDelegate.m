// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license
//

#import "TapjoyEventDelegate.h"
#import "TapjoyPlugin.h"

@implementation TapjoyEventDelegate

- (id)init
{
    if (self = [super init]) {
        // init
    }
    return self;
}

+ (id)createEventWithGuid:(NSString *)guid plugin:(TapjoyPlugin *)plugin
{
    TapjoyEventDelegate *instance = [[TapjoyEventDelegate alloc] init];
    [instance setMyGuid:guid];
    [instance setTapjoyPlugin:plugin];
    return instance;
}

#pragma mark - TJEventDelegate

- (void)sendEventComplete:(TJEvent *)event withContent:(BOOL)contentIsAvailable
{
    NSLog(@"Send event complete from TapjoyPlugin");
    [self.tapjoyPlugin sendEventComplete:self.myGuid withContent:contentIsAvailable];
}

- (void)sendEventFail:(TJEvent *)event error:(NSError *)error
{
    NSLog(@"Send event failed from TapjoyPlugin");
    [self.tapjoyPlugin sendEventFail:self.myGuid error:error];
}

- (void)contentWillAppear:(TJEvent *)event
{
    [self.tapjoyPlugin contentWillAppear:self.myGuid];
}

- (void)contentDidAppear:(TJEvent *)event
{
    [self.tapjoyPlugin contentDidAppear:self.myGuid];
}

- (void)contentWillDisappear:(TJEvent *)event
{
    [self.tapjoyPlugin contentWillDisappear:self.myGuid];
}

- (void)contentDidDisappear:(TJEvent *)event
{
    [self.tapjoyPlugin contentDidDisappear:self.myGuid];
}

- (void)event:(TJEvent *)event didRequestAction:(TJEventRequest *)request
{
    [self.tapjoyPlugin event:self.myGuid didRequestAction:request];
}

@end
