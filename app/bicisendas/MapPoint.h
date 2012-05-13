//
//  MapPoint.h
//  Whereami
//
//  Created by Macbook on 01/11/10.
//  Copyright 2010 Erick Frausto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface MapPoint : NSObject <MKAnnotation, MKReverseGeocoderDelegate> 
{
	NSString *title;
	NSString *subtitle;
	CLLocationCoordinate2D coordinate;
		
	MKReverseGeocoder *reverseGeocoder;
	
	NSString *number;
	NSString *street;
	NSString *subLocality;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *subLocality;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;

@end
