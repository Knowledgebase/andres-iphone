//
//  MapViewController.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "WantsManagedObjectContext.h"

@class SculptureDetailViewController;


@interface MapViewController : UIViewController <MKMapViewDelegate, WantsManagedObjectContext> {
	
    NSMutableArray *siteAnnotations;
    NSManagedObjectContext *managedObjectContext;
	
    MKMapView *mapView;
}


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *siteAnnotations;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;


+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;


@end
