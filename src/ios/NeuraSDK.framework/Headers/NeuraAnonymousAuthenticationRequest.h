//
//  NeuraAnonymousAuthenticationRequest.h
//  NeuraSDK
//
//  Created by Aviv Wolf on 24/07/2017.
//  Copyright © 2017 Neura. All rights reserved.
//

#import "NeuraBaseAuthenticationRequest.h"

@interface NeuraAnonymousAuthenticationRequest : NeuraBaseAuthenticationRequest


/**
 Helper method. Converts the NSData device token (as provided by the app's delegate didRegisterForRemoteNotificationsWithDeviceToken:) to NSString.
 This string can be used when initializing the NeuraAnonymousAuthenticationRequest.

 @param deviceToken NSData device token (as provided by the app's delegate didRegisterForRemoteNotificationsWithDeviceToken:)
 @return The token as NSString.
 */
+ (NSString *)deviceTokenStringFromData:(NSData *)deviceToken;

/**
 Helper initializer
 
 @param deviceTokenString The device token string. Used to inform Neura's servers about the device token.
                          Note: remote notifications must be available and the token must be provided for anonymous authentication to work.
 @return A new instance of the anonymous authentication request.
 */
- (instancetype)initWithDeviceTokenString:(NSString *)deviceTokenString;

/**
 Helper initializer
 
 @param deviceToken NSData device token (as provided by the app's delegate didRegisterForRemoteNotificationsWithDeviceToken:). 
        Used to inform Neura's servers about the device token.
        Note: remote notifications must be available and the token must be provided for anonymous authentication to work.
 @return A new instance of the anonymous authentication request.
 */
- (instancetype)initWithDeviceToken:(NSData *)deviceToken;

/**
 The device token (as string).
 This must be provided for anonymous authentication to work.
 (You can convert the NSData device token you receive in the app's delegate didRegisterForRemoteNotificationsWithDeviceToken: to a string
 using the helper method deviceTokenStringFromData).
 */
@property NSString *deviceTokenString;

@end
