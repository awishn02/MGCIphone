//
//  MapViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 6/21/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
	MKMapView *map;
}

@end