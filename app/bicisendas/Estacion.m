//
//  Estacion.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Estacion.h"


@implementation Estacion
@synthesize name, availability;

- (Estacion*) initWithName: (NSString*) name availability: (int) availability {
    self.name = name;
    self.availability = [NSNumber numberWithInt:availability];
    return self;
}


@end
