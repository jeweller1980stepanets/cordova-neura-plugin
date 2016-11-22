#import "AppDelegate+NeuraNotification.h"
#import <objc/runtime.h>
#import <NeuraSDK/NeuraSDK.h>

AppDelegate *appDelegate;

@implementation AppDelegate (NeuraNotification)

+ (void)load {
    Method original, neuraInit;
    original = class_getInstanceMethod(self, @selector(init));
    neuraInit = class_getInstanceMethod(self, @selector(neura_init));
    method_exchangeImplementations(original, neuraInit);
}

- (AppDelegate *)neura_init {
    [NeuraSDK sharedInstance];
  return [self neura_init];
}

@end
