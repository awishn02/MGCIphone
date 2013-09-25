//
//  ViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 6/19/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "ViewController.h"
#import "CourseViewController.h"
#import "RegisterViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define URL [NSURL URLWithString:@"http://calm-sea-9172.herokuapp.com/games.json"]
#define URL [NSURL URLWithString:@"http://localhost:3000/games.json"]

@interface ViewController ()

@end

@implementation ViewController
@synthesize registerController;

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
    // Do any additional setup after loading the view from its nib.
	self.viewCurrent.hidden = YES;
	self.games = [[NSMutableArray alloc] init];
	[self updateTable];
	[self performSelectorOnMainThread:@selector(LaunchTimer) withObject:nil waitUntilDone:NO];
	self.courseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"courseViewController"];
	[self setShouldRestart:NO];
	self.didWelcome = false;
	
	NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
	if(username == nil){
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentPath = [searchPaths objectAtIndex:0];
		NSString* file = [documentPath stringByAppendingPathComponent:@"user.plist"];
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:file];
		if(!fileExists){
			NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
			NSArray *major = [[NSArray alloc] initWithContentsOfFile:path];
			[major writeToFile:file atomically:YES];
		}
		self.registerController = [self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
		[self.registerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
		[self presentViewController:self.registerController animated:YES completion:nil];
	}
}

- (void)displayAlert{
	self.alertView.hidden = false;
	CGRect frame = self.alertView.frame;
	frame.origin.y = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.alertView.frame = frame;
	[UIView commitAnimations];
}

- (void)dismissAlert{
	CGRect frame = self.alertView.frame;
	frame.origin.y = -100;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.alertView.frame = frame;
	[UIView commitAnimations];
	[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(hideAlert) userInfo:nil repeats:NO];
}

- (void)hideAlert{
	self.alertView.hidden = true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated{
	if(self.shouldRestart){
		[self updateTable];
		[self performSelectorOnMainThread:@selector(LaunchTimer) withObject:nil waitUntilDone:NO];
	}
	if(!self.didWelcome){
		NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
		self.alertLbl.text = [NSString stringWithFormat:@"Welcome back %@!", username];
		[self displayAlert];
		self.didWelcome = true;
		[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
	}
	
}

- (void)hideCurrentButton:(BOOL)shouldHide{
	
}

- (IBAction)backToCurrent:(id)sender {
}

- (void)LaunchTimer{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateTable) userInfo:nil repeats:YES];
}

- (void)updateTable{
	dispatch_async(DISPATCH_QUEUE,
				   ^{NSData *data = [NSData dataWithContentsOfURL: URL];
					   [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
				   });
}

- (void)fetchedData:(NSData *)responseData {
	NSError *error;
	self.games = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
	[self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	[self killTimer];
}

- (void)killTimer{
	if(self.timer){
		[self.timer invalidate];
		self.timer = nil;
		[self setShouldRestart:YES];
	}
}

/*
 * TableView Delegates
 *
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self killTimer];
	[self.courseViewController setGame:[self.games objectAtIndex:indexPath.row]];
	[self.courseViewController setCourseView];
	[self.navigationController pushViewController:self.courseViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create a cell
    UITableViewCell *cell = [[UITableViewCell alloc]
							 initWithStyle:UITableViewCellStyleDefault
							 reuseIdentifier:@"cell"];
	
    // fill it with contnets
    cell.textLabel.text = [[self.games objectAtIndex:indexPath.row] objectForKey:@"name"];
    // return it
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}

@end
