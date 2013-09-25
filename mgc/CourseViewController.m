//
//  CourseViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 6/21/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "CourseViewController.h"
#import "ViewController.h"
#import "CurrentGameViewController.h"
#import "CurrentMapViewController.h"
#import "CurrentFriendsViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define URL [NSURL URLWithString:@"http://calm-sea-9172.herokuapp.com/ongoings.json"]
#define URL [NSURL URLWithString:@"http://localhost:3000/ongoings.json"]
//#define URL @"http://calm-sea-9172.herokuapp.com/users/%@.json"
//#define URL @"http://localhost:3000/users/%@.json"
@interface CourseViewController ()

@end

@implementation CourseViewController

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
	[self setCourseView];
}

- (void)setCourseView {
	self.gameTitle.text = [self.game objectForKey:@"name"];
	locArray = [self.game objectForKey:@"locations"];
	[self.locations setDataSource:self];
	[self.locations setDelegate:self];
	[self.locations reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if([segue.identifier isEqualToString:@"startGame"]){
		//NSLog(@"yee boi");
		UITabBarController *view = segue.destinationViewController;
		CurrentGameViewController * gameView = view.childViewControllers[0];
		[gameView setGame:self.game];
		CurrentMapViewController *mapView = view.childViewControllers[1];
		[mapView setLocations:locArray];
		CurrentFriendsViewController *friendsView = view.childViewControllers[2];
		[friendsView setGame:[self.game objectForKey:@"id"]];
	}
}

- (IBAction)startGame:(id)sender {
	ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
	[viewController.viewCurrent setHidden:NO];
	//NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	NSString *identifier = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_id"];
	//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL, identifier]];
	NSDictionary *json = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
															 [self.game objectForKey:@"id"], @"game_id",
															 identifier, @"user_id",
															 nil] forKey:@"ongoing"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSError *error;
	NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
	[request setHTTPBody:postData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	(void)connection;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backHome:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return locArray.count-1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[self.courseViewController setGame:[self.games objectAtIndex:indexPath.row]];
	//[self.navigationController pushViewController:self.courseViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create a cell
    UITableViewCell *cell = [[UITableViewCell alloc]
							 initWithStyle:UITableViewCellStyleDefault
							 reuseIdentifier:@"cell"];
	
    // fill it with contnets
    cell.textLabel.text = [[locArray objectAtIndex:indexPath.row+1] objectForKey:@"name"];
    // return it
    return cell;
}

@end
