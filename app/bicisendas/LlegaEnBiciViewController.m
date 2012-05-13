//
//  LlegaEnBici.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LlegaEnBiciViewController.h"


@implementation LlegaEnBiciViewController

@synthesize routeLine;
@synthesize startPoint;
@synthesize endPoint;
@synthesize wayPoints;
@synthesize travelMode;
@synthesize hasPin;
@synthesize routeLineView;
@synthesize backgroundView;
@synthesize forwardGeocoder;
@synthesize searchDisplayController;

- (NSArray*) getAnnotations {
    return nil;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (void)viewDidLoad {
    //diretions = [[UICGDirections alloc] init];
    directionsBike = [[Directions alloc] init];
    //diretions.delegate = self;
    directionsBike.delegate = self;
    
    //add current gas station annotation
    CLLocationCoordinate2D coordinate;
    coordinate.latitude =  -34.6036;
    coordinate.longitude = -58.3817;
    
    /*
    NSString *theEndPoint = [NSString stringWithFormat:@"%f,%f", coordinate.latitude ,coordinate.longitude];
    self.endPoint = theEndPoint;
    NSMutableArray *theWayPoints = [NSMutableArray arrayWithCapacity:0];
    self.wayPoints = theWayPoints;
    self.travelMode = UICGTravelModeDriving;
    [self setTitle:@"Ruta"];
     */
    [super viewDidLoad];
}

- (void)reloadFrameView
{
	mapView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 44);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[STLocationEngine sharedInstance] addLocationChangeObserver:self];
    
    //add user position annotation
    selfAnnotation = [[OwnPositionAnnotation alloc] init];
    selfAnnotationView = [[OwnPositionAnnotationView alloc] initWithAnnotation:selfAnnotation reuseIdentifier:NSStringFromClass([selfAnnotationView class])];
    
    [mapView addAnnotation:selfAnnotation];
    
    //center map on middle point between user and gas station
    MKCoordinateRegion newRegion;
    CLLocationCoordinate2D userLoction = [[STLocationEngine sharedInstance] currentPosition];
    
    newRegion.center.latitude       = (userLoction.latitude + selfAnnotation.coordinate.latitude) /2;
    newRegion.center.longitude      = (userLoction.longitude + selfAnnotation.coordinate.longitude) /2;
    newRegion.span.latitudeDelta    = fmax(0.012872, fabs( selfAnnotation.coordinate.latitude -  selfAnnotation.coordinate.latitude));
    newRegion.span.longitudeDelta   = fmax(0.019863 ,fabs( selfAnnotation.coordinate.longitude -  selfAnnotation.coordinate.longitude)); 
    
    [mapView setRegion:newRegion animated:YES];      
    [self currentPositionDidChange];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[STLocationEngine sharedInstance] removeLocationChangeObserver:self];
}


- (void)update {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    CLLocationCoordinate2D coordinate = [[STLocationEngine sharedInstance] currentPosition];
	NSString *currentLocation = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
	
	//NSLog(@"Latitude: %f Longitude: %f", mapView.userLocation.location.coordinate.latitude, mapView.userLocation.location.coordinate.longitude);
	
	UICGDirectionsOptions *options = [[[UICGDirectionsOptions alloc] init] autorelease];
	options.travelMode = travelMode;
	if ([wayPoints count] > 0) {
		NSArray *routePoints = [NSArray arrayWithObject:currentLocation];
		routePoints = [routePoints arrayByAddingObjectsFromArray:wayPoints];
		routePoints = [routePoints arrayByAddingObject:endPoint];
		[diretions loadFromWaypoints:routePoints options:options];
	} else {
        NSLog(currentLocation);
        NSLog(endPoint);
        [diretions loadWithStartPoint:currentLocation endPoint:endPoint options:options];
        [directionsBike loadWithStartPoint:currentLocation endPoint:endPoint];
	}
}

- (void)moveToCurrentLocation:(id)sender {
    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
}

- (void)addPinAnnotation:(id)sender {
    UICRouteAnnotation *pinAnnotation = [[[UICRouteAnnotation alloc] initWithCoordinate:mapView.userLocation.coordinate
																				  title:nil
																		 annotationType:UICRouteAnnotationTypeWayPoint] autorelease];
	[mapView addAnnotation:pinAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[GoalAnnotation class]]) 
    {
        return [[GoalAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"GoalAnnotation"];
    }
    if ([annotation isKindOfClass:[PinAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if(pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            pinView.pinColor = ((PinAnnotation*) annotation).color;
            pinView.animatesDrop = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return [super  mapView:mapView viewForAnnotation:annotation];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
            
            UIColor *lineColor = [UIColor colorWithRed:0.244 green:0.264 blue:0.976 alpha:0.400];
            
			self.routeLineView.lineWidth = 10;
            self.routeLineView.fillColor = lineColor;
            self.routeLineView.strokeColor = lineColor;
		}
		
		overlayView = self.routeLineView;
		
	}
	
	return overlayView;
	
}

/*
- (void) setupRouteLine: (NSArray *) routePoints {
	// while we create the route points, we will also be calculating the bounding box of our route
	// so we can easily zoom in on it. 
	MKMapPoint northEastPoint = MKMapPointMake(0.0, 0.0);
	MKMapPoint southWestPoint = MKMapPointMake(0.0, 0.0);
	NSLog(@"Array a mostrar: %@",routePoints);
	// create a c array of points. 
	MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [routePoints count]);
	
	for(int idx = 0; idx < [routePoints count]; idx++)
	{
        NSString *error;
		// break the string down even further to latitude and longitude fields. 
        id coordinateJSON =  [[routePoints objectAtIndex: idx] objectForKey:@"geom"];
        
        //id coordinateJSON = [[geom objectForKey:@"coordinates"]objectAtIndex: idx];
        // create our coordinate and add it to the correct spot in the array 
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[coordinateJSON objectAtIndex: 0]doubleValue], [[coordinateJSON objectAtIndex: 1]doubleValue]);
                
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        // if it is the first point, just use them, since we have nothing to compare to yet. 
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else 
        {
            if (point.x > northEastPoint.x) 
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x) 
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y) 
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;

	}
    for(int idx = 0; idx < [routePoints count]; idx++)
	{
        NSLog(@"points : %f,%f", pointArr[idx]);
	}
    // create the polyline based on the array of points. 
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count: [routePoints count]];
    
	_routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, (northEastPoint.x - southWestPoint.x), (northEastPoint.y - southWestPoint.y));
    
	// clear the memory allocated earlier for the points
	free(pointArr);
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[mapView addOverlay:self.routeLine];
	}
    
    //[mapView setVisibleMapRect:_routeRect];
}
*/

- (void) setupRouteLine: (NSArray *) routePoints {
	// while we create the route points, we will also be calculating the bounding box of our route
	// so we can easily zoom in on it. 
	MKMapPoint northEastPoint = MKMapPointMake(0.0, 0.0);
	MKMapPoint southWestPoint = MKMapPointMake(0.0, 0.0);
	
	// create a c array of points. 
	MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [routePoints count]);
	
	for(int idx = 0; idx < [routePoints count]; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
        CLLocation *routePoint = [routePoints objectAtIndex: idx];
        
		// create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(routePoint.coordinate.latitude, routePoint.coordinate.longitude);
        
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
		//
		// adjust the bounding box
		//
		
		// if it is the first point, just use them, since we have nothing to compare to yet. 
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		}
		else 
		{
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}
        
		pointArr[idx] = point;
        
	}
	
	// create the polyline based on the array of points. 
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count: [routePoints count]];
    
	_routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, (northEastPoint.x - southWestPoint.x), (northEastPoint.y - southWestPoint.y));
    
	// clear the memory allocated earlier for the points
	free(pointArr);
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[mapView addOverlay:self.routeLine];
	}
    
    //[mapView setVisibleMapRect:_routeRect];
}


#pragma mark <DirectionsDelegateProtocol> Methods

- (void)directions:(UICGDirections *)directions didFailInitializeWithError:(NSError *)error {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"didFailInitializeWithError: %@", [error localizedFailureReason]);
	
	if (mapView.userLocation.location.coordinate.latitude != 0.0f && mapView.userLocation.location.coordinate.longitude != 0.0f) {
		//STAlertView *alertView = [[STAlertView alloc] initWithTitle:@"Map Directions" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		//[alertView show];
		//[alertView release];
	}
	
	
}


- (void)didUpdateDirections:(NSArray *)directions
{
	
    NSLog(@"Directions: %@",directions);
    NSMutableArray *routePoints = [NSMutableArray array];
    for (NSDictionary * direction in directions) {
        //NSLog(@"Direction: %@",direction);
        NSArray *geom = [direction objectForKey:@"geom"];
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake([[geom objectAtIndex:1] floatValue], [[geom objectAtIndex:0] floatValue]);
        NSLog(@"Point: %f,%f",point);
        CLLocation *routePoint = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        [routePoints addObject:routePoint];
    }
    
    //[routeOverlayView setRoutes:routePoints];
    [self setupRouteLine:routePoints];
    
    //add user position annotation
    selfAnnotation = [[OwnPositionAnnotation alloc] init];
    selfAnnotationView = [[OwnPositionAnnotationView alloc] initWithAnnotation:selfAnnotation reuseIdentifier:NSStringFromClass([selfAnnotationView class])];
    [mapView addAnnotation:selfAnnotation];
    
    //add current gas station annotation
    GoalAnnotation * endAnnotation = [[[GoalAnnotation alloc] init] autorelease];
    [endAnnotation setCoordinate:((CLLocation*)[routePoints lastObject]).coordinate];
    
    [mapView addAnnotation:endAnnotation];
}

- (void)directionsDidUpdateDirections:(UICGDirections *)directions {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if(!hasPin){
		// Overlay polylines
		UICGPolyline *polyline = [directions polyline];
		NSArray *routePoints = [polyline routePoints];
		
        //[routeOverlayView setRoutes:routePoints];
        [self setupRouteLine:routePoints];;
        
        //add user position annotation
        selfAnnotation = [[OwnPositionAnnotation alloc] init];
        selfAnnotationView = [[OwnPositionAnnotationView alloc] initWithAnnotation:selfAnnotation reuseIdentifier:NSStringFromClass([selfAnnotationView class])];
        [mapView addAnnotation:selfAnnotation];
        
        //add current gas station annotation
        GoalAnnotation * endAnnotation = [[[GoalAnnotation alloc] init] autorelease];
        
        [endAnnotation setCoordinate:((CLLocation*)[routePoints lastObject]).coordinate];
        
        [mapView addAnnotation:endAnnotation];
    }
	hasPin = true;
}


- (void)directions:(UICGDirections *)directions didFailWithMessage:(NSString *)message {
    NSLog(@"Error:%@",message);
}



- (void)forwardGeocoderFoundLocation:(BSForwardGeocoder*)geocoder
{
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
        [self.searchDisplayController.searchResultsTableView reloadData];
	}
	else {
		NSString *message = @"";
		
		switch (forwardGeocoder.status) {
			case G_GEO_BAD_KEY:
				message = @"The API key is invalid.";
				break;
				
			case G_GEO_UNKNOWN_ADDRESS:
				message = [NSString stringWithFormat:@"Could not find %@", forwardGeocoder.searchQuery];
				break;
				
			case G_GEO_TOO_MANY_QUERIES:
				message = @"Too many queries has been made for this API key.";
				break;
				
			case G_GEO_SERVER_ERROR:
				message = @"Server error, please try again.";
				break;
				
				
			default:
				break;
		}
		NSLog(@"%@", message);
	}
}

#pragma mark - UI Events
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
	NSLog(@"Searching for: %@", searchDisplayController.searchBar.text);
    NSLog(@"Searching for (viene en delegate): %@", theSearchBar.text);
	if(forwardGeocoder == nil)
	{
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	// Forward geocode!
	[forwardGeocoder findLocation:[NSString stringWithFormat:@"%@ ,Ciudad Autónoma de Buenos Aires", theSearchBar.text]];
    
}

#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
    return [forwardGeocoder.results count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
    if(([forwardGeocoder.results count] > indexPath.row) && (indexPath.row >= 0)){
        BSKmlResult *place = [forwardGeocoder.results objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", place.address];
    }
   	return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(([forwardGeocoder.results count] > indexPath.row) && (indexPath.row >= 0)){
        BSKmlResult *place = [forwardGeocoder.results objectAtIndex:indexPath.row];
        [self changeGoalLocationTo:[place coordinate]];
    }
    forwardGeocoder.shouldReturnLocation = NO;
}

#pragma mark -
#pragma mark Change Location Methods

- (void) changeGoalLocationTo:(CLLocationCoordinate2D)newCoordinate
{
    endPoint = [NSString stringWithFormat:@"%f,%f", newCoordinate.latitude ,newCoordinate.longitude];
    NSMutableArray *theWayPoints = [NSMutableArray arrayWithCapacity:0];
    self.wayPoints = theWayPoints;
    
    [self update];
    [self.searchDisplayController setActive:NO animated:YES];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"End Search");
    //[homeController setShouldRefreshOnViewDidAppear:NO];
    //[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSLog(@"Searching for: %@", searchDisplayController.searchBar.text);
	if(forwardGeocoder == nil)
	{
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	[forwardGeocoder findLocation:[NSString stringWithFormat:@"%@ ,Ciudad de Buenos Aires", searchString]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



@end
