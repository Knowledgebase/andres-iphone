    //
//  MapViewController.m
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import "MapViewController.h"

#import "SculptureDetailViewController.h"
#import "Site.h"
#import "SiteAnnotation.h"


@implementation MapViewController


@synthesize managedObjectContext;
@synthesize mapView;
@synthesize siteAnnotations;


#pragma mark -

+ (CGFloat)annotationPadding; { return 10.0f; }
+ (CGFloat)calloutHeight; { return 40.0f; }

- (void)gotoLocation
{
    // start off by default in Somerville
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 42.73;
    newRegion.center.longitude = -71.667;
    newRegion.span.latitudeDelta = 0.0075;
    newRegion.span.longitudeDelta = 0.0075;
	
    [self.mapView setRegion:newRegion animated:YES];
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	self.mapView.mapType = MKMapTypeHybrid;
	self.mapView.showsUserLocation = YES;
	
	// create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Back";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	[self setSiteAnnotations:[[NSMutableArray alloc] init]];
	
	for (Site * site in mutableFetchResults) {
		NSLog(@"Site @ %@, %@", site.latitude, site.longitude);
		[self.siteAnnotations addObject:[[SiteAnnotation alloc] initWithSite:site]];
	}
	
	
	[mutableFetchResults release];
	[request release];
	
	[self gotoLocation];
	
	[self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.siteAnnotations];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[SiteAnnotation class]])
	{
		NSString* annotationIdentifier = [annotation title];
		MKPinAnnotationView* pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		if (!pinView)
		{
			// if an existing pin view was not available, create one
			MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
			customPinView.pinColor = MKPinAnnotationColorPurple;
			customPinView.animatesDrop = YES;
			customPinView.canShowCallout = YES;
			
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			customPinView.rightCalloutAccessoryView = rightButton;
			
			return customPinView;
		}
		else
		{
			pinView.annotation = annotation;
		}
		
		return pinView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	// TODO: assert that the annotation must be a SculptureAnnotation
	
	SculptureDetailViewController *detailViewController = [[SculptureDetailViewController alloc] initWithNibName:@"SculptureDetailView"
																										  bundle:nil];
    detailViewController.sculpture = [[view.annotation site] pointOfInterest];
	
	[self.navigationController setToolbarHidden:YES
									   animated:NO];
	[self.navigationController pushViewController:detailViewController
										 animated:YES];
	
	[detailViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.siteAnnotations = nil;
    self.mapView = nil;
}

- (void)dealloc 
{
    [mapView release];
    [siteAnnotations release];
    [super dealloc];
}

@end