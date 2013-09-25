//
//  AppDelegate.h
//  mgc
//
//  Created by Aaron Wishnick on 6/19/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class AddViewController;
@class MapViewController;
@class CourseViewController;
@class CurrentGameViewController;
@class CurrentMapViewController;
@class CurrentFriendsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end
