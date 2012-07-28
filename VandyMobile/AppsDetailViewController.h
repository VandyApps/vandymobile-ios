//
//  AppsDetailViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import <MessageUI/MessageUI.h>

@interface AppsDetailViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) App *app;

// Outlets
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *appIconImage;
@property (weak, nonatomic) IBOutlet UIView *appIconImageContainerView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *belowTextViewContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *envelopeImageView;

// Labels
@property (weak, nonatomic) IBOutlet UIView *labelsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;


// Buttons
@property (weak, nonatomic) IBOutlet UIButton *appStoreButton;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;

@end
