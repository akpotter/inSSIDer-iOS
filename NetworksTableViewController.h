//
//  NetworksTableViewController.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 7/14/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDetailController.h"


@interface NetworksTableViewController : UITableViewController {
	NSMutableDictionary *networks;
	NSMutableArray *rows;
	NSMutableArray *macAddresses;
	NetworkDetailController *ndc;
	NSIndexPath *selectedNetworkPath;
}

//@property (nonatomic, retain) NSMutableDictionary *networks;
//@property (nonatomic, retain) NSMutableArray *rows;

- (void)setNetworksObject:(NSString *)data ForKey:(NSString *)ssid;
- (void)setRowSsid:(NSString *)ssid;
- (void)addToMacAddresses:(NSString *)macAddress;
- (void)updateNetworkDetailView;

@end
