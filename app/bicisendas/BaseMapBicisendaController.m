//
//  BaseMapBicisendaController.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseMapBicisendaController.h"


@implementation BaseMapBicisendaController

- (void)dealloc
{
    [mapView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(-34.604407, -58.392313), MKCoordinateSpanMake(.1, .1)) animated:NO];    
    
    selfAnnotation = [[OwnPositionAnnotation alloc] init];
    selfAnnotationView = [[OwnPositionAnnotationView alloc] initWithAnnotation:selfAnnotation reuseIdentifier:NSStringFromClass([selfAnnotationView class])];
    

    
    [mapView addOverlays:[self getOverlays]];
    [mapView addAnnotations:[self getAnnotations]];
    
    NSLog(@"Own anotation: %@",selfAnnotation);
    //[mapView addAnnotation:selfAnnotation];

}

- (NSArray*) getOverlays {
    return [kml overlays];    
}

- (NSArray*) getAnnotations {
    return [[kml points] arrayByAddingObject:selfAnnotation];
}


#pragma mark MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    return [kml viewForOverlay:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[OwnPositionAnnotation class]]) 
    {
        return selfAnnotationView;
    }
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"] autorelease];
        pinView.pinColor = MKPinAnnotationColorRed;
        if (arc4random() % 2 == 0) {
            pinView.pinColor = MKPinAnnotationColorGreen;
        }
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
    } else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void) currentPositionDidChange
{
    [mapView removeAnnotation:selfAnnotation];
    [mapView addAnnotation: selfAnnotation];
}


- (void)viewDidUnload
{
    [mapView release];
    mapView = nil;
    [kml release];
    kml = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
