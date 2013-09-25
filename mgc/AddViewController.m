//
//  AddViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 6/19/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "AddViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define URL [NSURL URLWithString:@"http://calm-sea-9172.herokuapp.com/games.json"]
//#define URL [NSURL URLWithString:@"http://localhost:3000/games.json"]

@interface AddViewController ()

@end

@implementation AddViewController

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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (IBAction)popBack:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)postCourse:(id)sender{
	NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	NSString *name = self.name.text;
	NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithDouble:73.1234], @"latitude",
							  [NSNumber numberWithDouble:71.2343], @"longitude",
							  @"LocFromiPhone", @"name", nil];
	NSArray *locations = [NSArray arrayWithObjects:location, nil];
	NSDictionary *json = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
															 identifier, @"udid",
															 name, @"name",
															 locations, @"locations_attributes", nil] forKey:@"game"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSError *error;
	NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
	[request setHTTPBody:postData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	(void)connection;
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
