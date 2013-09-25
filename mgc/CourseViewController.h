//
//  CourseViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 6/21/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSArray *locArray;
}
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property NSDictionary *game;
@property IBOutlet UITableView *locations;

- (void)setCourseView;
- (IBAction)startGame:(id)sender;

@end
