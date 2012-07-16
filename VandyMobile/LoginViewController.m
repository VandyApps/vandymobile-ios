//
//  LoginViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/22/12.
//
//

#import "LoginViewController.h"
#import "UserAPIClient.h"
#import "MyVMViewController.h"
#import "User.h"

#define USER_KEY @"user"

/* TextField tags */
enum LoginViewControllerTags {
	LoginViewController_UsernameTag = 0,
	LoginViewController_PasswordTag,
};

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize closeButton = _closeButton;
@synthesize userInput = _userInput;
@synthesize passwordInput = _passwordInput;
@synthesize loginButton = _loginButton;
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)setupScrollView {
	self.scrollView.contentSize = CGSizeMake(320, 525);

}

- (void)setupTextfields {
	self.userInput.delegate = self;
	self.userInput.tag = LoginViewController_UsernameTag;
	self.passwordInput.tag = LoginViewController_PasswordTag;
	self.passwordInput.delegate = self;
}

- (void)setupButtons {
	self.closeButton.transform = CGAffineTransformMakeRotation(M_PI_4);
	[self.closeButton addTarget:self action:@selector(closeLoginScreen) forControlEvents:UIControlEventTouchUpInside];
	[self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupTextfields];
	[self setupButtons];
	[self setupScrollView];
}

- (void)closeLoginScreen {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)loginTapped {
	NSLog(@"Username = %@", self.userInput.text);
	NSLog(@"Password = %@", self.passwordInput.text);
	[[UserAPIClient sharedInstance] authorizeUser:self.userInput.text
									 withPassword:self.passwordInput.text 
							  withCompletionBlock:^(id response){
								  User *user = [[User alloc] initWithResponse:response];
								  [[NSUserDefaults standardUserDefaults] setObject:[user userDictionary] forKey:USER_KEY];
								  [self closeLoginScreen];
								  [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedIn" object:self];
							}];
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
	[self setScrollView:nil];
	[super viewDidUnload];
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
//    int tag = textField.tag;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	CGPoint contentOffset = CGPointMake(0, 35*textField.tag);
 	[self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	CGPoint contentOffset = CGPointMake(0, 0);
	[self.scrollView setContentOffset:contentOffset animated:NO];
}

@end
