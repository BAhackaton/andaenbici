//
//  Estacion.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Estacion : NSObject {
    
}

- (Estacion*) initWithName: (NSString*) name availability: (int) availability;

@property(nonatomic,copy) NSString* name;
@property(nonatomic, copy) NSNumber* availability;


@end
