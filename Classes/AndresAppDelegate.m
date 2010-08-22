//
//  AndresAppDelegate.m
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright Knowledgebase Inc 2010. All rights reserved.
//

#import <sqlite3.h>

#import "AndresAppDelegate.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "ListViewController.h"

#import "Artist.h"
#import "Sculpture.h"
#import "Site.h"
#import "Resource.h"


@implementation AndresAppDelegate


@synthesize window;
@synthesize tabBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)loadDataFromPList:(NSManagedObjectContext *)context {
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [path stringByAppendingPathComponent:@"InitialData.plist"];
	NSDictionary *plistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	NSArray *artistData = [plistData objectForKey:@"Artists"];
	NSMutableArray *artists=[NSMutableArray array];
	for (id data in artistData ) {
		NSManagedObject *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist"
																inManagedObjectContext:context];
		[artist setValue:[data objectForKey:@"firstName"] forKey:@"firstName"];
		[artist setValue:[data objectForKey:@"lastName"] forKey:@"lastName"];
		[artist setValue:[data objectForKey:@"displayName"] forKey:@"displayName"];
		[artists addObject:artist];
	}
	
	NSArray *sculptureData = [plistData objectForKey:@"Sculptures"];
	NSMutableArray *sculptures=[NSMutableArray array];
	for (id data in sculptureData) {
		Sculpture *sculpture = [NSEntityDescription insertNewObjectForEntityForName:@"Sculpture"
																   inManagedObjectContext:context];		
		[sculpture setValue:[data objectForKey:@"title"] forKey:@"title"];
		[sculpture setValue:[dateFormatter dateFromString:[data objectForKey:@"date"]] forKey:@"date"];
		[sculpture setValue:[data objectForKey:@"statement"] forKey:@"statement"];
		[sculpture setValue:[artists objectAtIndex:[[data objectForKey:@"artist"] intValue]] forKey:@"artist"];
		
		
		Resource *primaryImage = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
																	  inManagedObjectContext:context];
		[primaryImage setValue:[data objectForKey:@"primaryImage"] forKey:@"source"];
		[sculpture setValue:primaryImage forKey:@"primaryImage"];
		[sculpture addResourcesObject:primaryImage];		
		
		for (id imageSource in [data objectForKey:@"images"]) {
			Resource *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
															inManagedObjectContext:context];
			[image setValue:imageSource forKey:@"source"];
			[sculpture addResourcesObject:image];
		}

		for (id videoSource in [data objectForKey:@"videos"]) {
			Resource *video = [NSEntityDescription insertNewObjectForEntityForName:@"Video"
															inManagedObjectContext:context];
			[video setValue:videoSource forKey:@"source"];
			[sculpture addResourcesObject:video];
		}
		
		
		NSManagedObject *site = [NSEntityDescription insertNewObjectForEntityForName:@"Site"
															  inManagedObjectContext:context];
		[site setValue:[[data objectForKey:@"site"] objectForKey:@"latitude"] forKey:@"latitude"];
		[site setValue:[[data objectForKey:@"site"] objectForKey:@"longitude"] forKey:@"longitude"];
		
		
		[site setValue:sculpture forKey:@"pointOfInterest"];
		[sculpture setValue:site forKey:@"site"];
		
		[sculptures addObject:sculpture];
	}	
	
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
	
	return YES;	
}

- (BOOL)loadDataFromSQLite:(NSManagedObjectContext *)context {
	// Setup the database object
	sqlite3 *database;
	
	// Database variables
	NSString *databaseName = @"AndresDBv1.sqlite";
	NSString *databaseDir = [[NSBundle mainBundle] bundlePath];
	NSString *databasePath = [databaseDir stringByAppendingPathComponent:databaseName];
	
	// Init the animals Array
	NSMutableDictionary *artists	= [NSMutableDictionary dictionary];
	NSMutableDictionary *sculptures	= [NSMutableDictionary dictionary];

	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy"];
	
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {

		//*********************
		// Load Artists

		sqlite3_stmt *artistCompiledStatement;
		const char *artistsSqlStatement = "select * from Artists";
		if(sqlite3_prepare_v2(database, artistsSqlStatement, -1, &artistCompiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(artistCompiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aDisplayName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(artistCompiledStatement, 1)];
				NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(artistCompiledStatement, 2)];
				NSString *aLastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(artistCompiledStatement, 3)];
				//NSString *aCountry = [NSString stringWithUTF8String:(char *)sqlite3_column_text(artistCompiledStatement, 5)];
				//NSString *aBio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(artistCompiledStatement, 7)];
				//NSString *aPhotoName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(artistCompiledStatement, 7)];
				
				Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist"
																		inManagedObjectContext:context];
				[artist setValue:aDisplayName forKey:@"displayName"];
				[artist setValue:aFirstName forKey:@"firstName"];
				[artist setValue:aLastName forKey:@"lastName"];
				
				[artists setObject:artist forKey:aDisplayName];
				[artist release];
			}
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(artistCompiledStatement);
		
		
		//*********************
		// Load Sculptures
		
		sqlite3_stmt *sculpturesCompiledStatement;
		const char *sculpturesSqlStatement = "select * from Sculptures";
		if(sqlite3_prepare_v2(database, sculpturesSqlStatement, -1, &sculpturesCompiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(sculpturesCompiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aRef = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sculpturesCompiledStatement, 1)];
				NSString *aYear = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sculpturesCompiledStatement, 2)];
				NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sculpturesCompiledStatement, 3)];
				NSString *aArtistName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sculpturesCompiledStatement, 4)];
				NSString *aStatement = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sculpturesCompiledStatement, 10)];
				
				Sculpture *sculpture = [NSEntityDescription insertNewObjectForEntityForName:@"Sculpture"
																	 inManagedObjectContext:context];		
				[sculpture setValue:aTitle forKey:@"title"];
				[sculpture setValue:aStatement forKey:@"statement"];
				[sculpture setValue:[dateFormatter dateFromString:aYear] forKey:@"date"];
				[sculpture setValue:[artists objectForKey:aArtistName] forKey:@"artist"];

				
				NSNumber * aLat = [NSNumber numberWithDouble:sqlite3_column_double(sculpturesCompiledStatement, 8)];
				NSNumber * aLong = [NSNumber numberWithDouble:sqlite3_column_double(sculpturesCompiledStatement, 9)];

				Site *site = [NSEntityDescription insertNewObjectForEntityForName:@"Site"
														   inManagedObjectContext:context];
				[site setValue:aLat forKey:@"latitude"];
				[site setValue:aLong forKey:@"longitude"];
				
				[site setValue:sculpture forKey:@"pointOfInterest"];
				[sculpture setValue:site forKey:@"site"];
				
				[sculptures setObject:sculpture forKey:aRef];
				[sculpture release];
				
			}
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(sculpturesCompiledStatement);
		
		
		//*********************
		// Load Media
		
		sqlite3_stmt *resourceCompiledStatement;
		const char *resourceSqlStatement = "select * from Media";
		if(sqlite3_prepare_v2(database, resourceSqlStatement, -1, &resourceCompiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(resourceCompiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aSculptureRef = [NSString stringWithUTF8String:(char *)sqlite3_column_text(resourceCompiledStatement, 1)];
				NSString *aType			= [NSString stringWithUTF8String:(char *)sqlite3_column_text(resourceCompiledStatement, 2)];
				NSString *aSource		= [NSString stringWithUTF8String:(char *)sqlite3_column_text(resourceCompiledStatement, 3)];
				
			
				if ([aType isEqualToString:@"Primary_Image"] || [aType isEqualToString:@"Other_Image"]) {
					Resource *resource = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
																	   inManagedObjectContext:context];
					[resource setValue:aSource forKey:@"source"];
					
					Sculpture * sculpture = [sculptures objectForKey:aSculptureRef];
					[sculpture addResourcesObject:resource];
					if ([aType isEqualToString:@"Primary_Image"]) {
						[sculpture setValue:resource forKey:@"primaryImage"];
					}
					
					[resource release];
				}
			}
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(resourceCompiledStatement);
	
	}
	
	sqlite3_close(database);

	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
	
	return YES;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
		NSLog(@"Whoops, couldn't find context.");
    }
    	
	// Set entity
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sculpture" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// TODO: Handle the error.
	}

	// Load data from static source into CoreData, if necessary.
	// TODO: More robust data loading story.
	//	- Alternative to delete and reinstall (clear CoreData) to load new data.
	//	- Updating data, instead of wholesale replacement.
	//  - Pulling data from remote source instead of having to update the app.
	if (mutableFetchResults.count == 0) {
		[self loadDataFromSQLite:context];
	}
	
	// Give data context to each of the subviews
	// TODO: Find out if this methodology is Kosher.
	NSArray *viewControllers = [tabBarController viewControllers];
	for (id controller in viewControllers) {
		if ([controller isKindOfClass:[UINavigationController class]]) {
			[[[controller viewControllers] objectAtIndex:0] setManagedObjectContext:context]; 
		}
		if ([controller conformsToProtocol:@protocol(WantsManagedObjectContext)]) {
			[controller setManagedObjectContext:context];
		}
	}
	
	
    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    return YES;
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [tabBarController release];
    [window release];
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[super dealloc];
}


#pragma mark -
#pragma mark CoreData management

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"AndresList.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
