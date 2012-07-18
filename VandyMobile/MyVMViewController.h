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

//+ (id)sharedInstance;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) MGTileMenuController *tileController;


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property BOOL flag;

@end
