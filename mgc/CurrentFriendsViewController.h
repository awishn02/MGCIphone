//
//  CurrentFriendsViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 7/20/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *users;
@property IBOutlet UITableView *tableView;
@property NSTimer *timer;
@property NSString *game;

- (void)updateTable;
- (void)LaunchTimer;
- (void)killTimer;
@end
