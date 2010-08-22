//
//  SculptureDetailViewController.h
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sculpture;


@interface SculptureDetailViewController : UIViewController <UIGestureRecognizerDelegate> {
	
	Sculpture *sculpture;
	UIScrollView *contentView;
	UIScrollView *mediaView;

	UITapGestureRecognizer *tapRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	
}

@property (nonatomic, retain) Sculpture *sculpture;
@property (nonatomic, retain) IBOutlet UIScrollView *contentView;
@property (nonatomic, retain) IBOutlet UIScrollView *mediaView;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;

@end
