//
//  CurrentGameViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 6/21/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "CurrentGameViewController.h"
#import "ViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define URL [NSURL URLWithString:@"http://calm-sea-9172.herokuapp.com/ongoings.json"]
#define URL [NSURL URLWithString:@"http://localhost:3000/ongoings.json"]
//#define URL @"http://localhost:3000/users/%@.json"
//#define URL @"http://calm-sea-9172.herokuapp.com/users/%@.json"

@interface CurrentGameViewController ()

@end

@implementation CurrentGameViewController

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
	self.gameID = 0;
	// Do any additional setup after loading the view.
}

- (IBAction)backHome:(id)sender {
	ViewController *view = (ViewController *)[self.navigationController.viewControllers objectAtIndex:0];
	view.viewCurrent.hidden = NO;
	[self.navigationController popToViewController:view animated:YES];
}

- (IBAction)stopGame:(id)sender {
	//NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	NSString *identifier = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"];
	//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL, identifier]];
	NSDictionary *json = /*[NSDictionary dictionaryWithObject:*/
						  [NSDictionary dictionaryWithObject:identifier forKey:@"user_id"] /*forKey:@"ongoing"];*/;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	[request setHTTPMethod:@"DELETE"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSError *error;
	NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
	[request setHTTPBody:postData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	(void)connection;
	
	
	ViewController *view = (ViewController *)[self.navigationController.viewControllers objectAtIndex:0];
	view.viewCurrent.hidden = YES;
	[self.navigationController popToViewController:view animated:YES];
}

- (void)setInGame:(BOOL)inGame{
	self.inGame = inGame;
	if (inGame){
		NSLog(@"yes");
	}else{
		NSLog(@"no");
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
