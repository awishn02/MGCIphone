//
//  RegisterViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 7/20/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
- (IBAction)submit:(id)sender;
@property IBOutlet UITextField *username;
@property IBOutlet UITextField *email;
@property IBOutlet UIView *error;
@property IBOutlet UILabel *errorVal;
@property NSMutableData * response;
@end
