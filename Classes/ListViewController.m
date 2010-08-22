//
//  ListViewController.m
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import "ListViewController.h"

#import "SculptureDetailViewController.h"
#import "Sculpture.h"
#import "Artist.h"
#import "Site.h"


@implementation ListViewController

@synthesize sculpturesArray;
@synthesize managedObjectContext;
@synthesize locationManager;


#pragma mark -
#pragma mark Location Manager implementation

- (CLLocationManager *)locationManager {
    
    if (locationManager != nil) {
        return locationManager;
    }
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    
    return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    // TODO: After adding sort by distance, use this to enable button.
	//addButton.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    // TODO: After adding sort by distance, use this to disable button.
    //addButton.enabled = NO;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title.
    self.title = @"Sculptures";
    
    // Set up the buttons.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSite)];
    //addButton.enabled = NO;
    //self.navigationItem.rightBarButtonItem = addButton;
	
    // Start the location manager.
    [[self locationManager] startUpdatingLocation];
	
	
	//----------------------------------
	// Loading the site data
	//----------------------------------
	
	NSString *description = [[managedObjectContext registeredObjects] description];
	NSLog(@"%@", description);
	
	// Set entity
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sculpture" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Set sort order
	//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	//NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	//[request setSortDescriptors:sortDescriptors];
	//[sortDescriptors release];
	//[sortDescriptor release];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	[self setSculpturesArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}



#pragma mark -
#pragma mark Table view data source

/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 // Return the number of sections.
 return 1;
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [sculpturesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // A date formatter for the time stamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yy"];
	
    // A number formatter for the latitude and longitude
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
	
    static NSString *CellIdentifier = @"Cell";
	
    // Dequeue or create a new cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
    Sculpture *sculpture = (Sculpture *)[sculpturesArray objectAtIndex:indexPath.row];
	
    cell.textLabel.text = [sculpture title];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ '%@",
								 [sculpture.artist displayName],
								 [dateFormatter stringFromDate:[sculpture date]]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
        NSManagedObject *siteToDelete = [sculpturesArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:siteToDelete];
		
        // Update the array and table view.
        [sculpturesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
        // Commit the change.
        NSError *error;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SculptureDetailViewController *detailViewController = [[SculptureDetailViewController alloc] initWithNibName:@"SculptureDetailView" bundle:nil];
    detailViewController.sculpture = [sculpturesArray objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:detailViewController animated:YES];

	[detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.sculpturesArray = nil;
    self.locationManager = nil;
}

- (void)dealloc {
    [managedObjectContext release];
    [sculpturesArray release];
    [locationManager release];
    [super dealloc];
}

@end

