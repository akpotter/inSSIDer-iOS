//
//  WifiData.m
//  inSSIDer.iOS
//
//  Created by Ben Bower on 8/5/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import "WifiData.h"


@implementation WifiData

@synthesize macAddress,
			ssid,
			rssi,
			channel,
			privacy,
			maxRate,
			firstSeen,
			lastSeen,
			latitude,
			longitude;

- (id)init {
	self = [super init];
	
	macAddress = [[NSString alloc] init];
	ssid = [[NSString alloc] init];
	privacy = [[NSString alloc] init];
	firstSeen = [[NSDate alloc] init];
	lastSeen = [[NSDate alloc] init];
	
	return self;
}

- (void)dealloc {
	[macAddress dealloc];
	[ssid dealloc];
	[privacy dealloc];
	[firstSeen dealloc];
	[lastSeen dealloc];
	[super dealloc];
}

@end
