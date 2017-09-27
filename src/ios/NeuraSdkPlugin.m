#import "NeuraSdkPlugin.h"
#import <Cordova/CDV.h>
#import <NeuraSDK/NeuraSDK.h>
#import <NeuraSDK/NeuraSDKPushNotification.h>

//#define NEURA_SDK_PLUGIN_LOG_ENABLED 1

const NSInteger kNeuraSdkError_Unknown              = -1;
const NSInteger kNeuraSdkError_Invalid_Arguments    = -2;

// 'init' method related constants
NSString * const kAppUid                        = @"appUid";
NSString * const kAppSecret                     = @"appSecret";
NSString * const kIos                           = @"ios";
NSString * const kAutomaticPush                 = @"automaticPush";
NSString * const kFeatures                      = @"features";
NSString * const kCustomErrorNotification       = @"customErrorNotification";
NSString * const kDisableSdkLogging             = @"disableSdkLogging";

// 'authenticate' method related constants
NSString * const kPhone                         = @"phone";

// Unsupported APIs messages
NSString * const kApiIsNotSupported             = @"This API is not supported by Neura iOS SDK";
NSString * const kConfirmationDialogUnsupported = @"Confirmation dialog is not supported by Neura iOS SDK";
NSString * const kAddDeviceBySingleCapability   = @"Neura iOS SDK supports adding device by single capability only";

NSString * const kItems                         = @"items";
NSString * const kStatus                        = @"status";
NSString * const kSuccess                       = @"success";
NSString * const kDevices                       = @"devices";
NSString * const kName                          = @"name";
NSString * webHook = @"";
@implementation neura
#pragma mark Helper Methods

- (void)logCalledApi:(NSString*)methodName {
    [self logStringFromMethod:methodName withFormat:@"called...."];
}

- (void) logStringFromMethod:(NSString *)methodName withFormat:(NSString *)format, ... {
    va_list argumentList;
    va_start(argumentList, format);

#ifdef NEURA_SDK_PLUGIN_LOG_ENABLED
    NSString *message = [NSString stringWithFormat:@"#### NEURA_IOS_PLUGIN #### - [%@] - %@", methodName, [[NSString alloc] initWithFormat:format arguments:argumentList]];
    NSLog(@"%@", message);
#endif //NEURA_SDK_PLUGIN_LOG_ENABLED

    va_end(argumentList);
}

- (void)handleUnsupportedApiCall:(NSString*)methodName withCommand:(CDVInvokedUrlCommand*)command {
    NSString *errorMsg = kApiIsNotSupported;
    [self logStringFromMethod:methodName withFormat:errorMsg];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMsg];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark Plugin Initialization method

- (void)pluginInitialize {
    [self logStringFromMethod:NSStringFromSelector(_cmd) withFormat:@"Initialization called."];
}

#pragma mark Neura SDK API interface

- (void)init:(CDVInvokedUrlCommand*)command
{
    [self logCalledApi:NSStringFromSelector(_cmd)];

    CDVPluginResult* pluginResult = nil;

    NSDictionary *paramsDict = [command argumentAtIndex:0 withDefault:[NSDictionary dictionary] andClass:[NSDictionary class]];
    if(paramsDict.count == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments] ;
        return;
    }

    // Check appUid and appSecret
    NSString *appId = [paramsDict objectForKey:kAppUid];
    NSString *appSecret = [paramsDict objectForKey:kAppSecret];

    if(appId.length == 0 || appSecret.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments] ;
        return;
    }

    [[NeuraSDK sharedInstance] setAppUID:appId];
    [[NeuraSDK sharedInstance] setAppSecret:appSecret];

    // Check for 'ios' specific section
    NSDictionary *iosSectionDict = [paramsDict objectForKey:kIos];
    if(iosSectionDict.count > 0) {
        // Check automatic push
        NSNumber *automaticPush = [iosSectionDict objectForKey:kAutomaticPush];


        // Check features
        NSArray *features = [iosSectionDict objectForKey:kFeatures];
        for (NSString *feature in features) {
            if([feature isEqualToString:kCustomErrorNotification]) {
                [[NeuraSdkConfiguration sharedInstance] enableCustomErrorNotifications];
            } else if([feature isEqualToString:kDisableSdkLogging]) {
                //[[NeuraSdkConfiguration sharedInstance]  enableLogs];
            } else {
                [self logStringFromMethod:NSStringFromSelector(_cmd) withFormat:@"Unknown feature: [%@]", feature];
            }
        }
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)authenticate:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;

    NSDictionary *paramsDictionary = nil;
    if(command.arguments.count > 0) {

        // The parameter is a dictionary that contains 'permissions' list and optional parameters like 'phone' number (phone injection) and other additional (future usage) params.
        id param = [command.arguments objectAtIndex:0];
        if([param isKindOfClass:[NSDictionary class]]) {

            NSDictionary *dict = (NSDictionary*)param;

            id phoneNumber = [dict objectForKey:kPhone];
            if([phoneNumber isKindOfClass:[NSString class]] && [phoneNumber length] > 0) {
                paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber, kPhone, nil];
            }
        }
    }

    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }

    NeuraAuthenticationRequest* authRequest = [[NeuraAuthenticationRequest alloc] initWithController:topViewController];
    [[NeuraSDK sharedInstance] authenticateWithRequest:authRequest callback:^(NeuraAuthenticationResult * _Nonnull result) {
        if (result.success) {
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"Neura authentication completed successfully - token: [%@]", result.success];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];

        } else {
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"Neura authentication failed - error: [%@]", result.errorString];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
    }];

}

- (void)anonymousAuthenticate:(CDVInvokedUrlCommand*)command{
    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;
    
    NSData * deviceToken = nil;
    if(command.arguments.count > 0) {
        
        // The parameter is a dictionary that contains 'permissions' list and optional parameters like 'phone' number (phone injection) and other additional (future usage) params.
        id param = [command.arguments objectAtIndex:0];
     
        NSDictionary *dict = (NSDictionary*)param;
            
        deviceToken = [dict objectForKey:@"pushToken"];
     
    }
    
    NeuraAnonymousAuthenticationRequest *request = [[NeuraAnonymousAuthenticationRequest alloc] initWithDeviceToken:deviceToken];
    
    // Anonymos authentication started
    [NeuraSDK.shared authenticateWithRequest:request callback:^(NeuraAuthenticationResult *result) {
        if (result.error) {
            // Handle authentication errors.
            NSLog(@"login error = %@", result.error);
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"Neura authentication failed - error: [%@]", result.error];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", result.error]];
        } else {
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"Neura authentication completed successfully - token: [%@]", result.success];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
        }
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
        
    }];
}

- (void)registerPushServerApiKey:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)forgetMe:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    CDVPluginResult* pluginResult = nil;
    NSNumber *showConfirmation = [command.arguments objectAtIndex:0];
    if(false) {

        // TODO: Implement confirmation dialog
        [self logStringFromMethod:NSStringFromSelector(_cmd)
                       withFormat:kConfirmationDialogUnsupported];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:kConfirmationDialogUnsupported];
    } else {

        [[NeuraSDK sharedInstance] logoutWithCallback:^(NeuraLogoutResult * _Nonnull result) {
            if (result.success) {
                [self logStringFromMethod:NSStringFromSelector(_cmd)
                               withFormat:@"Neura logout success"];
            } else {
                [self logStringFromMethod:NSStringFromSelector(_cmd)
                               withFormat:@"Neura logout failed - error: [%@]", result.errorString];
            }
        }];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)getSubscriptions:(CDVInvokedUrlCommand *)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];

    [[NeuraSDK sharedInstance]  getSubscriptionsListWithCallback:^(NeuraSubscriptionsListResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;
        if (result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)subscribeToEvent:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;

    NSString *eventName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    webHook = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];

    if(eventName.length == 0 || webHook.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    NSubscription* event = [[NSubscription alloc] initWithEventName:eventName webhookId:webHook];
    [[NeuraSDK sharedInstance] addSubscription:event callback:^(NeuraAddSubscriptionResult * _Nonnull result) {
        if(result.success) {
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"subscribeToEvent - responseData: [%@]", result.subscription.eventName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventName];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)removeSubscription:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;

    NSString *eventName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    NSString *eventId = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];

    if(eventName.length == 0 || eventId.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    NSubscription* event = [[NSubscription alloc] initWithEventName:eventName webhookId:eventId
                            ];
    [[NeuraSDK sharedInstance] removeSubscription:event callback:^(NeuraAPIResult * _Nonnull result) {
        if(result.success) {
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"removeSubscription - success"];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventName];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)shouldSubscribeToEvent:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)getAppPermissions:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] getAppPermissionsListWithCallback:^(NeuraPermissionsListResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;
        if (result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getPermissionStatus:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)enableLogFile:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)enableAutomaticallySyncLogs:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)enableNeuraHandingStateAlertMessages:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)getSdkVersion:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    NSString *sdkVersion = [[NeuraSDK sharedInstance] getVersion];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:sdkVersion];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isMissingDataForEvent:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    CDVPluginResult* pluginResult = nil;
    NSString *eventName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    if(eventName.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    BOOL bMissingData = [[NeuraSDK sharedInstance] isMissingDataForEvent:eventName];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:bMissingData];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getMissingDataForEvent:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;
    NSString *eventName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    if(eventName.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    if(!([[NeuraSDK sharedInstance] isMissingDataForEvent:eventName])) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    [[NeuraSDK sharedInstance] getMissingDataForEvent:eventName withCallback:^(NeuraAPIResult * _Nonnull result) {
        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"getMissingDataForEvent, Error:[%@]", result.errorString];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)getKnownDevices:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] getSupportedDevicesListWithCallback:^(NeuraSupportedDevicesListResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;
        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:result.success];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getKnownCapabilities:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] getSupportedCapabilitiesListWithCallback:^(NeuraSupportedCapabilitiesListResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;
        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)hasDeviceWithCapability:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;
    NSString *capabilityName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    if(capabilityName.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    NCapability* capability = [[NCapability alloc] initWithName:capabilityName];
    [[NeuraSDK sharedInstance] hasDeviceWithCapability:capability withCallback:^(NeuraHasDeviceWithCapabilityResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;
        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)addDevice:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] addDeviceWithCallback:^(NeuraAddDeviceResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;

        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"addDevice error:[%@]", result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)addDeviceByCapabilities:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];

    __block CDVPluginResult* pluginResult = nil;
    if(command.arguments.count != 1) {
        if(command.arguments.count == 0) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:kAddDeviceBySingleCapability];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    NSString *capability = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    if([capability isEqualToString:@""]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    [[NeuraSDK sharedInstance] addDeviceWithCapabilityNamed:capability withCallback:^(NeuraAddDeviceResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;

        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"addDeviceByCapabilities error:[%@]", result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)addDeviceByName:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];

    __block CDVPluginResult* pluginResult = nil;
    NSString *deviceName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    if([deviceName isEqualToString:@""]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    [[NeuraSDK sharedInstance] addDeviceNamed:deviceName withCallback:^(NeuraAddDeviceResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;

        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"addDeviceByName error:[%@]", result.errorString];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)getUserDetails:(CDVInvokedUrlCommand*)command {

    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)getUserPhone:(CDVInvokedUrlCommand*)command {

    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)simulateAnEvent:(CDVInvokedUrlCommand*)command {

    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)getUserSituation:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];

    __block CDVPluginResult* pluginResult = nil;
    NSNumber *timestamp = [command argumentAtIndex:0 withDefault:[NSNumber numberWithDouble:0.0] andClass:[NSNumber class]];
    if([timestamp doubleValue] == 0.0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    NSDate *dateTs = [NSDate dateWithTimeIntervalSince1970:([timestamp doubleValue]/1000.0)];
    [[NeuraSDK sharedInstance] getUserSituationForTimeStamp:dateTs contextual:NO callback:^(NeuraGetUserSituationResult * _Nonnull result) {
        CDVPluginResult* pluginResult = nil;

        if(result.success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result.errorString];
            [self logStringFromMethod:NSStringFromSelector(_cmd)
                           withFormat:@"getUserSituation error:[%@]", result.errorString];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end

