#import <Cordova/CDV.h>

@interface neura : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)authenticate:(CDVInvokedUrlCommand*)command;
- (void)anonymousAuthenticate:(CDVInvokedUrlCommand*)command;
- (void)forgetMe:(CDVInvokedUrlCommand*)command;
- (void)getSubscriptions:(CDVInvokedUrlCommand*)command;
- (void)subscribeToEvent:(CDVInvokedUrlCommand*)command;
- (void)removeSubscription:(CDVInvokedUrlCommand*)command;
- (void)getAppPermissions:(CDVInvokedUrlCommand*)command;
- (void)getSdkVersion:(CDVInvokedUrlCommand*)command;
- (void)isMissingDataForEvent:(CDVInvokedUrlCommand*)command;
- (void)getMissingDataForEvent:(CDVInvokedUrlCommand*)command;
- (void)getKnownDevices:(CDVInvokedUrlCommand*)command;
- (void)getKnownCapabilities:(CDVInvokedUrlCommand*)command;
- (void)hasDeviceWithCapability:(CDVInvokedUrlCommand*)command;
- (void)addDevice:(CDVInvokedUrlCommand*)command;
- (void)addDeviceByCapabilities:(CDVInvokedUrlCommand*)command;
- (void)addDeviceByName:(CDVInvokedUrlCommand*)command;
- (void)getUserSituation:(CDVInvokedUrlCommand*)command;

// UNSUPPORTED
- (void)shouldSubscribeToEvent:(CDVInvokedUrlCommand*)command;
- (void)registerPushServerApiKey:(CDVInvokedUrlCommand*)command;
- (void)getPermissionStatus:(CDVInvokedUrlCommand*)command;
- (void)enableLogFile:(CDVInvokedUrlCommand*)command;
- (void)enableAutomaticallySyncLogs:(CDVInvokedUrlCommand*)command;
- (void)enableNeuraHandingStateAlertMessages:(CDVInvokedUrlCommand*)command;
- (void)getUserDetails:(CDVInvokedUrlCommand*)command;
- (void)getUserPhone:(CDVInvokedUrlCommand*)command;
- (void)simulateAnEvent:(CDVInvokedUrlCommand*)command;

@end
