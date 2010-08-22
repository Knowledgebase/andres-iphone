//
//  Sculpture.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PointOfInterest.h"

@class Artist;
@class ExternalLink;
@class Resource;

@interface Sculpture :  PointOfInterest  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Artist * artist;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * statement;
@property (nonatomic, retain) NSString * medium;
@property (nonatomic, retain) NSSet* resources;
@property (nonatomic, retain) NSSet* externalLinks;
@property (nonatomic, retain) Resource* primaryImage;

@end


@interface Sculpture (CoreDataGeneratedAccessors)
- (void)addResourcesObject:(Resource *)value;
- (void)removeResourcesObject:(Resource *)value;
- (void)addResources:(NSSet *)value;
- (void)removeResources:(NSSet *)value;

- (void)addExternalLinksObject:(ExternalLink *)value;
- (void)removeExternalLinksObject:(ExternalLink *)value;
- (void)addExternalLinks:(NSSet *)value;
- (void)removeExternalLinks:(NSSet *)value;

@end

