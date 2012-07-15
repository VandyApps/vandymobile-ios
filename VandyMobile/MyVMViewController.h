//
//  MyVMViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MGTileMenuController.h"

@interface MyVMViewController : UIViewController  <MGTileMenuDelegate, UIGestureRecognizerDelegate>

+ (id)sharedInstance;
- (void)updateCredentials;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UILabel *loggedInLabel;

@property (strong, nonatomic) MGTileMenuController *tileController;




@end
