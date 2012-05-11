//
//  EstacionesViewController.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstacionesViewController.h"
#include <stdlib.h>

@implementation EstacionesViewController

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    if (!detailView) {
        detailView = [[EstacionDetailViewController alloc] initWithNibName:@"EstacionDetail" bundle:[NSBundle mainBundle]];
    }
    
    detailView.estacion = [[Estacion alloc] initWithName:[view.annotation title] availability:20];
    
    [self.navigationController pushViewController: detailView animated:TRUE];
    
}

@end
