//
//  NewsPostDetailsViewController.m
//  bicisendas
//
//  Created by Ariel Scarpinelli on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsPostDetailsViewController.h"


@implementation NewsPostDetailsViewController
@synthesize newsPost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if (newsPost) {
        [(UIWebView*)self.view loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:newsPost.url]]];
    }
    

}

- (void)viewDidDisappear:(BOOL)animated {
    [(UIWebView*)self.view loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
