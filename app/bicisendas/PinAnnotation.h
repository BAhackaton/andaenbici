//
//  DirectionEndPointAnnotation.h
//  pemex
//
//  Created by Ariel Scarpinelli on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PinAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate; 
    MKPinAnnotationColor _color;
}

@property (nonatomic) MKPinAnnotationColor color;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andColor:(MKPinAnnotationColor) color;

@end
