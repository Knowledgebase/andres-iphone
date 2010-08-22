//
//  SiteAnnotation.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Site;
@class PointOfInterest;


@interface SiteAnnotation : NSObject <MKAnnotation> {
	Site *site;
}

@property (nonatomic, retain) Site *site;


-(id) initWithSite:(Site *)inSite;


@end
