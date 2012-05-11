//
//  FirstViewController.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsPost.h"
#import "NewsPostDetailsViewController.h"


@interface NovedadesViewController : UITableViewController <UITableViewDataSource, UITableViewDataSource> {
    NSMutableArray* novedades;
    NewsPostDetailsViewController* detailsView;
}

@end
