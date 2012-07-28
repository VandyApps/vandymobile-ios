//
//  LoginViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/22/12.
//
//

#import "LoginViewController.h"
#import "LoginStageTwoViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize closeButton = _closeButton;
@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;

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

- (IBAction)loginWithVUnetIDPressed {
    LoginStageTwoViewController *stageTwo = [[LoginStageTwoViewController alloc] init];
    stageTwo.delegate = self.delegate;
    stageTwo.title = @"Login w/ Email";
    stageTwo.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:stageTwo animated:YES];
}


- (void)setupButtons {
	//self.closeButton.transform = CGAffineTransformMakeRotation(M_PI_4);
	[self.closeButton addTarget:self action:@selector(closeLoginScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeLoginScreen)];
    
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupButtons];
	[self setupScrollView];
}

- (void)closeLoginScreen {
	[self.delegate dismissModalViewControllerAnimated:YES];
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
	[self setScrollView:nil];
	[super viewDidUnload];
}

@end
