//
//  WiFiScanner.m
//  inSSIDer.iOS
//
//  Created by Ben Bower on 5/6/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import "WiFiScanner.h"
#import "inSSIDer_iOSAppDelegate.h"


@implementation WiFiScanner

@synthesize appDelegate;
@synthesize isScanning;

- (id)init
{
	self = [super init];
	
	appDelegate = (inSSIDer_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	isScanning = NO;
	
	networks = [[NSMutableDictionary alloc] init];
	
	libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", RTLD_LAZY);
	
	char *error;
	if (libHandle == NULL && (error = dlerror()) != NULL)  {
		NSLog(@"%c",error);
		exit(1);
	}
	
	apple80211Open = dlsym(libHandle, "Apple80211Open");
	apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
	apple80211Close = dlsym(libHandle, "Apple80211Close");
	apple80211Scan = dlsym(libHandle, "Apple80211Scan");
	
	apple80211Open(&airportHandle);
	apple80211Bind(airportHandle, @"en0");
	
	return self;
}

- (void)startScanningNetworks
{
	while (isScanning)
	{
		[NSThread sleepForTimeInterval:3];
		
		NSDictionary *parameters = [[NSDictionary alloc] init];
		NSArray *scan_networks;
		
		apple80211Scan(airportHandle, &scan_networks, parameters);
		
		for (int i = 0; i < [scan_networks count]; i++) {
			[networks setObject:[scan_networks objectAtIndex: i] forKey:[[scan_networks objectAtIndex: i] objectForKey:@"BSSID"]];
		}
		
		[self displayNetworkData];
		//dispatch_async(dispatch_get_main_queue(), ^{ [appDelegate newDataToDisplay:[self networksString]]; });
		
		[parameters release];
	}
}

- (void)displayNetworkData {
	
	NSMutableString *result;
	
	for (id key in networks){
		result = [[NSMutableString alloc] initWithString:@""];
		[result appendString:[NSString stringWithFormat:@"*** %@ ***\n\n",
							   [[networks objectForKey: key] objectForKey:@"SSID_STR"]
							   ]];
		[result appendString:@"---------------------------"];
		for (id key2 in [networks objectForKey:key])
		{
			[result appendString:[NSString stringWithFormat:@"\n%@: %@\n---------------------", key2, [[networks objectForKey:key] objectForKey:key2]]];
		}
		dispatch_async(dispatch_get_main_queue(), ^{ [appDelegate displayNewData:result From:[[networks objectForKey: key] objectForKey:@"SSID_STR"]]; });
		[result release];
		//[result appendString:@"------\n\n"];
		/*[result appendString:[NSString stringWithFormat:@"%@ (%@)\n\t RSSI: %@\n\t Channel: %@\n\t WEP enabled: %@\n\t Age: %@\n\t rates: %@\n\n", 
							  [[networks objectForKey: key] objectForKey:@"SSID_STR"], //Station Name
							  key, //Station BBSID (MAC Address)
							  [[networks objectForKey: key] objectForKey:@"RSSI"], //Signal Strength
							  [[networks objectForKey: key] objectForKey:@"CHANNEL"],  //Operating Channel
							  [[networks objectForKey: key] objectForKey:@"WEP"],	//indicates whether the network is WEP enabled
							  [[networks objectForKey: key] objectForKey:@"AGE"],
							  [[networks objectForKey: key] objectForKey:@"RATES"]
							  ]];*/
	}
	
}

- (void) dealloc {
	[networks release];
	apple80211Close(airportHandle);
	[super dealloc];
}


@end
