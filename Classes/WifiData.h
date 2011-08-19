//
//  WifiData.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 8/5/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WifiData : NSObject {
	
}

@property (nonatomic, retain) NSString *macAddress;
@property (nonatomic, retain) NSString *ssid;
@property (nonatomic, retain) NSString *privacy;
@property (nonatomic, retain) NSDate *firstSeen;
@property (nonatomic, retain) NSDate *lastSeen;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) int rssi;
@property (nonatomic) int channel;
@property (nonatomic) int maxRate;

@end
