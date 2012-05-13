//  CustomLoaderViewController.h
//
//  Created by Erick Frausto on 11/03/11.
//  Copyright 2011 ISOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLoaderViewController : UIViewController {
	CGRect iSize;
	NSInteger nFrames;
	UIImageView *loadingImageView; 
} 

- (id)initWithImageSize:(CGRect)size andNumberOfFrames:(NSInteger)numberOfFrames;
- (void)startAnimating;
- (void)stopAnimating;

@end

