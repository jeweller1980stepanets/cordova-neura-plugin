//
//  NeuraSdkConfiguration.h
//  NeuraSDK
//
//  Created by Genady Buchatsky on 11/08/2016.
//  Copyright © 2016 Neura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeuraSDKAPIAvailability.h"

#pragma mark - Legacy API
/** Legacy flags (This will be deprecated soon) */
typedef NS_OPTIONS(NSUInteger, NEUFeatures) {
    /** NEUSDKCustomErrorNotification */
    NEUSDKCustomErrorNotification       =(1 << 0),
    /** NEUSDKDisableSdkLogging */
    NEUSDKDisableSdkLogging             =(1 << 1)
};


/**
 A shared object used to configure the SDK.
 */
@interface NeuraSdkConfiguration : NSObject

+ (nonnull instancetype)sharedInstance;

#if FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
/** shared class property
 
 The same as [NeuraSdkConfiguration sharedInstance].
 This is just a convenience class property for shorter syntax under Swift 3.0+
 
 Starting Swift 3.0+
 Instead of : NeuraSdkConfiguration.sharedInstance()?.someMethodName()
 You can just use: NeuraSdkConfiguration.shared.someMethodName()
 */
@property (class, nonatomic, readonly, nonnull) NeuraSdkConfiguration *shared;
#endif

#pragma mark - Settings flags
/**
 * Data Logs stored and reported (enabled by default).
 * This setting is persistent.
 */
@property(nonatomic,readonly,assign) BOOL logsEnabled;

/**
 * If set, will only log tagged info that is tagged with one of these tags.
 * If set to nil, everything will be logged when logs are enabled.
 * This is cleared (set back to nil) when logs are disabled.
 */
@property(nonatomic,readonly, nullable) NSDictionary *allowedTags;

/**
 * Default notification error alerts will be displayed to the user by the SDK (enabled by default).
 * Call enableCustomErrorNotifications if you want to disable these default error alerts and handle
 * reporting errors to the user using your own custom user interface.
 */
@property(nonatomic,readonly,assign) BOOL errorNotificationsEnabled;

/**
 * If enabled (currently disabled by default) the client will inform the server that it allows
 * the server side to send silent push notifications with requests for initializing data collection processes.
 * Enabling this will also alter the default logic used in data collection.
 */
@property(nonatomic,readonly,assign) BOOL dataCollectionOnRequestEnabled;

/**
 * By default (if enableLogs or disableLogs not called) remote logs are disabled.
 * Set this to YES before calling NeuraSdkConfiguration.shared for the first time, if you want the logs to be enabled by default.
 * (this does not effect logging if changed after NeuraSDK or NeuraSdkConfiguration are initialized for the first time)
 */
#if FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
@property (class, nonatomic, readwrite) BOOL logsEnabledByDefault;
#endif

/**
 * Enable logs. This setting is persistent.
 */
- (void)enableLogs;

/**
 Enable logs only for specific tags. This setting is persistent.

 @param tags Tags
 */
- (void)enableLogsForTags:(nullable NSArray*)tags;

/**
 * Disable logs. This setting is persistent.
 */
- (void)disableLogs;

/**
 * Enable custom error notifications user interface.
 * (this will disable the default alerts shown to the user on SDK errors)
 * You may get the info about the errors and communicate them to the user by observing the XXXX notifications.
 * This setting is persistent.
 */
- (void)enableCustomErrorNotifications;

/**
 * Disable custom error notifications user interface.
 * (this will re enable the default alerts shown to the user on SDK errors)
 * This setting is persistent.
 */
- (void)disableCustomErrorNotifications;


/**
 * If enabled (currently disabled by default) the client will inform the server that it allows
 * the server side to send silent push notifications with requests for initializing data collection processes.
 * Enabling this will also alter the default logic used in data collection.
 */
- (void)enableDataCollectionOnRequest;

/**
 * Disables the mode where the server is allowed to send silent push notifications to the client with data collection related requests.
 * @see enableDataCollectionOnRequest and dataCollectionOnRequest
 */
- (void)disableDataCollectionOnRequest;

/**
 Set all configuration flags in one call.
 Deprecated on NeuraSDK 3+. Please use the enable/disable methods on NeuraSdkConfiguration.
 @param flags A flags mask.
 */
- (void)setConfigurationFlags:(NSUInteger)flags DEPRECATED_NEURA_API("Deprecated on NeuraSDK 3+. Please use the enable/disable methods on NeuraSdkConfiguration.");;

@end
