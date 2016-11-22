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
NSString * const kPermissions                   = @"permissions";
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

@implementation neura
#pragma mark Helper Methods

- (void)logCalledApi:(NSString*)methodName {
    [self logStringFromMethod:methodName withFormat:@"called...."];
}

- (void) logStringFromMethod:(NSString *)methodName withFormat:(NSString *)format, ... {
    va_list argumentList;
    va_start(argumentList, format);
    NSString *message = [NSString stringWithFormat:@"#### NEURA_IOS_PLUGIN #### - [%@] - %@", methodName, [[NSString alloc] initWithFormat:format arguments:argumentList]];
    
#ifdef NEURA_SDK_PLUGIN_LOG_ENABLED
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
        if([automaticPush boolValue]) {
            [NeuraSDKPushNotification enableAutomaticPushNotification];
        }
        
        // Check features
        NSArray *features = [iosSectionDict objectForKey:kFeatures];
        NSUInteger flags = 0;
        for (NSString *feature in features) {
            if([feature isEqualToString:kCustomErrorNotification]) {
                flags |= NEUSDKCustomErrorNotification;
            } else if([feature isEqualToString:kDisableSdkLogging]) {
                flags |= NEUSDKDisableSdkLogging;
            } else {
                [self logStringFromMethod:NSStringFromSelector(_cmd) withFormat:@"Unknown feature: [%@]", feature];
            }
        }
        
        if(flags > 0) {
            [[NeuraSDK sharedInstance] enableFeaturesWithKeys:flags];
        }
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)authenticate:(CDVInvokedUrlCommand*)command {
    
    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;
    
    BOOL bParamsOk = NO;
    NSArray *permissionsArray = nil;
    NSDictionary *paramsDictionary = nil;
    if(command.arguments.count > 0) {
        
        // The parameter is a dictionary that contains 'permissions' list and optional parameters like 'phone' number (phone injection) and other additional (future usage) params.
        id param = [command.arguments objectAtIndex:0];
        if([param isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = (NSDictionary*)param;
            
            // check for 'permissions' object - must exist
            id permissionObj = [dict objectForKey:kPermissions];
            if([permissionObj isKindOfClass:[NSArray class]] && [permissionObj count] > 0) {
                bParamsOk = YES;
                permissionsArray = [NSArray arrayWithArray:permissionObj];
                
                id phoneNumber = [dict objectForKey:kPhone];
                if([phoneNumber isKindOfClass:[NSString class]] && [phoneNumber length] > 0) {
                    paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber, kPhone, nil];
                }
            }
        }
    }
    
    if(!bParamsOk) {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
        return;
    }
    
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    
    [[NeuraSDK sharedInstance] authenticateWithPermissions:permissionsArray
                                                  userInfo:paramsDictionary
                                              onController:topViewController
                                               withHandler:^(NSString *token, NSString *error) {
                                                   
                                                   if (token) {
                                                       [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                                      withFormat:@"Neura authentication completed successfully - token: [%@]", token];
                                                       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:token];
                                                       
                                                   }  else {
                                                       [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                                      withFormat:@"Neura authentication failed - error: [%@]", error];
                                                       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
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
    if([showConfirmation boolValue]) {

        // TODO: Implement confirmation dialog
        [self logStringFromMethod:NSStringFromSelector(_cmd)
                       withFormat:kConfirmationDialogUnsupported];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:kConfirmationDialogUnsupported];
    } else {
        
        [[NeuraSDK sharedInstance] logout];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)getSubscriptions:(CDVInvokedUrlCommand *)command {
    
    [self logCalledApi:NSStringFromSelector(_cmd)];
    
    [[NeuraSDK sharedInstance] getSubscriptions:^(NSDictionary *responseData, NSString *error) {
        CDVPluginResult* pluginResult = nil;
        if (!error) {
            NSArray *subscriptions = responseData[kItems];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:subscriptions];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)subscribeToEvent:(CDVInvokedUrlCommand*)command {
    
    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;
    
    NSString *eventName = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    NSString *eventId = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];
    
    if(eventName.length == 0 || eventId.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    [[NeuraSDK sharedInstance] subscribeToEvent:eventName
                                     identifier:eventId
                                      webHookID:nil
                                     completion:^(NSDictionary *responseData, NSString *error) {
                                         
                                         if(!error) {
                                             [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                            withFormat:@"subscribeToEvent - responseData: [%@]", responseData];
                                             pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventName];
                                         } else {
                                             pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
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
    
    [[NeuraSDK sharedInstance] removeSubscriptionWithIdentifier:eventId
                                                       complete:^(NSDictionary *responseData, NSString *error) {
                                                           
                                                           if(!error) {
                                                               [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                                              withFormat:@"removeSubscription - responseData: [%@]", responseData];
                                                               pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventName];
                                                           } else {
                                                               pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
                                                           }
                                                           [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                       }];
}

- (void)shouldSubscribeToEvent:(CDVInvokedUrlCommand*)command {
    [self handleUnsupportedApiCall:NSStringFromSelector(_cmd) withCommand:command];
}

- (void)getAppPermissions:(CDVInvokedUrlCommand*)command {
 
    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] getAppPermissionsWithHandler:^(NSArray *permissionsArray, NSString *error) {
        
        CDVPluginResult* pluginResult = nil;
        if (!error) {
            NSArray *appPermissions = permissionsArray;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:appPermissions];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
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
    
    [[NeuraSDK sharedInstance] getMissingDataForEvent:eventName
                                          withHandler:^(NSDictionary *responseData, NSString *error) {
                                              
                                              [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                             withFormat:@"ResponseData: [%@], Error:[%@]", responseData, error];
                                              if(!error && responseData) {
                                                  if([responseData[kStatus] isEqualToString:kSuccess]) {
                                                      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
                                                  } else {
                                                      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:NO];
                                                  }
                                              } else {
                                                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
                                              }
                                              
                                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                          }];
}


- (void)getKnownDevices:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] getSupportedDevicesListWithHandler:^(NSDictionary *responseData, NSString *error) {
        
        CDVPluginResult* pluginResult = nil;
        if(!error && responseData) {
            NSArray *list = [responseData[kDevices] valueForKey:kName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:list];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

}

- (void)getKnownCapabilities:(CDVInvokedUrlCommand*)command {
 
    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] getSupportedCapabilitiesListWithHandler:^(NSDictionary *responseData, NSString *error) {

        CDVPluginResult* pluginResult = nil;
        if(!error && responseData) {
            NSArray *list = [responseData[kItems] valueForKey:kName];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:list];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)hasDeviceWithCapability:(CDVInvokedUrlCommand*)command {

    [self logCalledApi:NSStringFromSelector(_cmd)];
    __block CDVPluginResult* pluginResult = nil;
    NSString *capability = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    if(capability.length == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:kNeuraSdkError_Invalid_Arguments];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    [[NeuraSDK sharedInstance] hasDeviceWithCapability:capability
                                           withHandler:^(NSDictionary *responseData, NSString *error) {

                                               CDVPluginResult* pluginResult = nil;
                                               if(!error && responseData) {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseData[kStatus]];
                                               } else {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
                                               }
                                               [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                           }];
}


- (void)addDevice:(CDVInvokedUrlCommand*)command {
    
    [self logCalledApi:NSStringFromSelector(_cmd)];
    [[NeuraSDK sharedInstance] addDeviceWithCapability:nil
                                            deviceName:nil
                                           withHandler:^(NSDictionary *responseData, NSString *error) {
                                               
                                               CDVPluginResult* pluginResult = nil;
                                               [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                              withFormat:@"ResponseData:[%@] \nError:[%@]", responseData, error];
                                               if(!error) {
                                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseData[kStatus]];
                                               } else {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
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

    [[NeuraSDK sharedInstance] addDeviceWithCapability:capability
                                            deviceName:nil
                                           withHandler:^(NSDictionary *responseData, NSString *error) {
                                               
                                               CDVPluginResult* pluginResult = nil;
                                               [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                              withFormat:@"ResponseData:[%@] \nError:[%@]", responseData, error];
                                               if(!error && responseData) {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseData[kStatus]];
                                               } else {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
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
    
    [[NeuraSDK sharedInstance] addDeviceWithCapability:nil
                                            deviceName:deviceName
                                           withHandler:^(NSDictionary *responseData, NSString *error) {
                                               
                                               CDVPluginResult* pluginResult = nil;
                                               [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                              withFormat:@"ResponseData:[%@] \nError:[%@]", responseData, error];
                                               if(!error && responseData) {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseData[kStatus]];
                                               } else {
                                                   pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
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
    [[NeuraSDK sharedInstance] getUserSituationForTimeStamp:dateTs
                                                 contextual:NO
                                                withHandler:^(NSDictionary *responseData, NSString *error) {
                                                    
                                                    CDVPluginResult* pluginResult = nil;
                                                    [self logStringFromMethod:NSStringFromSelector(_cmd)
                                                                   withFormat:@"ResponseData:[%@] \nError:[%@]", responseData, error];

                                                    if(!error && [responseData[kStatus] isEqualToString:kSuccess]) {
                                                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseData];
                                                    } else {
                                                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
                                                    }
                                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                 }];
}

@end

