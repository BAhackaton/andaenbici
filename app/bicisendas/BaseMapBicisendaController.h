//
//  BaseMapBicisendaController.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "KMLParser.h"


@interface BaseMapBicisendaController : UIViewController<MKMapViewDelegate> {

    IBOutlet MKMapView *mapView;
    KMLParser* kml;
    
}

- (NSArray*) getOverlays;
- (NSArray*) getAnnotations;

@end
