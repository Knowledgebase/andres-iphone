//
//  SiteAnnotation.m
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import "SiteAnnotation.h"

#import "Site.h"
#import "Sculpture.h"


@implementation SiteAnnotation

@synthesize site;


-(id)initWithSite: (Site *)inSite
{
    if (self = [super init])
    {
		[self setSite:inSite];
    }
    return self;
}


- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[site latitude] doubleValue];
    theCoordinate.longitude = [[site longitude] doubleValue];
    return theCoordinate; 
}

- (NSString *)title
{
    return [[self.site pointOfInterest] getAnnotationTitle];
}

- (NSString *)subtitle
{
    return [[self.site pointOfInterest] getAnnotationSubtitle];
}



- (void)dealloc
{
	[site release];
    [super dealloc];
}

@end
