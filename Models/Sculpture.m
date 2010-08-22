// 
//  Sculpture.m
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import "Sculpture.h"

#import "Artist.h"
#import "ExternalLink.h"

@implementation Sculpture 

@dynamic medium;
@dynamic title;
@dynamic date;
@dynamic artist;
@dynamic resources;
@dynamic externalLinks;
@dynamic primaryImage;


- (NSString *)getAnnotationTitle {
	return self.title;
}

- (NSString *)getAnnotationSubtitle {
	return [self.artist displayName];
}

@end
