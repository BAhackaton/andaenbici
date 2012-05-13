//
//  STLocationEngine.h
//  pemex
//
//  Created by Matias Santiago Pan on 5/2/11.
//  Copyright 2011 Nasa Trained Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface STLocationEngine : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
    CLLocationManager *locationManager;
    CLLocation *deviceLocation;
    CLLocation *fixedLocation;
    CLHeading *currentHeading;
    NSMutableArray *locationChangeObservers;
    
    MKReverseGeocoder *reverseGeocoder;
    NSDictionary *address;
    
    BOOL fixedLocationMode;
    NSTimer *timer;
	
	BOOL locationServicesEnabledByUser;
    BOOL didWarnAboutOutsideMexico;
}
@property (nonatomic, assign) BOOL fixedLocationMode;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) NSDictionary *address;
@property (nonatomic, retain) NSTimer * timer;

+ (STLocationEngine *) sharedInstance;


- (BOOL)hasCurrentPosition;

- (CLLocationCoordinate2D)currentPosition;
- (CLLocationDegrees)currentFacing;
- (NSString*) currentLocationReversed;
- (CLLocationDirection)currentDirection;
- (void)setFixedLocationWithCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (void) addLocationChangeObserver:(id) observer;
- (void) removeLocationChangeObserver:(id) observer;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

- (CLLocationCoordinate2D)northEastLimitWithDistance:(NSInteger)distance;
- (CLLocationCoordinate2D)southWestLimitWithDistance:(NSInteger)distance;

- (void) startOrStopLocation;
- (void) forceStop;

@end
