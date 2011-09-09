//
//  WifiGraphView.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 9/9/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WifiGraphView : UIView {
	int xAxisLabelSpacing;
	int yAxisLabelSpacing;
}

- (void)drawGraphWithRectangle:(CGRect)rect context:(CGContextRef)context;
- (void)drawHorizontalGraphLineAt:(int)y context:(CGContextRef)context;
- (void)drawHorizontalTickMarkAt:(int)y context:(CGContextRef)context;
- (void)drawVerticalTickMarktAt:(int)x context:(CGContextRef)context;

@end
