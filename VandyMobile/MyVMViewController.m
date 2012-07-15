//
//  MyVMViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyVMViewController.h"
#import "LoginViewController.h"

#define USER_KEY @"user"

@interface MyVMViewController ()

@end

@implementation MyVMViewController

@synthesize user = _user;

#pragma mark - View Life Cycle

//+ (id)sharedInstance {
//	static MyVMViewController *__sharedInstance;
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		__sharedInstance = [[MyVMViewController alloc] initWithNibName:@"MyVMViewController" bundle:nil];
//	});
//	return __sharedInstance;
//}
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupLogin];
}

- (void)viewDidUnload {
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
