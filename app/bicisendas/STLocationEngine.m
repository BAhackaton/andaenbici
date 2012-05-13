//
//  STLocationEngine.m
//  pemex
//
//  Created by Matias Santiago Pan on 5/2/11.
//  Copyright 2011 Nasa Trained Monkeys. All rights reserved.
//

#import "STLocationEngine.h"
#import "SynthesizeSingleton.h"

STLocationEngine *sharedEngine;

@implementation STLocationEngine

@synthesize address,reverseGeocoder,fixedLocationMode, timer;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(STLocationEngine);


//Debug only
- (void)updateLocationTestAction{
    CLLocation *location = [[CLLocation alloc] initWithLatitude: -34.654984 longitude:-99.125000];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:19.63068000 longitude:-99.428001];
    [self locationManager:locationManager didUpdateToLocation:location fromLocation:newLocation];
    [location release];
    [newLocation release];
}

- (void)updateLocationTest:(NSTimer*)theTimer{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:19.43064000 longitude:-99.125000];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:19.63068000 longitude:-99.428001];
    [self locationManager:locationManager didUpdateToLocation:location fromLocation:newLocation];
    [location release];
    [newLocation release];
}

- (id) init {    
    if ((self = [super init])) {
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = 10;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
        locationManager.delegate = self;       
        deviceLocation = nil;
        currentHeading = nil;
        address = nil;
		
		locationServicesEnabledByUser = YES;
        
        locationChangeObservers = [[NSMutableArray alloc] init];
        fixedLocationMode = NO;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = 19.43064;
        coordinate.longitude = -99.125;
        // fixedLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        didWarnAboutOutsideMexico = NO;
        
        //Prod
        [locationManager startUpdatingLocation];
        //Debug
        [self updateLocationTestAction];
        
        //debug only
        //timer = [NSTimer scheduledTimerWithTimeInterval: 100.0 target:self selector:@selector(updateLocationTest:) userInfo:nil repeats: YES];
    }
    return self;
}

- (void)dealloc {
    [reverseGeocoder release];
    locationManager.delegate = nil;
    [locationManager release];
    
    if (deviceLocation != nil) {
        [deviceLocation release];
    }
    
    [locationChangeObservers removeAllObjects];
    [locationChangeObservers release];
    
    [super dealloc];
}
		 
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    CLLocationDirection diference = newHeading.trueHeading - currentHeading.trueHeading;
    
    if (diference > 5 || diference < -5 ) {
        
        if (currentHeading != nil) {
            [currentHeading release];
        }
        currentHeading = newHeading;
        [currentHeading retain];
        
        //[locationChangeObservers makeObjectsPerformSelector:@selector(currentHeadingDidChange)];
        for (id object in locationChangeObservers){
            if ([object respondsToSelector:@selector(currentHeadingDidChange)]) {
                NSInvocation *currentHeadingDidChangeInvocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:@selector(currentHeadingDidChange)]];
                [currentHeadingDidChangeInvocation setSelector:@selector(currentHeadingDidChange)];
                [currentHeadingDidChangeInvocation setTarget: object];
                [currentHeadingDidChangeInvocation invokeWithTarget:object];
            }
        }

    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	
	return locationServicesEnabledByUser;
}
    
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //is the change in position significant or not? check the distance for that
    CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
    
    NSLog(@"old %@ location %f,%f", oldLocation, oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //Aprox 25 meters of tolerance
    if (oldLocation == nil || distance > 10) { //significant change, update position
        if (deviceLocation != nil) {
            [deviceLocation release];
        }
        deviceLocation = newLocation;
        [deviceLocation retain];

        //[locationChangeObservers makeObjectsPerformSelector:@selector(currentPositionDidChange)];
        for (id object in locationChangeObservers){
            if ([object respondsToSelector:@selector(currentPositionDidChange)]) {
                NSInvocation *currentPositionDidChangeInvocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:@selector(currentPositionDidChange)]];
                [currentPositionDidChangeInvocation setSelector:@selector(currentPositionDidChange)];
                [currentPositionDidChangeInvocation setTarget: object];
                [currentPositionDidChangeInvocation invokeWithTarget:object];
            }
        }
        
        if(address == nil){
            self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:[self currentPosition]] autorelease];
            reverseGeocoder.delegate = self;
            [reverseGeocoder start];    
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location error %@", [error localizedDescription]);
	if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
        // The user denied your app access to location information.
		locationServicesEnabledByUser = NO;
        [[STLocationEngine sharedInstance] setFixedLocationMode:YES];
    }
}

- (BOOL)hasCurrentPosition{
    return (deviceLocation != nil && [locationManager locationServicesEnabled]);
}

- (CLLocationCoordinate2D)currentPosition {
    //Solo para debug

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = -34.654984;
    coordinate.longitude = -58.379806;
    return coordinate;


    if (deviceLocation && !fixedLocationMode) {
        //NSLog(@"Current Location: %f,%f",deviceLocation.coordinate.latitude, deviceLocation.coordinate.longitude);
        return deviceLocation.coordinate;
    } else {
        //NSLog(@"NO HAY POSICION DE USUARIO DEVUELVO LA FIXED: %f,%f",fixedLocation.coordinate.latitude, fixedLocation.coordinate.longitude);
        return fixedLocation.coordinate;
    }
}

- (CLLocationDegrees)currentFacing {
    return 0;
}

- (NSString*) currentLocationReversed{
    NSArray *formattedAddress = [self.address objectForKey:@"FormattedAddressLines"];
    if (formattedAddress)
        return [NSString stringWithFormat:@"%@, %@",[formattedAddress objectAtIndex:0], [formattedAddress objectAtIndex:1]];
    else
        return nil;
}

- (CLLocationDirection)currentDirection{
    return currentHeading.trueHeading;
}

- (void) forceStop {
    [locationManager stopUpdatingLocation];
    [locationManager stopUpdatingHeading];    
}

- (void) startOrStopLocation {
    if((locationChangeObservers.count > 0) && !fixedLocationMode) {
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
    } else {
        [self forceStop];
    }
}

- (void) addLocationChangeObserver:(id) observer {
    [locationChangeObservers addObject:observer];
    [self startOrStopLocation];
}

- (void) removeLocationChangeObserver:(id) observer {
    [locationChangeObservers removeObject:observer];
    [self startOrStopLocation];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //Do Nothing
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    self.address = placemark.addressDictionary;
    if(! [@"AR" isEqualToString:placemark.countryCode] && !didWarnAboutOutsideMexico) {
        didWarnAboutOutsideMexico = YES;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Anda en Bici" message:@"Por el momento nuestra aplicación no cuenta con información sobre recorridos fuera del territorio de Argentina" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    NSLog(@"New adress %@",self.address);
    for (id object in locationChangeObservers){
        if ([object respondsToSelector:@selector(currentAddressDidChange)]) {
            NSInvocation *currentAddressDidChangeInvocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:@selector(currentAddressDidChange)]];
            [currentAddressDidChangeInvocation setSelector:@selector(currentAddressDidChange)];
            [currentAddressDidChangeInvocation setTarget: object];
            [currentAddressDidChangeInvocation invokeWithTarget:object];
        }
    }
}

- (void)setFixedLocationWithCoordinate:(CLLocationCoordinate2D)newCoordinate{
    
    if (fixedLocation != nil) {
        [fixedLocation release];
    }
    fixedLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    //[fixedLocation retain];
    self.fixedLocationMode = YES;
}


- (void)setFixedLocationMode:(BOOL)newFixedLocationMode{
    fixedLocationMode = newFixedLocationMode;
    [self startOrStopLocation];

    [self.reverseGeocoder cancel];
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:[self currentPosition]] autorelease];
    NSLog(@"retain count: %d",[self.reverseGeocoder retainCount]);
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}


#define EARTH_RADIUS 6371000.0
#define NORTH_EAST_DIRECTION 3.14159*0.25
#define SOUTH_WEST_DIRECTION 3.14159*1.25

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};

- (CLLocationCoordinate2D)northEastLimitWithDistance:(NSInteger)distance{
    CGFloat distanceFloat = 0.0;
    distanceFloat += distance;
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D currentCoordinate = [self currentPosition];

    CGFloat latitude1 = DegreesToRadians(currentCoordinate.latitude);
    //CGFloat longitude1 = DegreesToRadians(currentCoordinate.longitude);
    
    
    CGFloat latitude2 = asin( (sin(latitude1) * cos(distanceFloat/EARTH_RADIUS)) + 
                         (cos(latitude1) * sin(distanceFloat/EARTH_RADIUS) * cos(NORTH_EAST_DIRECTION)));

    CGFloat longitude2 = currentCoordinate.longitude + RadiansToDegrees(atan2( (sin(NORTH_EAST_DIRECTION)* sin(distanceFloat/EARTH_RADIUS) * cos(latitude1)),( 
                                 cos(distanceFloat/EARTH_RADIUS) - sin(latitude1) * sin(latitude2))));

    coordinate.latitude = RadiansToDegrees(latitude2);
    coordinate.longitude = longitude2;
    return coordinate;
}

- (CLLocationCoordinate2D)southWestLimitWithDistance:(NSInteger)distance{
    CGFloat distanceFloat = 0.0;
    distanceFloat += distance;
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D currentCoordinate = [self currentPosition];
    
    CGFloat latitude1 = DegreesToRadians(currentCoordinate.latitude);
    //CGFloat longitude1 = DegreesToRadians(currentCoordinate.longitude);
    
    CGFloat latitude2  = asin( (sin(latitude1) * cos(distanceFloat/EARTH_RADIUS)) + 
                                                (cos(latitude1) * sin(distanceFloat/EARTH_RADIUS) * cos(SOUTH_WEST_DIRECTION)));
    
    CGFloat longitude2 = currentCoordinate.longitude + RadiansToDegrees(atan2( sin(SOUTH_WEST_DIRECTION)* sin(distanceFloat/EARTH_RADIUS)* cos(latitude1), 
                                                               cos(distanceFloat/EARTH_RADIUS)- sin(latitude1)* sin(latitude2)));
    
    coordinate.latitude = RadiansToDegrees(latitude2);
    coordinate.longitude = longitude2;
    return coordinate;
}


@end