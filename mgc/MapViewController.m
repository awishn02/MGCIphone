//
//  MapViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 6/21/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	map = [[MKMapView alloc] initWithFrame:self.view.bounds];
	map.mapType = MKMapTypeStandard;
	[map setShowsUserLocation:YES];
	[map setDelegate:self];
	[map setZoomEnabled:YES];
	[map setScrollEnabled:YES];
	[self.view addSubview:map];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
	[mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
	
    MKCoordinateSpan span;
    span.latitudeDelta  = .01; // Change these values to change the zoom
    span.longitudeDelta = .01;
    region.span = span;
	
	[mapView setRegion:region animated:YES];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
