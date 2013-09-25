//
//  CurrentFriendsViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 7/20/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "CurrentFriendsViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define URL [NSURL URLWithString:@"http://calm-sea-9172.herokuapp.com/ingame.json"]
//#define URL [NSURL URLWithString:@"http://localhost:3000/users/ingame/%@/%@.json"]
//#define URL @"http://localhost:3000/users/inGame/%@/%@.json"
//#define URL @"http://calm-sea-9172.herokuapp.com/users/inGame/%@/%@.json"

@interface CurrentFriendsViewController ()

@end

@implementation CurrentFriendsViewController

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
	self.users =[[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
	[self updateTable];
	[self performSelectorOnMainThread:@selector(LaunchTimer) withObject:nil waitUntilDone:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
	[self killTimer];
}

- (void)killTimer {
	if(self.timer){
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)LaunchTimer{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateTable) userInfo:nil repeats:YES];
}

- (void)updateTable{
	NSString *user_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
	//NSString *game_id = [NSString stringWithFormat:@"%d", self.game];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL,self.game,user_id]];
	dispatch_async(DISPATCH_QUEUE,
				   ^{NSData *data = [NSData dataWithContentsOfURL: url];
					   [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
				   });
}

- (void)fetchedData:(NSData *)responseData {
	NSError *error;
	self.users = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
	//NSLog(@"%@",[[self.users objectAtIndex:0] objectForKey:@"username"]);
	[self.tableView reloadData];
}

/*
 * TableView Delegates
 *
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[self killTimer];
	//[self.courseViewController setGame:[self.games objectAtIndex:indexPath.row]];
	//[self.courseViewController setCourseView];
	//[self.navigationController pushViewController:self.courseViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create a cell
    UITableViewCell *cell = [[UITableViewCell alloc]
							 initWithStyle:UITableViewCellStyleDefault
							 reuseIdentifier:@"cell"];
	
    // fill it with contnets
    cell.textLabel.text = [[self.users objectAtIndex:indexPath.row] objectForKey:@"username"];
    // return it
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

@end
