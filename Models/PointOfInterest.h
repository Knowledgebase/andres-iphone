//
//  PointOfInterest.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface PointOfInterest :  NSManagedObject  
{
}

@property (nonatomic, retain) NSManagedObject * site;


- (NSString *)getAnnotationTitle;
- (NSString *)getAnnotationSubtitle;


@end



