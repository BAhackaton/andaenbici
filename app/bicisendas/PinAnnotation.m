//
//  DirectionEndPointAnnotation.m
//  pemex
//
//  Created by Ariel Scarpinelli on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PinAnnotation.h"

@implementation PinAnnotation
@synthesize coordinate=_coordinate;
@synthesize color=_color;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andColor:(MKPinAnnotationColor) color{
    self = [super init];
    if (self != nil) {
        _coordinate = coordinate;
        _color = color;
    }
    return self;
}
@end
