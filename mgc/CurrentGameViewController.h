//
//  CurrentGameViewController.h
//  mgc
//
//  Created by Aaron Wishnick on 6/21/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentGameViewController : UIViewController

@property (nonatomic) BOOL inGame;
@property NSInteger gameID;

@property NSDictionary *game;

- (IBAction)backHome:(id)sender;
- (IBAction)stopGame:(id)sender;

@end
