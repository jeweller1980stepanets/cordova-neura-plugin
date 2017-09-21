//
//  NeuraEventsList.h
//  NeuraSDK
//
//  Created by Neura on 03/07/2017.
//  Copyright © 2017 Neura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeuraAPIResult.h"
#import "NEvent.h"

@interface NeuraEventsListResult : NeuraAPIResult
@property (nonatomic, nonnull, readonly) NSArray<NEvent *> *eventDefinitions;

@end


typedef void (^NeuraEventsListResultCallback)(NeuraEventsListResult * _Nonnull result);
