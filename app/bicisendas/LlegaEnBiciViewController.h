//
//  LlegaEnBici.h
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseMapBicisendaController.h"
#import "UICGDirections.h"
#import "GoalAnnotation.h"
#import "GoalAnnotationView.h"
#import "PinAnnotation.h"
#import "UICRouteAnnotation.h"
#import "BSForwardGeocoder.h"
#import "Directions.h"

@interface LlegaEnBiciViewController : BaseMapBicisendaController <UICGDirectionsDelegate,DirectionsDelegateProtocol,UISearchBarDelegate, BSForwardGeocoderDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>{
	UICGDirections *diretions;
	NSString *startPoint;
	NSString *endPoint;
	NSString *endPointTitle;
	NSArray *wayPoints;
	UICGTravelModes travelMode;
	BOOL hasPin;
	NSTimer *timer;
       
    // the data representing the route points. 
	MKPolyline *routeLine;
	// the view we create for the line on the map
	MKPolylineView *routeLineView;
    // the rect that bounds the loaded points
	MKMapRect _routeRect;
    
	UIActivityIndicatorView *loaderViewController;

    //Search Bar
    IBOutlet UISearchBar *searchBar;
	BSForwardGeocoder *forwardGeocoder;
    
    IBOutlet UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;
@property (nonatomic, retain) NSArray *wayPoints;
@property (nonatomic) UICGTravelModes travelMode;
@property (nonatomic) BOOL hasPin;

@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

//Search Bar
@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;

- (void) changeGoalLocationTo:(CLLocationCoordinate2D)newCoordinate;
- (void) setupRouteLine: (NSArray *) routePoints;
- (void)reloadFrameView;

@end
