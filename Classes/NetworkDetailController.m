    //
//  NetworkDetailController.m
//  inSSIDer.iOS
//
//  Created by Ben Bower on 7/22/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import "NetworkDetailController.h"


@implementation NetworkDetailController

@synthesize networkDetail;

- (void)setNetworkDetail:(NSString *)newNetworkDetail
{
	if(networkDetail != newNetworkDetail) {
		[networkDetail release];
		networkDetail = [newNetworkDetail copy];
	}
	self.title = networkDetail;
	if (textView.window) textView.text = networkDetail;
}

- (void)loadView
{
	textView = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	textView.backgroundColor = [UIColor blackColor];
	textView.textColor = [UIColor whiteColor];
	self.view = textView;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	textView.text = networkDetail;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textView dealloc];
    [super dealloc];
}


@end
