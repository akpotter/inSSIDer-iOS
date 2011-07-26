//
//  NetworkDetailController.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 7/22/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NetworkDetailController : UIViewController {
	UITextView *textView;
	NSString *networkDetail;
}

@property (copy) NSString *networkDetail;

@end
