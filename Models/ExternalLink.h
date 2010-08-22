//
//  ExternalLink.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface ExternalLink :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * name;

@end



