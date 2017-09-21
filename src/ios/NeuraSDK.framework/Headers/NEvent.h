//
//  NeuraEvent.h
//  NeuraSDK
//
//  Created by Neura on 30/11/2016.
//  Copyright © 2016 Neura. All rights reserved.
//
#import "NeuraAPIObject.h"

/**
 An object representing a Neura event.
 */
@interface NEvent : NeuraAPIObject

/**
 The name of the event.
 */
@property (nonnull, nonatomic, readonly) NSString *name;

/**
 The Neura Id of the event.
 */
@property (nonnull, nonatomic, readonly) NSString *neuraId;

/**
 A description of the event.
 */
@property (nonnull, nonatomic, readonly) NSString *aDescription;

/**
 The display name of the event.
 */
@property (nonnull, nonatomic, readonly) NSString *displayName;

/**
 The default text used in notifications of subscriptions related to this events.
 */
@property (nonnull, nonatomic, readonly) NSString *defaultNotificationText;

/**
 The default text used in push notifications of subscriptions related to this events.
 */
@property (nonnull, nonatomic, readonly) NSString *pushNotificationText;

/**
 Given an array of dictionaries with info about events, returns an array of event objects.
 
 @param info An array of dictionaries with info about events.
 @return An array of NEvent objects.
 */
+(nonnull NSArray <NEvent *> *)listFromInfo:(nullable NSArray *)info;


/**
 The type of the feedback.

 - NFeedbackTypeApproved: Positive feedback.
 - NFeedbackTypeRejected: Negative feedback.
 - NFeedbackTypeAcknowledge: Just acknowledging that the event was received.
 */
typedef NS_ENUM(NSUInteger, NFeedbackType) {
    NFeedbackTypeApproved,
    NFeedbackTypeRejected,
    NFeedbackTypeAcknowledge
};

@end
