//
//  NeuraAuthenticationStateDelegate.h
//  NeuraSDK
//
//  Created by Aviv Wolf on 01/08/2017.
//  Copyright © 2017 Neura. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 NeuraAuthState - The possible authentication flow states.
 
 - NeuraAuthStateNotAuthenticated: No authenticated
 - NeuraAuthStateAccessTokenRequested: Finished authentication request successfully, but still waiting for tokens sent by push.
 - NeuraAuthStateFailedReceivingAccessToken: Failed receiving tokens by push (and tokens expired). You'll need retry authenticating.
 - NeuraAuthStateAuthenticatedAnonymously: Finished anonymous authentication and received tokens.
 - NeuraAuthStateAuthenticated: Finished authentication and received tokens.
 */
typedef NS_ENUM(NSUInteger, NeuraAuthState) {
    NeuraAuthStateNotAuthenticated,
    NeuraAuthStateAccessTokenRequested,
    NeuraAuthStateFailedReceivingAccessToken,
    NeuraAuthStateAuthenticatedAnonymously,
    NeuraAuthStateAuthenticated,
};

@protocol NeuraAuthenticationStateDelegate <NSObject>

@optional
- (void)neuraAuthStateUpdated:(NeuraAuthState)state;

@end
