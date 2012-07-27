//
//  MyVMViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MyVMViewController : UIViewController  
//+ (id)sharedInstance;

@property (strong, nonatomic) IBOutlet UIButton *appsButton;

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UIView *loggedInView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@end
