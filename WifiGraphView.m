//
//  WifiGraphView.m
//  inSSIDer.iOS
//
//  Created by Ben Bower on 9/9/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import "WifiGraphView.h"


@implementation WifiGraphView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	yAxisLabelSpacing = 10;
	xAxisLabelSpacing = 5;
	CGPoint origin;
	CGSize size;
	
	origin.x = yAxisLabelSpacing + self.bounds.origin.x;
	origin.y = self.bounds.origin.y;
	size.width = self.bounds.size.width - yAxisLabelSpacing;
	size.height = self.bounds.size.height - xAxisLabelSpacing;
	CGRect graphRect;
	graphRect.origin = origin;
	graphRect.size = size;
	
	[self drawGraphWithRectangle:graphRect context:context];
}

- (void)drawGraphWithRectangle:(CGRect)rect context:(CGContextRef)context 
{
	CGContextBeginPath(context);
	CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
	CGContextAddRect(context, rect);
	CGContextStrokePath(context);
	
	for (int i = 1; i < 6; i++) {
		int y = (rect.size.height / 6) * i;
		[self drawHorizontalTickMarkAt:y context:context];
		[self drawHorizontalGraphLineAt:y context:context];
	}
	
	for (int i = 1; i < 5; i++) {
		int x = (rect.size.width / 5) * i;
		[self drawVerticalTickMarktAt:x context:context];
	}
}

- (void)drawHorizontalGraphLineAt:(int)y context:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithWhite:0.4 alpha:0.6].CGColor);
	for (int i = yAxisLabelSpacing; i < self.bounds.size.width; i += 6) {
		CGContextMoveToPoint(context, i, y);
		CGContextAddLineToPoint(context, i + 3, y);
	}
	CGContextStrokePath(context);
}

- (void)drawHorizontalTickMarkAt:(int)y context:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
	CGContextMoveToPoint(context, yAxisLabelSpacing - 3, y);
	CGContextAddLineToPoint(context, yAxisLabelSpacing + 3, y);
	CGContextStrokePath(context);
}

- (void)drawVerticalTickMarktAt:(int)x context:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
	CGContextMoveToPoint(context, x, self.frame.size.height - xAxisLabelSpacing - 3);
	CGContextAddLineToPoint(context, x, self.frame.size.height - xAxisLabelSpacing + 3);
	CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
