//
//  VMAppDelegate.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *root;
@property (strong, nonatomic) NSNumber *userIsLoggedIn;

@end
