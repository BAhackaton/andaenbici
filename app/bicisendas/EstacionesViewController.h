//
//  EstacionesViewController.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapBicisendaController.h"
#import "EstacionDetailViewController.h"
#import "Estacion.h"


@interface EstacionesViewController : BaseMapBicisendaController {
    EstacionDetailViewController* detailView;
}

@end
