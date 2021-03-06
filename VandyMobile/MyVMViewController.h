//
//  MyVMViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <MessageUI/MessageUI.h>

@interface MyVMViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
//+ (id)sharedInstance;

@property (strong, nonatomic) User *user;
@property (nonatomic) int selectedTeamIndex;
@property (strong, nonatomic) NSArray *selectedTeammates;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UIView *loggedInView;
@property (strong, nonatomic) IBOutlet UIImageView *appImageView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *profilePictureContainerView;
@property (weak, nonatomic) IBOutlet UIView *profilePictureBorderContainerView;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@property (strong, nonatomic) IBOutlet UIButton *teamButton;
@property (strong, nonatomic) IBOutlet UIButton *commitsButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) NSArray *allTeammates;
@property (strong, nonatomic) NSArray *teamNames;
@property (strong, nonatomic) NSArray *repoURLs;
@property (strong, nonatomic) NSArray *appImageURLs;

@end
