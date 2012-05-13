//
//  SelfPositionAnnotationView.m
//  pemex
//
//  Created by Matias Santiago Pan on 5/2/11.
//  Copyright 2011 Nasa Trained Monkeys. All rights reserved.
//

#import "OwnPositionAnnotationView.h"


@implementation OwnPositionAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"map_annotation_self"];
        internalView = [[UIImageView alloc] initWithImage:img];
        
        internalView.frame = CGRectMake(internalView.frame.size.width/-2, internalView.frame.size.height/-2,internalView.frame.size.width,internalView.frame.size.height);
        [self addSubview:internalView];
        self.canShowCallout = YES;
    }
    return self;
}



@end
