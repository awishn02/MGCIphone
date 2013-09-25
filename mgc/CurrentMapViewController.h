//
//  CurrentMapViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 6/24/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddressAnnotation.h"

@interface CurrentMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
	MKMapView *map;
}

@property NSArray *locations;

@end
