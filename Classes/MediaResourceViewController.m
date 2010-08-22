//
//  MediaResourceViewController.m
//  Andres
//
//  Created by Joshua Gan on 8/21/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import "MediaResourceViewController.h"


@implementation MediaResourceViewController


// Load the view nib and initialize the pageNumber ivar.
- (id)initWithResource:(Resource *)resource {
	[super init];
	return self;
}

- (void)viewDidLoad {
    pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    self.view.backgroundColor = [MyViewController pageControlColorWithIndex:pageNumber];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
