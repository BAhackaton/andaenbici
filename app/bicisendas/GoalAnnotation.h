//
//  SelfPositionAnnotation.h
//  pemex
//
//  Created by Matias Santiago Pan on 5/2/11.
//  Copyright 2011 Nasa Trained Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GoalAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
}

@end