//
//  AppsDetailViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "AppsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AppsDetailViewController ()

@end

@implementation AppsDetailViewController
@synthesize app;
@synthesize appIconImage;
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
    
}

- (void)viewWillAppear:(BOOL)animated {
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end