//
//  LocationController.h
//  inSSIDer.iOS
//
//  Created by Ben Bower on 8/12/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;  

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end
