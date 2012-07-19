//
//  MyVMViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyVMViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

#define USER_KEY @"user"

@interface MyVMViewController ()

@end

@implementation MyVMViewController
@synthesize backgroundImageView = _backgroundImageView;
@synthesize profileImageView = _profileImageView;

@synthesize user = _user;
@synthesize loginButton = _loginButton;
@synthesize flag = _flag;


#pragma mark - View Life Cycle

//+ (id)sharedInstance {
//	static MyVMViewController *__sharedInstance;
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		__sharedInstance = [[MyVMViewController alloc] initWithNibName:@"MyVMViewController" bundle:nil];
//	});
//	return __sharedInstance;
//}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)setupLogin {
	[self.loginButton addTarget:self action:@selector(presentLoginScreen) forControlEvents:UIControlEventTouchUpInside];
	if ([User loggedIn]) {
		self.user = [[User alloc] initWithDictionaryFromUser:[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY]];
		[self.loginButton setHidden:YES];
		NSLog(@"User is logged in");
	} else {
		[self presentLoginScreen];
	}
}

- (void)setupProfileColors {
	// Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    // Customize backgrounds
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    
    // Set profile picture aspects.
    self.profileImageView.layer.borderWidth = 2.5;
    self.profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.profileImageView.layer.cornerRadius = 2;
    //self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.profileImageView.layer.shadowOpacity = 0.95;
    self.profileImageView.layer.shadowRadius = 2.0;
    self.profileImageView.layer.shadowOffset = CGSizeMake(0, 1.0);
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // If the user isn't logged in yet, log them in
    if (!self.flag) {
        [self setupLogin];
        self.flag = YES;
    }
    
}


- (void) viewDidLoad {
    [super viewDidLoad];
	[self setupProfileColors];
}


- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [self setProfileImageView:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)presentLoginScreen {
	LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:loginViewController animated:YES];
}

- (void)setupUserInterface {
	
}


@end
