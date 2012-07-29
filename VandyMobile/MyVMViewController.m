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
#import "GithubRepoTableViewController.h"

#define USER_KEY @"user"

@interface MyVMViewController ()

@property BOOL loaded;

@end

@implementation MyVMViewController
@synthesize backgroundImageView = _backgroundImageView;
@synthesize profileImageView = _profileImageView;
@synthesize emailLabel = _emailLabel;
@synthesize appNameLabel = _appNameLabel;
@synthesize commitsButton = _commitsButton;

@synthesize user = _user;
@synthesize loginButton = _loginButton;
@synthesize logoutButton = _logoutButton;
@synthesize loggedInView = _loggedInView;


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

#pragma mark - Notifications

- (void)setupNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserLoggedIn)
												 name:@"loggedIn" 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserLoggedOut)
												 name:@"loggedOut" 
											   object:nil];
}

- (void)handleUserLoggedIn {
	self.user = [[User alloc] initWithDictionaryFromUser:[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY]];
	[self setupUserInterface];
	[self.loggedInView setHidden:NO];
	[self.loginButton setHidden:YES];
	[self setupLogoutButton];
}

- (void)handleUserLoggedOut {
	[self.loggedInView setHidden:YES];
	[self.loginButton setHidden:NO];
	[self.navigationItem setRightBarButtonItem:nil];
}

#pragma mark - View Life Cycle

- (void)setupLoginViews {
	[self.loginButton addTarget:self action:@selector(presentLoginScreen) forControlEvents:UIControlEventTouchUpInside];
	if ([User loggedIn]) {
		self.user = [[User alloc] initWithDictionaryFromUser:[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY]];
		[self.loginButton setHidden:YES];
		[self setupUserInterface];
		[self setupLogoutButton];

	} else {
		[self presentLoginScreen];
		[self.loggedInView setHidden:YES];
	}
}

- (void)setupLogoutButton {
	// Create add meeting button
	self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log" style:UIBarButtonItemStyleDone target:self action:@selector(logoutTapped)];
    
	[self.navigationItem setRightBarButtonItem:self.logoutButton animated:NO];
}

- (void)setupMyVMButtons {
    [self.commitsButton addTarget:self action:@selector(commitsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commitsButtonTapped {
    GithubRepoTableViewController *repoTVC = [[GithubRepoTableViewController alloc] initWithNibName:@"GithubRepoTableViewController" bundle:nil];
    repoTVC.title = @"Commits";
    [self.navigationController pushViewController:repoTVC animated:YES];
}

- (void)logoutTapped {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_KEY];
	self.user = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"loggedOut" object:nil];
	[self presentLoginScreen];
}

- (void)setupProfileColors {
	// Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    // Customize backgrounds
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    
    // Set profile picture aspects.
    self.profileImageView.layer.borderWidth = 2.5;
    self.profileImageView.layer.borderColor = [[UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1] /*#ecd28b*/ CGColor];
    //self.profileImageView.layer.cornerRadius = 2;
    //self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.profileImageView.layer.shadowOpacity = 0.95;
    self.profileImageView.layer.shadowRadius = 2.0;
    self.profileImageView.layer.shadowOffset = CGSizeMake(0, 1.0);
    
}

- (void)setupUserInterface {
    self.loggedInView.hidden = NO;
	self.emailLabel.text = self.user.email;
    self.appNameLabel.text = self.user.app;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.loaded) {
        self.loaded = YES;
        [self setupLoginViews];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.loggedInView.hidden = YES;
	[self setupNotifications];
	[self setupProfileColors];
    [self setupMyVMButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Set the logo on the navigation bar
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewNavBarText"]];
    if ([[self.navigationController.navigationBar subviews] count] > 2) {
        NSArray *navSubviews = [self.navigationController.navigationBar subviews];
        
        for (UIView * subview in navSubviews) {
            if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.navigationController.navigationBar addSubview:logo];
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [self setProfileImageView:nil];
	[self setLoginButton:nil];
	[self setEmailLabel:nil];
    [self setAppNameLabel:nil];
    [self setCommitsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)presentLoginScreen {
	LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    loginViewController.delegate = self;
    loginViewController.title = @"Log In";
    
    UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    // Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [loginNavigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
	[self presentModalViewController:loginNavigationController animated:YES];
}



@end
