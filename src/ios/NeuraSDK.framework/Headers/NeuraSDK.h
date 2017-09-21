/**
 *  NeuraSDK.h
 *  NeuraSDK
 *
 *  Created by Gal Mirkin on 8/20/15.
 *  Copyright (c) 2015 Neura. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "NeuraSdkConfiguration.h"
#import "NeuraSDKAPIAvailability.h"
#import "NeuraSDKAPIResults.h"
#import "NeuraSDKAPIRequests.h"
#import "NeuraSDKPushNotification.h"
#import "NeuraAuthenticationStateDelegate.h"

#pragma mark - New Public API
/**
NeuraSDK API Version 3
*/
@interface NeuraSDK: NSObject

#pragma mark -- Shared Instance
/** @name Shared Instance */

#if FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
/** shared class property
 
 The same as [NeuraSDK sharedInstance].
 This is just a convenience class property for shorter syntax under Swift 3.0+
 
 Starting Swift 3.0+
 Instead of : NeuraSDK.sharedInstance()?.someMethodName()
 You can just use: NeuraSDK.shared.someMethodName()
 */
@property (class, nonatomic, readonly, nonnull) NeuraSDK *shared;
#endif

/** The shared instance of the SDK.
    Must be placed in the AppDelegate on applicationDidFinishLaunchingWithOptions */
+ (nullable NeuraSDK *)sharedInstance;

#pragma mark -- Application identifiers
/** @name Application identifiers */

/** the App UID from the Neura dev site */
@property (atomic, strong, nullable) NSString *appUID;

/** the App Secret from the Neura dev site */
@property (atomic, strong, nullable) NSString *appSecret;

#pragma mark - SDK Info
/** @name SDK Info */

/**
 *  get the sdk version
 *
 *  @return version string
 */
- (nullable NSString *)getVersion;

#pragma mark - App Permissions
/** @name App Permissions */

/**
 *  use to get the app permissions list
 *
 *  This call is asynchronous.
 *  The result handler will provide the list of permissions as an array of Permission objects.
 *
 *  @param callback PermissionsListCallback returning the NeuraPermissionsListResult.
 */
- (void)getAppPermissionsListWithCallback:(nonnull NeuraPermissionsListCallback)callback;

#pragma mark - Authentication
/** @name Authentication */
@property (nonatomic, weak, nullable) id<NeuraAuthenticationStateDelegate>authenticationStateDelegate;


/**
 Get the current authentication state.
 See: NeuraAuthState for all possible values and meaning.

 @return NeuraAuthState of the current authentication state.
 */
- (NeuraAuthState)authenticationState;


/**
 Returns true if the app was already authenticated successfully
 (access token was already received successfully)
 
 @return BOOL - YES if already authenticated and appToken is available. NO otherwise.
 */
- (BOOL)isAuthenticated;

/**
 An app token received on authentication.
 
 @return NSString - the application's token.
 */
- (nullable NSString *)appToken;


/**
 The (API) unique identifier of the Neura user.

 @return A string with the unique Neura identifier for this authenticated user. 
 Will return nil if the user is not signed in / authenticated.
 */
- (nullable NSString *)neuraUserId;

/**
 Use to logout from Neura

 @param callback callbak NeuraLogoutCallback returning the NeuraLogoutResult.
 */
- (void)logoutWithCallback:(nonnull NeuraLogoutCallback)callback;

/**
 Use to authenticate the app.
 There are a few possible authentication flows and configurations.
 @see: NeuraAuthenticationRequest for more details.
 
 @param request (optional) NeuraAuthenticationRequest the authentication configuration object. Pass nil to use the default configuration.
 @param callback NeuraAuthenticateCallback returning a NeuraAuthenticationResult object.
 */
- (void)authenticateWithRequest:(nullable NeuraBaseAuthenticationRequest *)request
                       callback:(nonnull NeuraAuthenticateCallback)callback;

#pragma mark - List of events
- (void)getEventsListWithCallback:(nonnull NeuraEventsListResultCallback)callback;


#pragma mark - Subscriptions
/** @name Subscriptions */

/**
 Get a list of current subscriptions.
 
 @param callback NeuraSubscriptionsListCallback returning a NeuraSubscriptionsListResult.
 */
- (void)getSubscriptionsListWithCallback:(nonnull NeuraSubscriptionsListCallback)callback;

/**
 Subscribe to an event using a NSubscription object.
 
 @param subscription NSubscription object. Must provide eventName and identifier. webHookId is optional.
 @param callback NeuraAddSubscriptionCallback - a callback returning the result of this subscribe request.
 */
- (void)addSubscription:(nonnull NSubscription *)subscription
               callback:(nonnull NeuraAddSubscriptionCallback)callback;

/**
 Remove subscription (given a NSubscription object)
 
 @param subscription NSubscription - the subscription object.
 @param callback NeuraRemoveSubscriptionCallback - a callback returning the result of this remove subscription request.
 */
- (void)removeSubscription:(nonnull NSubscription *)subscription
                  callback:(nonnull NeuraRemoveSubscriptionCallback)callback;

/**
 Remove subscription (given a subscription identifier)
 
 @param identifier NSString - the unique subscription identifier.
 @param callback NeuraRemoveSubscriptionCallback - a callback returning the result of this remove subscription request.
 */
- (void)removeSubscriptionWithIdentifier:(nonnull NSString *)identifier
                                callback:(nonnull NeuraRemoveSubscriptionCallback)callback;


#pragma mark - Feedback
/** @name Feedback */

- (void)sendFeedbackForEventId:(nonnull NSString *)neuraID
                      approved:(BOOL)approved
                      callback:(nonnull NeuraEventFeedbackCallback)callback DEPRECATED_NEURA_API("Deprecated. Please use sendFeedbackForEventId:feedback:callback");;


/**
 Send feedback for an event.

 @param neuraID The id of the event.
 @param feedback NFeedbackType the type of the feedback (positive, negative, ack)
 @param callback NeuraEventFeedbackCallback callback
 */
- (void)sendFeedbackForEventId:(nonnull NSString *)neuraID
                      feedback:(NFeedbackType)feedback
                      callback:(nonnull NeuraEventFeedbackCallback)callback;


#pragma mark - Missing Data
/** @name Missing Data */

/**
 *  Use to check if the event has all the required data
 *
 *  @param eventName event to check if all the require fields exists.
 *
 *  @return false if the event has all the require data in it
 */
- (BOOL)isMissingDataForEvent:(nullable NSString *)eventName;

/**
 Use to get the missing data for the required event to subscribe

 @param eventName eventName the event with the missing data
 @param callback NeuraMissingDataForEventCallback returning the NeuraAPIResult
 */
- (void)getMissingDataForEvent:(nonnull NSString *)eventName
                  withCallback:(nonnull NeuraMissingDataForEventCallback)callback;


#pragma mark - Devices & Capabilities
/** @name Devices, User & Capabilities */

/**
 *  get all the supported devices Neura has to offer.
 *
 * @param callback NeuraSupportedDevicesListCallback - a callback returning the NeuraSupportedDevicesListResult.
 */
- (void)getSupportedDevicesListWithCallback:(nonnull NeuraSupportedDevicesListCallback)callback;


/**
 * get all the supported capabilities for devices.
 *
 * @param callback NeuraSupportedCapabilitiesListCallback - a callback returning the NeuraSupportedCapabilitiesListResult.
 */
- (void)getSupportedCapabilitiesListWithCallback:(nonnull NeuraSupportedCapabilitiesListCallback)callback;


/**
 *  check if user has a device with the provided capability.
 *
 *  @param capability NCapability object as can be fetched from (getSupportedCapabilitiesListWithCallback)
 *  @param callback NeuraHasDeviceWithCapabilityCallback - a callback returning the NeuraHasDeviceWithCapabilityResult.
 */
- (void)hasDeviceWithCapability:(nullable NCapability *)capability
                   withCallback:(nullable NeuraHasDeviceWithCapabilityCallback)callback;


/**
 *  Add a device from a list, selected by the user.
 *
 *  @param callback NeuraAddDeviceCallback - a callback returning the NeuraAddDeviceResult.
 */
- (void)addDeviceWithCallback:(nonnull NeuraAddDeviceCallback)callback;

/**
 *  Add a device with the provided name.
 *
 *  @param deviceName The name of the device type to add.
 *  @param callback NeuraAddDeviceCallback - a callback returning the NeuraAddDeviceResult.
 */
- (void)addDeviceNamed:(nonnull NSString *)deviceName
          withCallback:(nonnull NeuraAddDeviceCallback)callback;


/**
 *  Add a device that has the named capability.
 *  Will show a user interface with a list of all devices that have such a capability, allowing user to choose a device to add.
 *
 *  @param capabilityName A name of a capability
 *  @param callback NeuraAddDeviceCallback - a callback returning the NeuraAddDeviceResult.
 */
- (void)addDeviceWithCapabilityNamed:(nonnull NSString *)capabilityName
                        withCallback:(nonnull NeuraAddDeviceCallback)callback;

/**
 Add a place with the provided properties.

 @param place NPlace object. Must provide label. latitude, longitude, address and name are optional
 @param callback NeuraAddPlaceCallback - a callback returning the NeuraAddPlaceResult.
 */
- (void)addPlace:(nonnull NPlace *)place withCallback:(nonnull NeuraAddPlaceCallback)callback;

/**
 Remove a place with the neuraId of a place
 */
- (void)removePlace:(nonnull NSString *)neuraId withCallback:(nonnull NeuraRemovePlaceCallback)callback;
 

#pragma mark - User
/** @name User */

/**
 Get a collection of states for a user at a given timestamp.
 @see For more info see [SDK docs - Insights](https://dev.theneura.com/docs/api/insights#situation)
 
 @param timeStamp Required. The timestamp for when you want to get the user's situation
 @param contextual In order to get more data about the situation, like previous and next situations. Default: false
 @param callback NeuraGetUserSituationCallback - a callback returning the NeuraGetUserSituationResult
 */
- (void)getUserSituationForTimeStamp:(nonnull NSDate *)timeStamp
                          contextual:(BOOL)contextual
                            callback:(nonnull NeuraGetUserSituationCallback)callback;

/**
 Get the user's wellness information for a single day.
 @see For more info see [SDK docs - Insights](https://dev.theneura.com/docs/api/insights#summary)

 @param date Required. The date for the day you'll get the daily summary for
 @param callback callback NeuraGetInsightInfoCallback - a callback returning the NeuraGetInsightInfoResult
 */
- (void)getSemanticDaySummaryForDate:(nonnull NSDate *)date
                            callback:(nonnull NeuraGetInsightInfoCallback)callback;

/**
 Get the user's sleep information during a period of time.
 @see For more info see [SDK docs - Insights](https://dev.theneura.com/docs/api/insights#sleep)

 @param startDate Required. Day of beginning of the sleep information
 @param endDate <#endDate description#>
 @param callback callback NeuraGetInsightInfoCallback - a callback returning the NeuraGetInsightInfoResult
 */
- (void)getSleepProfileForStartDate:(nonnull NSDate*)startDate
                            endDate:(nonnull NSDate*)endDate
                            callback:(nonnull NeuraGetInsightInfoCallback)callback;

/**
 Get the user's wellness information during a period of time.
 @see For more info see [SDK docs - Insights](https://dev.theneura.com/docs/api/insights#wellness)

 @param startDate Required. Day of beginning of the sleep information
 @param endDate Required. Day of end of the sleep information inclusive
 @param callback callback NeuraGetInsightInfoCallback - a callback returning the NeuraGetInsightInfoResult
 */
- (void)getWellnessLifestyleProfileForStartDate:(nonnull NSDate*)startDate
                                        endDate:(nonnull NSDate*)endDate
                                       callback:(nonnull NeuraGetInsightInfoCallback)callback;

/**
 Get the user's activity information for the place he was at the provided timestamp.
 @see For more info see [SDK docs - Insights](https://dev.theneura.com/docs/api/insights#activity)
 
 @param timeStamp Required. The timestamp for when you want to get the user's activity
 @param resources Required. Array containing the type of data you want to receive. Possible resources are steps and calories. The array Must contain at least one
 @param callback callback NeuraGetInsightInfoCallback - a callback returning the NeuraGetInsightInfoResult
 */
- (void)getActivityProfileAtPlaceForTimeStamp:(nonnull NSDate*)timeStamp
                                    resources:(nonnull NSArray<NSString*> *)resources
                            callback:(nonnull NeuraGetInsightInfoCallback)callback;

/**
 *  Use to open neura settings panel UI.
 *  Shows a list of the permissions that the user approved.
 */
- (void)openNeuraSettingsPanel;


/**
 *  Use to simulate Event.
 */
- (void)simulateEvent:(NEventName)name
             callback:(void (^_Nullable)(NeuraAPIResult * _Nullable result))callback;


@end






#pragma mark - Legacy API
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

/*
 -=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~
 Older Legacy API
 ------------------------------------------------------------------------------------------------------------
 
 Deprecated API.
 Still currently available, but planned to be deprecated.
 Please use newer API in new projects and start planning refactoring existing projects as soon as possible.
 -=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~-=~
 */


/*
 *  enables sdk configuration features from NEUFeatures enum
 *
 *  This method call overrides internal SDK configuration with 'flags' parameter (collection of bitwise values).
 */
extern NSString * _Nonnull const kNeuraSDKErrorDomain;
extern NSString * _Nonnull const kNeuraSDKErrorsArrayKey;
extern NSString * _Nonnull const NeuraSDKErrorDidReceiveNotification;
#pragma clang pop
