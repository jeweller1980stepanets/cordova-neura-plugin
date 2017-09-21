//
//  NEvent+NEventName.h
//  NeuraSDK
//
//  Created by Neura on 06/07/2017.
//  Copyright © 2017 Neura. All rights reserved.
//
#import "NEvent.h"

/**
 Moments / Events names
 - NEventNameUndefined: Undefined value
 - NEventNameUserArrivedAtActiveZone: User arrived at active zone
 - NEventNameUserArrivedAtAirport: User arrived at airport
 - NEventNameUserArrivedAtCafe: User arrived at cafe
 - NEventNameUserArrivedAtClinic: User arrived at clinic
 - NEventNameUserArrivedAtGroceryStore: User arrived at grocery store
 - NEventNameUserArrivedAtHospital: User arrived at hospital
 - NEventNameUserArrivedAtPharmacy: User arrived at pharmacy
 - NEventNameUserArrivedAtRestaurant: User arrived at restaurant
 - NEventNameUserArrivedAtSchoolCampus: User arrived at school campus
 - NEventNameUserArrivedHome: User arrived home
 - NEventNameUserArrivedHomeByRunning: User arrived home by running
 - NEventNameUserArrivedHomeByWalking: User arrived home by walking
 - NEventNameUserArrivedHomeFromWork: User arrived home from work
 - NEventNameUserArrivedToGym: User arrived to the gym
 - NEventNameUserArrivedToWork: User arrive to work
 - NEventNameUserArrivedToWorkByRunning: User arrived to work by running
 - NEventNameUserArrivedToWorkByWalking: User arrive to work by walking
 - NEventNameUserArrivedWorkFromHome: User arrived to work from home
 - NEventNameUserFinishedDriving: User finished driving
 - NEventNameUserFinishedRunning: User finished running
 - NEventNameUserFinishedTransitByWalking: User finished transit by walking
 - NEventNameUserFinishedWalking: User finished walking
 - NEventNameUserFinishedWorkOut: User finished workout
 - NEventNameUserGotUp: User got up
 - NEventNameUserIsAboutToGoToSleep: User is about to go to sleep
 - NEventNameUserIsIdleAtHome: User is idle at home
 - NEventNameUserIsIdleFor1Hour: User is idle for an hour
 - NEventNameUserIsIdleFor2Hours: User idle for two hours
 - NEventNameUserIsOnTheWayHome: User is on the way home
 - NEventNameUserIsOnTheWayToActiveZone: User is on the to active zone
 - NEventNameUserIsOnTheWayToWork: User is on the way to work
 - NEventNameUserLeftActiveZone: User left active zone
 - NEventNameUserLeftAirport: User left airport
 - NEventNameUserLeftCafe: User left cafe
 - NEventNameUserLeftGroceryStore: User left grocery store
 - NEventNameUserLeftGym: User left gym
 - NEventNameUserLeftHome: User left home
 - NEventNameUserLeftHospital: User left hospital
 - NEventNameUserLeftPharmacy: User left pharmacy
 - NEventNameUserLeftRestaurant: User left restaurant
 - NEventNameUserLeftSchoolCampus: User left school campus
 - NEventNameUserLeftWork: User left work
 - NEventNameUserStartedDriving: User started driving
 - NEventNameUserStartedRunning: User started running
 - NEventNameUserStartedRunningFromPlace: User started running from place
 - NEventNameUserStartedSleeping: User started sleeping
 - NEventNameUserStartedTransitByWalking: User started transit by walking
 - NEventNameUserStartedWalking: User started walking
 - NEventNameUserStartedWorkOut: User started workout
 - NEventNameUserWokeUp: User woke up
 */
typedef NS_ENUM(NSUInteger, NEventName) {
    NEventNameUndefined,
    NEventNameUserFinishedRunning,
    NEventNameUserFinishedWalking,
    NEventNameUserStartedWalking,
    NEventNameUserFinishedDriving,
    NEventNameUserStartedDriving,
    NEventNameUserStartedTransitByWalking,
    NEventNameUserStartedRunning,
    NEventNameUserFinishedTransitByWalking,
    NEventNameUserStartedWorkOut,
    NEventNameUserFinishedWorkOut,
    NEventNameUserStartedSleeping,
    NEventNameUserIsIdleFor2Hours,
    NEventNameUserWokeUp,
    NEventNameUserIsIdleFor1Hour,
    NEventNameUserGotUp,
    NEventNameUserIsIdleAtHome,
    NEventNameUserArrivedToWorkByRunning,
    NEventNameUserArrivedHomeByWalking,
    NEventNameUserArrivedHomeByRunning,
    NEventNameUserArrivedToWorkByWalking,
    NEventNameUserLeftGym,
    NEventNameUserArrivedHome,
    NEventNameUserArrivedHomeFromWork,
    NEventNameUserArrivedToGym,
    NEventNameUserArrivedToWork,
    NEventNameUserLeftHome,
    NEventNameUserArrivedWorkFromHome,
    NEventNameUserArrivedAtActiveZone,
    NEventNameUserLeftWork,
    NEventNameUserArrivedAtGroceryStore,
    NEventNameUserLeftActiveZone,
    NEventNameUserArrivedAtSchoolCampus,
    NEventNameUserArrivedAtAirport,
    NEventNameUserArrivedAtClinic,
    NEventNameUserArrivedAtCafe,
    NEventNameUserArrivedAtRestaurant,
    NEventNameUserArrivedAtHospital,
    NEventNameUserLeftSchoolCampus,
    NEventNameUserLeftCafe,
    NEventNameUserLeftHospital,
    NEventNameUserLeftRestaurant,
    NEventNameUserLeftAirport,
    NEventNameUserArrivedAtPharmacy,
    NEventNameUserLeftPharmacy,
    NEventNameUserLeftGroceryStore,
    NEventNameUserIsOnTheWayToActiveZone,
    NEventNameUserIsAboutToGoToSleep,
    NEventNameUserIsOnTheWayHome,
    NEventNameUserIsOnTheWayToWork,
    NEventNameUserStartedRunningFromPlace,
};


@interface NEvent (NEventName)


/**
 Provided an NEventName returns the related event name as string.

 @param name NEVentName
 @return NSString if a recognized event (nil otherwise).
 */
+(NSString *)stringForEventName:(NEventName)name;


/**
 Provided a name of an event as string, returns the related NEventName value.

 @param name The name of the event as NSString (the string is case sensitive)
 @return NEventName of the recognized event name (will return NEventNameUndefined if unrecognized string provided as the name).
 */
+(NEventName)enumForEventName:(NSString *)name;

@end
