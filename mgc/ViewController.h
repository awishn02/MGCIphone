//
//  ViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 6/19/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseViewController;
@class RegisterViewController;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *games;
@property IBOutlet UITableView *tableView;
@property IBOutlet UIButton *viewCurrent;
@property IBOutlet UIView *alertView;
@property IBOutlet UITextField *alertLbl;
@property (strong, nonatomic) CourseViewController *courseViewController;
@property (strong, nonatomic) RegisterViewController *registerController;
@property (nonatomic) BOOL hideButton;
@property (nonatomic) BOOL didWelcome;
@property NSTimer *timer;
@property (nonatomic) BOOL shouldRestart;
- (void)updateTable;
- (void)LaunchTimer;
- (void)killTimer;
- (void)hideCurrentButton:(BOOL)shouldHide;
- (IBAction)backToCurrent:(id)sender;

@end
