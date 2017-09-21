//
//  NSubscription.h
//  NeuraSDK
//
//  Created by Neura on 28/11/2016.
//  Copyright © 2016 Neura. All rights reserved.
//
#import "NeuraAPIObject.h"


/**
 An object representing a subscription to an event.
 */
@interface NSubscription : NeuraAPIObject


/**
 The name of the related Neura event.
 */
@property (nonnull, nonatomic, readonly) NSString *eventName;


/**
 A unique identifier for this specific subscription.
 Note: You can have one or more subscriptions to the same event.
       Each subscription must have a different unique identifier.
 */
@property (nonnull, nonatomic, readonly) NSString *identifier;

/**
 (optional) The identifier of the related webhook.
 */
@property (nullable, nonatomic, readonly) NSString *webhookId;

/**
 The time of creation of the subscription.
 */
@property (nonnull, nonatomic, readonly) NSString *createdAt;

/**
 Meta data related to the subscription.
 */
@property (nonnull, nonatomic, readonly) NSDictionary *metadata;

/**
 The method of the subscription.
 
 webhook - if Neura's server sends the events to your server using a webhook (currently, the only supported method).
 */
@property (nonnull, nonatomic, readonly) NSString *method;


/**
 The related unique Neura identifier.
 */
@property (nullable, nonatomic, readonly) NSString *neuraId;


/**
 Enabled / disabled state.
 */
@property (nullable, nonatomic, readonly) NSString *state;


///**
// Returns YES if subscribing to events using mutable-content push messages is supported.
// If not supported, you must subscribe to the event using a webhook.
//
// @return YES if the feature is supported on the device.
// */
//+ (BOOL)isSupportingMutableContentPush;

/**
 Init subscription with provided webhook id.
 
 This call is equivelant to initWithEventName:identifier:webhookId: and the identifier is set to be the event name with an underscore as a prefix.
 
 @param eventName The name of the event the subscription is related to.
 @param webhookId A related webhook identifier.
 @return A new subscription object instance.
 */
- (nonnull instancetype)initWithEventName:(nonnull NSString *)eventName
                                webhookId:(nullable NSString *)webhookId;


/**
 Init subscription with provided identifier and webhook id.
 
 @param eventName The name of the event the subscription is related to.
 @param identifier The identifier of the subscription.
 @param webhookId A related webhook identifier.
 @return A new subscription object instance.
 */
- (nonnull instancetype)initWithEventName:(nonnull NSString *)eventName
                               identifier:(nonnull NSString *)identifier
                                webhookId:(nullable NSString *)webhookId;

@end
