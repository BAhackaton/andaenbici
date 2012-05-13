//
//  SelfPositionAnnotation.m
//  pemex
//
//  Created by Matias Santiago Pan on 5/2/11.
//  Copyright 2011 Nasa Trained Monkeys. All rights reserved.
//

#import "OwnPositionAnnotation.h"
#import "STLocationEngine.h"

@implementation OwnPositionAnnotation

- (CLLocationCoordinate2D)coordinate {
    return [[STLocationEngine sharedInstance] currentPosition];
}

- (NSString *)title {
    return NSLocalizedString(@"Estoy aqui", "estoy aqui");
}

@end
