//
//  WiFiScanner.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 5/6/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <dlfcn.h>
@class inSSIDer_iOSAppDelegate;

@interface WiFiScanner : NSObject {
	NSMutableDictionary *networks; //Key: MAC Address (BSSID)
	
	void *libHandle;
	void *airportHandle;    
	int (*apple80211Open)(void *);
	int (*apple80211Bind)(void *, NSString *);
	int (*apple80211Close)(void *);
	int (*associate)(void *, NSDictionary*, NSString*);
	int (*apple80211Scan)(void *, NSArray **, void *);
}

@property (nonatomic, retain) inSSIDer_iOSAppDelegate *appDelegate;
@property (nonatomic) bool isScanning;

- (void)startScanningNetworks;
- (void)displayNetworkData;

@end
