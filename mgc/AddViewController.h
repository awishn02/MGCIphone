//
//  AddViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 6/19/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

- (IBAction)popBack:(id)sender;
- (IBAction)postCourse:(id)sender;

@property IBOutlet UITextField *name;

@end
