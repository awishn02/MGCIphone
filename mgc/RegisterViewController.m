//
//  RegisterViewController.m
//  mgc
//
//  Created by Aaron Wishnick on 7/20/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "RegisterViewController.h"

#define DISPATCH_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define URL [NSURL URLWithString:@"http://calm-sea-9172.herokuapp.com/users.json"]
//#define URL [NSURL URLWithString:@"http://localhost:3000/users.json"]

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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

- (IBAction)submit:(id)sender{
	BOOL error = false;
	if ([self.username.text isEqualToString:@""]){
		error = true;
		self.errorVal.text = @"You must enter a username.";
	}
	if(error){
		[self displayError];
	}else{
		self.error.hidden = true;
		[self createUser];
	}
}

- (void)displayError{
	self.error.hidden = false;
	CGRect frame = self.error.frame;
	frame.origin.y = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	self.error.frame = frame;
	[UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(didEnterForeground:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void)didEnterForeground:(BOOL)animated{
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	if (username == nil){
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (BOOL)createUser{
	self.response = [NSMutableData data];
	//NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	NSString *email = self.email.text;
	NSString *username = self.username.text;
	NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSDictionary dictionaryWithObjectsAndKeys:
						  email, @"email",
						  username, @"username", nil], @"user", nil];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSError *error;
	NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
	[request setHTTPBody:postData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	(void)connection;
	return true;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	//NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self.response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSString *responseString = [[NSString alloc] initWithData:self.response encoding:NSUTF8StringEncoding];
	//NSLog(responseString);
	NSError *error;
	NSDictionary *respArr = [NSJSONSerialization JSONObjectWithData:self.response options:kNilOptions error:&error];
	if([[respArr objectForKey:@"message"] isEqualToString:@"Username exists"]){
		self.errorVal.text = @"That username already exists.";
		[self displayError];
	}else if([[respArr objectForKey:@"message"] isEqualToString:@"Udid exists"]){
		self.errorVal.text = [NSString stringWithFormat:@"You have already created an account, check your email to confirm and log in."];
		[self displayError];
		//[self dismissViewControllerAnimated:YES completion:nil];
	}else{
		//NSString *documentPath = [searchPaths objectAtIndex:0];
		//NSString* file = [documentPath stringByAppendingPathComponent:@"user.plist"];
		//NSDictionary *toSave = [[NSDictionary alloc] initWithObjectsAndKeys:[respArr objectForKey:@"id"], @"id", [respArr objectForKey:@"username"], @"username", nil];
		[[NSUserDefaults standardUserDefaults]setObject:[respArr objectForKey:@"username"] forKey:@"username"];
		[[NSUserDefaults standardUserDefaults]setObject:[respArr objectForKey:@"id"] forKey:@"user_id"];
		[self dismissViewControllerAnimated:YES completion:nil];
	}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
