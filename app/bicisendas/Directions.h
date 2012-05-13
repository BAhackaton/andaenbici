//
//  Directions.h
//  andaenbici
//
//  Created by Dario Miñones on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DirectionsDelegateProtocol <NSObject>
@required
- (void)didUpdateDirections:(NSArray *)directions;
@end

@interface Directions : NSObject
{
    id <DirectionsDelegateProtocol> delegate;
}

@property(nonatomic, assign) id <DirectionsDelegateProtocol> delegate;

- (void) loadWithStartPoint:(NSString*)currentLocation endPoint:(NSString*)sendPoint;
- (void)didUpdateDirections:(NSArray *)directions;

@end
