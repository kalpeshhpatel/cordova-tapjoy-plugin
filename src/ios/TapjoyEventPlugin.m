#import "TapjoyEventPlugin.h"
#import "TapjoyPlugin.h"

@implementation TapjoyEventPlugin

@synthesize myGuid = myGuid_;
@synthesize tapjoyPlugin = tapjoyPlugin_;

- (id)init
{
	self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

+ (id)createEventWithGuid:(NSString*)guid plugin:(TapjoyPlugin*)plugin
{
	TapjoyEventPlugin *instance = [[TapjoyEventPlugin alloc] init];
	[instance setMyGuid:guid];
    [instance setTapjoyPlugin:plugin];
	return instance;
}

#pragma mark - TJEventDelegate

- (void)sendEventComplete:(TJEvent*)event withContent:(BOOL)contentIsAvailable
{
	NSLog(@"trying to send event complete back to TapjoyPlugin");
	[tapjoyPlugin_ sendEventComplete:myGuid_ withContent:contentIsAvailable];
}

- (void)sendEventFail:(TJEvent*)event error:(NSError*)error
{
	NSLog(@"trying to send event fail back to TapjoyPlugin");
	[tapjoyPlugin_ sendEventFail:myGuid_ error:error];
}

- (void)contentWillAppear:(TJEvent*)event
{
	[tapjoyPlugin_ contentWillAppear:myGuid_];
}

- (void)contentDidAppear:(TJEvent*)event
{
	[tapjoyPlugin_ contentDidAppear:myGuid_];
}

- (void)contentWillDisappear:(TJEvent*)event
{
	[tapjoyPlugin_ contentWillDisappear:myGuid_];
}

- (void)contentDidDisappear:(TJEvent*)event
{
	[tapjoyPlugin_ contentDidDisappear:myGuid_];
}

- (void)event:(TJEvent*)event didRequestAction:(TJEventRequest*)request
{
	[tapjoyPlugin_ event:myGuid_ didRequestAction:request];
}

@end
