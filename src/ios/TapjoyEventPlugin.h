#import <Foundation/Foundation.h>
#import <Tapjoy/Tapjoy.h>
#import <Tapjoy/TJEvent.h>
#import "TapjoyPlugin.h"

@interface TapjoyEventPlugin : NSObject<TJEventDelegate>
{
	// This is set to the guid of the object that will implement the callback functions for handling Tapjoy events.
	NSString *myGuid_;
    TapjoyPlugin *tapjoyPlugin_;
}

@property (nonatomic, copy) NSString *myGuid;
@property (nonatomic, retain) TapjoyPlugin *tapjoyPlugin;

+ (id)createEventWithGuid:(NSString*)guid plugin:(TapjoyPlugin*)plugin;

@end
