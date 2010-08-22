//
//  ListViewController.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "WantsManagedObjectContext.h"
#import "Sculpture.h"


@interface ListViewController : UITableViewController <CLLocationManagerDelegate, WantsManagedObjectContext> {
	
    NSMutableArray *sculpturesArray;
    NSManagedObjectContext *managedObjectContext;
    
    CLLocationManager *locationManager;
	
}

@property (nonatomic, retain) NSMutableArray *sculpturesArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) CLLocationManager *locationManager;


@end