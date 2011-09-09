//
//  inSSIDer_iOSAppDelegate.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 5/6/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WiFiScanner.h"
#import "NetworksTableViewController.h"
#import "WifiData.h"
#import "LocationController.h"

@interface inSSIDer_iOSAppDelegate : NSObject <UIApplicationDelegate> {
	NSMutableDictionary *networkData;
	LocationController *myLocationController;
    
    UIWindow *window;
	NSNotificationCenter *nc;
	UIView *myMainView;
	dispatch_queue_t myQueue;
	NetworksTableViewController *ntvc;
	
	WiFiScanner *wifiScanner;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NetworksTableViewController *ntvc;
@property (nonatomic, retain) IBOutlet UIView *myMainView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *myScanButton;
@property (nonatomic, retain) WiFiScanner *wifiScanner;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (IBAction)myScanButtonPressed:(id)sender;
- (void)displayNewData:(NSMutableDictionary *)data;
- (NSURL *)applicationDocumentsDirectory;
- (void)processRawData:(NSMutableDictionary *)rawData;
- (void)saveContext;

@end

