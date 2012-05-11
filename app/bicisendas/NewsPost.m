//
//  NewsPost.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsPost.h"


@implementation NewsPost

@synthesize title, description, url;

- (id) initWithTitle:(NSString*)aTitle description:(NSString*)aDescription url: (NSString*)aUrl {
    
    self.title = aTitle;
    self.description = aDescription;
    self.url = aUrl;
    
    return self;
}


@end
