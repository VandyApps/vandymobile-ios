//
//  AppsDetailViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "AppsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Sizer.h"

@interface AppsDetailViewController ()

@end

@implementation AppsDetailViewController
@synthesize app;
@synthesize appIconImage;
@synthesize descriptionTextView;
@synthesize belowTextViewContainerView;
@synthesize teamLabel;
@synthesize nameLabel;
@synthesize taglineLabel;
@synthesize appStoreButton;
@synthesize teamButton;
@synthesize backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // UI Customization
    self.backgroundView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NewNavBar4"] forBarMetrics:UIBarMetricsDefault];
    
    self.appIconImage.layer.cornerRadius = 11;
    self.appIconImage.clipsToBounds = YES;
    self.appIconImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.appIconImage.layer.borderWidth = .5;
    
    self.descriptionTextView.layer.cornerRadius = 11;
    self.descriptionTextView.clipsToBounds = YES;
    self.descriptionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = .5;
    
    // Set labels
    self.teamLabel.text = app.team;
    self.nameLabel.text = app.name;
    self.taglineLabel.text = app.tagline;
    self.descriptionTextView.text = app.description;
    
    // Size textview
    self.descriptionTextView.frame = [Sizer sizeTextView:self.descriptionTextView];
    CGFloat newYOrigin = self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 6;
    self.belowTextViewContainerView.frame = CGRectMake(self.belowTextViewContainerView.frame.origin.x,
                                                       newYOrigin,
                                                       self.belowTextViewContainerView.frame.size.width,
                                                       self.belowTextViewContainerView.frame.size.height) ;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Code to manage Nav Bar logo
    
    NSArray *navSubviews = [self.navigationController.navigationBar subviews];
    //    NSLog(@"%@", navSubviews);
    for (UIView * subview in navSubviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)viewDidUnload
{
    [self setBackgroundView:nil];
    [self setAppIconImage:nil];
    [self setDescriptionTextView:nil];
    [self setTeamButton:nil];
    [self setAppStoreButton:nil];
    [self setTeamLabel:nil];
    [self setNameLabel:nil];
    [self setTaglineLabel:nil];
    [self setBelowTextViewContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
