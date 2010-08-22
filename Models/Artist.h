//
//  Artist.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Sculpture;
@class ExternalLink;
@class Resource;

@interface Artist :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* resources;
@property (nonatomic, retain) NSSet* externalLinks;
@property (nonatomic, retain) NSSet* sculptures;
@property (nonatomic, retain) Resource* photo;

@end


@interface Artist (CoreDataGeneratedAccessors)
- (void)addResourcesObject:(Resource *)value;
- (void)removeResourcesObject:(Resource *)value;
- (void)addResources:(NSSet *)value;
- (void)removeResources:(NSSet *)value;

- (void)addExternalLinksObject:(ExternalLink *)value;
- (void)removeExternalLinksObject:(ExternalLink *)value;
- (void)addExternalLinks:(NSSet *)value;
- (void)removeExternalLinks:(NSSet *)value;

- (void)addSculpturesObject:(Sculpture *)value;
- (void)removeSculpturesObject:(Sculpture *)value;
- (void)addSculptures:(NSSet *)value;
- (void)removeSculptures:(NSSet *)value;

@end

