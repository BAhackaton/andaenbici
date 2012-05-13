//
//  SelfPositionAnnotation.m
//  pemex
//
//  Created by Matias Santiago Pan on 5/2/11.
//  Copyright 2011 Nasa Trained Monkeys. All rights reserved.
//

#import "GoalAnnotation.h"
#import "STLocationEngine.h"

@implementation GoalAnnotation

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (NSString *)title {
    return NSLocalizedString(@"Destino", "Destino");
}

@end
