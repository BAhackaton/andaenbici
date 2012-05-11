//
//  EstacionDetailViewController.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Estacion.h"


@interface EstacionDetailViewController : UIViewController {

    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *availability;
}

@property(nonatomic,retain) Estacion* estacion;

@end
