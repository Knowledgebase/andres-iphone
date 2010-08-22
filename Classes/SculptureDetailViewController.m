    //
//  SculptureDetailViewController.m
//  Andres
//
//  Created by Joshua Gan on 8/7/10.
//  Copyright 2010 Knowledgebase Inc. All rights reserved.
//

#import "SculptureDetailViewController.h"

#import "Sculpture.h"
#import "Resource.h"

@implementation SculptureDetailViewController

@synthesize sculpture;
@synthesize contentView;
@synthesize mediaView;

@synthesize swipeLeftRecognizer, tapRecognizer;


const CGFloat kScrollObjHeight	= 199.0;
const CGFloat kScrollObjWidth	= 280.0;


#pragma mark -
#pragma mark Initialization

- (void)initContentView {
	// Add Title
	// Add Artist/Year (link)
	// Add Medium	
	// Add Statement
	// Add External Links
	// Add Trail Links
	
	CGFloat kOffset = 0;
	CGFloat width = contentView.bounds.size.width - 2*kOffset;
	CGFloat runningY = kOffset;
	
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = [sculpture title];
	titleLabel.font = [UIFont systemFontOfSize:30];
	[titleLabel sizeToFit];
	titleLabel.frame = CGRectMake(0, runningY, width, titleLabel.frame.size.height);
	
	runningY += titleLabel.bounds.size.height;
	
	UILabel *artistLabel = [[UILabel alloc] init];
	artistLabel.text = [sculpture.artist displayName];
	[artistLabel sizeToFit];
	artistLabel.frame = CGRectMake(0, runningY, width, artistLabel.frame.size.height);
	
	runningY += artistLabel.bounds.size.height + kOffset;
	
	UILabel *statementLabel = [[UILabel alloc] init];
	[statementLabel setFont:[UIFont systemFontOfSize:10]];
	[statementLabel setLineBreakMode:UILineBreakModeWordWrap];
	[statementLabel setNumberOfLines:0];
	[statementLabel setText:sculpture.statement];
	CGSize size = [statementLabel sizeThatFits:CGSizeMake(width, 0)];
	statementLabel.frame = CGRectMake(0, runningY, width, size.height);
	
	runningY += statementLabel.bounds.size.height;
	
	[contentView addSubview:titleLabel];
	[contentView addSubview:artistLabel];
	[contentView addSubview:statementLabel];
	
	contentView.contentSize=CGSizeMake(width,runningY);
	
	[titleLabel release];
	[artistLabel release];
	[statementLabel release];
}


- (void)initGestureRecognizition {

	UIGestureRecognizer *recognizer;
	
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self.view addGestureRecognizer:recognizer];
    self.tapRecognizer = (UITapGestureRecognizer *)recognizer;
    recognizer.delegate = self;
	[recognizer release];
	
}


- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [mediaView subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += view.frame.size.width;
		}
	}
	
	// set the content size so it can be scrollable
	[mediaView setContentSize:CGSizeMake(curXLoc, [mediaView bounds].size.height)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	contentView.clipsToBounds = YES;
	
	[self initContentView];
	[self initGestureRecognizition];
}


- (void)viewWillAppear:(BOOL)animated {    
    self.title = [sculpture title];

	CGSize size = mediaView.frame.size;
	
	NSUInteger index = 0;
	for (id resource in [sculpture resources])
	{
		NSString *imageName = [resource source];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = size.height;
		rect.size.width = size.width;
		imageView.frame = rect;
		imageView.tag = index;	// tag our images for later use when we place them in serial fashion
		[mediaView addSubview:imageView];
		[imageView release];
		
		index++;
	}
	
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview

}



#pragma mark -
#pragma mark UIGestureRecognizerDelegate implementation


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	
    if ((touch.view == contentView) && (gestureRecognizer == tapRecognizer)) {
        return NO;
    }
    return YES;
}


- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	contentView.hidden = !contentView.hidden;
}



#pragma mark -
#pragma mark Deconstruction

- (void)viewDidUnload {
    self.contentView = nil;
    self.mediaView = nil;
    [super viewDidUnload];    
}


- (void)dealloc {
    [sculpture release];
    [contentView release];
	[mediaView release];
    [super dealloc];
}


@end
