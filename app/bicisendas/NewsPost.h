//
//  NewsPost.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsPost : NSObject {

    
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *url;

- (id) initWithTitle:(NSString*)title description:(NSString*)description url: (NSString*)url;

@end
