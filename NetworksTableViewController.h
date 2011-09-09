//
//  NetworksTableViewController.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 7/14/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDetailController.h"
#import "WifiData.h"


@interface NetworksTableViewController : UITableViewController {
	NSMutableDictionary *networks;
	NSMutableDictionary *wifiDataDictionary;
	NSMutableArray *rows;
	NSMutableArray *macAddresses;
	NetworkDetailController *ndc;
	NSIndexPath *selectedNetworkPath;
	UITableViewCell *networkCell;
}

@property (nonatomic, assign) IBOutlet UITableViewCell *networkCell;

- (void)setNetworksObject:(NSString *)data ForKey:(NSString *)ssid;
- (void)setRowSsid:(NSString *)ssid;
- (void)addToMacAddresses:(NSString *)macAddress;
- (void)updateNetworkDetailView;
- (void)addWifiDataToDictionary:(WifiData *)data;

@end
