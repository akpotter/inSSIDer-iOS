//
//  inSSIDer_iOSAppDelegate.m
//  inSSIDer.iOS
//
//  Created by Ben Bower on 5/6/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import "inSSIDer_iOSAppDelegate.h"

@implementation inSSIDer_iOSAppDelegate

@synthesize window;
@synthesize ntvc;
@synthesize myMainView;
@synthesize myScanButton;
@synthesize wifiScanner;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	UINavigationController *nav = [[UINavigationController alloc] init];
	nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[nav pushViewController:ntvc animated:NO];
	nav.view.frame = myMainView.frame;
	[ntvc release];
	
	[myMainView addSubview:nav.view];
	
	networkData = [[NSMutableDictionary	alloc] init];
    wifiScanner = [[WiFiScanner alloc] init];
	
	myLocationController = [[LocationController alloc] init];
	myLocationController.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	[myLocationController.locationManager startUpdatingLocation];
	
	myQueue = dispatch_queue_create("myDispatchQueue", 0);
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

- (IBAction)myScanButtonPressed:(id)sender {
	
	if(wifiScanner.isScanning) {
		wifiScanner.isScanning = NO;
		
	    [myScanButton setTitle:@"Start Scanning"];
	}
	else {
		dispatch_async(myQueue, ^{ [wifiScanner startScanningNetworks]; });
		wifiScanner.isScanning = YES;
		
		[myScanButton setTitle:@"Stop Scanning"];
	}

}
											
- (void)displayNewData:(NSMutableDictionary *)data {
	[self processRawData:data];
	
	
	for (id mac in networkData)
	{
		WifiData *wifiData = [networkData objectForKey:mac];
		
		NSMutableString *dataString = [[NSMutableString alloc] init];
		[dataString setString:@""];
		[dataString appendString:[NSString stringWithFormat:@"*** %@ ***\n\n", wifiData.ssid]];
		[dataString appendString:[NSString stringWithFormat:@"Mac Address: %@ \n", wifiData.macAddress]];
		[dataString appendString:[NSString stringWithFormat:@"RSSI: %d \n", wifiData.rssi]];
		[dataString appendString:[NSString stringWithFormat:@"Channel: %d \n", wifiData.channel]];
		[dataString appendString:[NSString stringWithFormat:@"Privacy: %@ \n", wifiData.privacy]];
		[dataString appendString:[NSString stringWithFormat:@"Max Rate: %d \n", wifiData.maxRate]];
		[dataString appendString:[NSString stringWithFormat:@"First Seen: %@ \n", wifiData.firstSeen]];
		[dataString appendString:[NSString stringWithFormat:@"Last Seen: %@ \n", wifiData.lastSeen]];
		if(wifiData.latitude)
			[dataString appendString:[NSString stringWithFormat:@"Latitude: %f \n", wifiData.latitude]];
		if(wifiData.longitude)
			[dataString appendString:[NSString stringWithFormat:@"Longitude: %f \n", wifiData.longitude]];
		
		[ntvc setRowSsid:wifiData.ssid];
		[ntvc addToMacAddresses:mac];
		[ntvc setNetworksObject:dataString ForKey:mac];
		[ntvc addWifiDataToDictionary:wifiData]; 
		[dataString release];
	}
	
	[ntvc.tableView reloadData];
	[ntvc updateNetworkDetailView];
}

- (void)processRawData:(NSMutableDictionary *)rawData {
	WifiData *wifiData;
	
	for (id key in rawData){
		wifiData = [networkData objectForKey:key];
		if(wifiData == nil) {
			wifiData = [[WifiData alloc] init];
			if ([[rawData objectForKey: key] objectForKey:@"SSID_STR"]) 
				wifiData.ssid = [[NSString alloc] initWithString:[[rawData objectForKey: key] objectForKey:@"SSID_STR"]];
			else {
				wifiData.ssid = [[NSString alloc] initWithString:@""];
			}

			wifiData.macAddress = key;
			wifiData.firstSeen = [NSDate date];
		}
		wifiData.rssi = [[[rawData objectForKey: key] objectForKey:@"RSSI"] intValue];
		wifiData.channel = [[[rawData objectForKey: key] objectForKey:@"CHANNEL"] intValue];
		if ([[rawData objectForKey: key] objectForKey:@"WEP"]) {
			wifiData.privacy = @"WEP";
		}
		else {
			wifiData.privacy = @"none";
		}
		wifiData.maxRate = [[[[rawData objectForKey: key] objectForKey:@"RATES"] lastObject] intValue];
		int age = [[[rawData objectForKey: key] objectForKey:@"AGE"] intValue];
		if(age == 0) {
			wifiData.lastSeen = [NSDate date];
		}
		wifiData.latitude = myLocationController.locationManager.location.coordinate.latitude;
		wifiData.longitude = myLocationController.locationManager.location.coordinate.longitude;
		
		[networkData setObject:wifiData forKey:wifiData.macAddress];
	}
}

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"inSSIDer_iOS" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"inSSIDer_iOS.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
	[wifiScanner release];
    
    [window release];
    [super dealloc];
}


@end

