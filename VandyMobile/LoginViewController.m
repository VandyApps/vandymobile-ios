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
@synthesize closeButton;

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

}

- (void)closeLoginScreen {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
	[super viewDidUnload];
}
@end
