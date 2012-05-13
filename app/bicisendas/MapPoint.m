//
//  MapPoint.m
//  Whereami
//
//  Created by Macbook on 01/11/10.
//  Copyright 2010 Erick Frausto. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint
@synthesize coordinate, title, subtitle, reverseGeocoder, number, street, subLocality;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
	self = [super init];
    if (self) {
        coordinate = c;
        [self setTitle:t];
	
        self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:c] autorelease];
        [reverseGeocoder setDelegate:self];
        [reverseGeocoder start];
	}
	return self;
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"Reverse Geocoder Error: %@", error);
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	[self setNumber:[placemark subThoroughfare]];
	[self setStreet:[placemark thoroughfare]];
	[self setSubLocality:[placemark subLocality]];
	
	NSString *subt = [NSString stringWithFormat:@"%@ %@, %@", [self street], [self number], [self subLocality]];
	[self setSubtitle:subt];
}


- (void)dealloc
{
	[title release];
	[subtitle release];
	[reverseGeocoder release];
	[super dealloc];
}
@end
