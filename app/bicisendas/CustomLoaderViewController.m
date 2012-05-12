//
//  CustomLoaderViewController.m
//
//  Created by Erick Frausto on 11/03/11.
//  Copyright 2011 ISOL. All rights reserved.
//

#import "CustomLoaderViewController.h"

@implementation CustomLoaderViewController

- (id)initWithImageSize:(CGRect)size andNumberOfFrames:(NSInteger)numberOfFrames {
	iSize = size;
	nFrames = numberOfFrames;
	return self;
}

- (void)loadView {
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:8];
	
	for(int count = 1; count <= nFrames; count++)
	{
		NSString *fileName = [NSString stringWithFormat:@"loader_%d.png", count];
		UIImage  *frame    = [UIImage imageNamed:fileName];
		[images addObject:frame];
	}
	
	loadingImageView = [[UIImageView alloc] initWithFrame:iSize];
	loadingImageView.animationImages = images;
	
	loadingImageView.animationDuration = 1;
	loadingImageView.animationRepeatCount = 0; //Repeats indefinitely
	
	self.view = loadingImageView;
	
	[images release];
}


- (void)startAnimating {
	[loadingImageView startAnimating];
}

- (void)stopAnimating {
	[loadingImageView stopAnimating];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;	
	[loadingImageView release];
	loadingImageView = nil;
}


- (void)dealloc {
	[loadingImageView release];
    [super dealloc];
}

@end
