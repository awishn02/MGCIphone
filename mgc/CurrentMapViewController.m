//
//  CurrentMapViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 6/24/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "CurrentMapViewController.h"

@interface CurrentMapViewController ()

@end

@implementation CurrentMapViewController

CLLocationManager *_locationManager;
NSMutableArray *_regionArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
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
    [map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
	[self.view addSubview:map];
	//_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleLongPress:)];
	lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
	[map addGestureRecognizer:lpgr];
	
    [self initializeLocationManager];
    NSArray *geofences = [self buildGeofenceData];
	_regionArray = [[NSMutableArray alloc] initWithArray:geofences];
    [self initializeRegionMonitoring:geofences];
    [self initializeLocationUpdates];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
	
    CGPoint touchPoint = [gestureRecognizer locationInView:map];
    CLLocationCoordinate2D touchMapCoordinate =
	[map convertPoint:touchPoint toCoordinateFromView:map];
	
    AddressAnnotation *annot = [[AddressAnnotation alloc] initWithCoordinate:touchMapCoordinate withTitle:[NSString stringWithFormat:@"%f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude]];
    [map addAnnotation:annot];
}

- (void)initializeLocationManager {
    // Check to ensure location services are enabled
    if(![CLLocationManager locationServicesEnabled]) {
        [self showAlertWithMessage:@"You need to enable location services to use this app."];
        return;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}


- (void) initializeRegionMonitoring:(NSArray*)geofences {
    
    if (_locationManager == nil) {
        [NSException raise:@"Location Manager Not Initialized" format:@"You must initialize location manager first."];
    }
    
    for(CLCircularRegion *geofence in geofences) {
        [_locationManager startMonitoringForRegion:geofence];
    }
	
}

- (NSArray*) buildGeofenceData {
    NSMutableArray *geofences = [NSMutableArray array];
	BOOL show = false;
    for(NSDictionary *regionDict in self.locations) {
        CLCircularRegion *region = [self mapDictionaryToRegion:regionDict showAnnotation:show];
		show = true;
        [geofences addObject:region];
    }
    
    return [NSArray arrayWithArray:geofences];
}

- (CLCircularRegion*)mapDictionaryToRegion:(NSDictionary*)dictionary showAnnotation:(BOOL)show {
    NSString *title = [dictionary valueForKey:@"name"];
    
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
	
    CLLocationDistance regionRadius = 500.0;
	
	if(show){
		AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:centerCoordinate withTitle:title];
		[map addAnnotation:addAnnotation];
		MKCircle *circle = [MKCircle circleWithCenterCoordinate:centerCoordinate radius:20];
		[map addOverlay:circle];
	}
	
	return [[CLCircularRegion alloc] initWithCenter:centerCoordinate radius:regionRadius identifier:title];
}

- (void)initializeLocationUpdates {
    [_locationManager startUpdatingLocation];
}

#pragma mark - Location Manager - Region Task Methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLCircularRegion *)region {
    NSLog(@"Entered Region - %@", region.identifier);
    [self showRegionAlert:@"Entering Region" forRegion:region.identifier];
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	localNotification.alertBody = [NSString stringWithFormat:@"You've arrived at %@", region.identifier];
	[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLCircularRegion *)region {
    NSLog(@"Exited Region - %@", region.identifier);
    [self showRegionAlert:@"Exiting Region" forRegion:region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLCircularRegion *)region {
    NSLog(@"Started monitoring %@ region", region.identifier);
}

#pragma mark - Location Manager - Standard Task Methods


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	CLLocation *currentLocation = (CLLocation*)[locations lastObject];
	for (int i = 1; i < [_regionArray count]; i++){
		CLCircularRegion *region = [_regionArray objectAtIndex:i];
		//NSString *regionIdentifier = region.identifier;
		CLLocationCoordinate2D center = region.center;
		
		CLLocation *newLoc = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];

		CLLocationDistance distance = [currentLocation distanceFromLocation:newLoc];
		if (distance < 20.0){
			//NSLog(@"You are %f m from %@", distance, regionIdentifier);
			[_locationManager stopMonitoringForRegion:region];
			[self locationManager:_locationManager didEnterRegion:region];
			[_regionArray removeObject:region];
		}
    }
}

#pragma mark - Alert Methods

- (void) showRegionAlert:(NSString *)alertText forRegion:(NSString *)regionIdentifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:alertText
                                                      message:regionIdentifier
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)showAlertWithMessage:(NSString*)alertText {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Error"
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
