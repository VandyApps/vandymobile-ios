//
//  LoginViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/22/12.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize closeButton = _closeButton;
@synthesize userInput = _userInput;
@synthesize passwordInput = _passwordInput;
@synthesize loginButton = _loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.closeButton.transform = CGAffineTransformMakeRotation(M_PI_4);
	[self.closeButton addTarget:self action:@selector(closeLoginScreen) forControlEvents:UIControlEventTouchUpInside];
	[self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlStateNormal];

}

- (void)closeLoginScreen {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)loginTapped {
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
	[self setCloseButton:nil];
	[self setUserInput:nil];
	[self setPasswordInput:nil];
	[self setLoginButton:nil];
	[super viewDidUnload];
}
@end
