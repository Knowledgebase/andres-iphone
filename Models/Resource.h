//
//  Resource.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Resource :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * source;

@end



