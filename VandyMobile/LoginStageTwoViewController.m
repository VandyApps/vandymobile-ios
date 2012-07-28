//
//  LoginStageTwoViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/27/12.
//
//

#import "LoginStageTwoViewController.h"
#import "UserAPIClient.h"
#import "MyVMViewController.h"
#import "User.h"
#import "SVProgressHUD.h"

#define USER_KEY @"user"

@interface LoginStageTwoViewController ()

@end

/* TextField tags */
enum LoginViewControllerTags {
	LoginViewController_UsernameTag = 0,
	LoginViewController_PasswordTag,
};

@implementation LoginStageTwoViewController

@synthesize userInput = _userInput;
@synthesize passwordInput = _passwordInput;
@synthesize loginButton = _loginButton;
@synthesize loginTableView = _loginTableView;
@synthesize delegate = _delegate;

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
    
	[self setupTextfields];
	[self setupButtons];
    self.loginTableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserInput:nil];
	[self setPasswordInput:nil];
	[self setLoginButton:nil];
    [self setLoginTableView:nil];
    [super viewDidUnload];
}

- (void)setupTextfields {
	self.userInput.delegate = self;
	self.userInput.tag = LoginViewController_UsernameTag;
	self.passwordInput.tag = LoginViewController_PasswordTag;
	self.passwordInput.delegate = self;
    self.passwordInput.secureTextEntry = YES;
}

- (void)setupButtons {
	//self.closeButton.transform = CGAffineTransformMakeRotation(M_PI_4);
	[self.closeButton addTarget:self action:@selector(closeLoginScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
	[self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginTapped {
	[SVProgressHUD showWithStatus:@"Logging In"];
	NSLog(@"Username = %@", self.userInput.text);
	NSLog(@"Password = %@", self.passwordInput.text);
	[[UserAPIClient sharedInstance] authorizeUser:self.userInput.text
									 withPassword:self.passwordInput.text
							  withCompletionBlock:^(id response){
								  User *user = [[User alloc] initWithResponse:response];
                                  //								  [[MyVMViewController sharedInstance] setUser:user];
								  [[NSUserDefaults standardUserDefaults] setObject:[user userDictionary] forKey:USER_KEY];
								  [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedIn" object:self];
								  [self closeLoginScreen];
                              }];
}

- (IBAction)registerPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration closed." message:@"Check back soon!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

- (void)closeLoginScreen {
	[self.delegate dismissModalViewControllerAnimated:YES];
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //    int tag = textField.tag;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//	CGPoint contentOffset = CGPointMake(0, 35*textField.tag);
// 	[self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//	CGPoint contentOffset = CGPointMake(0, 0);
//	[self.scrollView setContentOffset:contentOffset animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


@end
