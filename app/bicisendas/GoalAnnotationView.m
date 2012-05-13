//
//  GoalAnnotationView.m
//  andaenbici
//
//  Created by Dario Miñones on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoalAnnotationView.h"

@implementation GoalAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"map_annotation_goal"];
        UIView *internalView = [[UIImageView alloc] initWithImage:img];
        
        internalView.frame = CGRectMake(internalView.frame.size.width/-2, internalView.frame.size.height/-2,internalView.frame.size.width,internalView.frame.size.height);
        [self addSubview:internalView];
        self.canShowCallout = YES;
    }
    return self;
}



@end