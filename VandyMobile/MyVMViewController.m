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
#import "TeamTableViewController.h"
#import "MeetingsAPIClient.h"

#define USER_KEY    @"user"
#define USERS_KEY   @"users"
#define EMAIL_KEY   @"email"
#define NAME_KEY    @"name"
#define ID_KEY      @"id"
#define REPO_KEY    @"repo_url"
#define APP_KEY     @"app"
#define IMAGE_KEY   @"image_url"

@interface MyVMViewController ()

@property BOOL loaded;

@end

@implementation MyVMViewController
@synthesize backgroundImageView = _backgroundImageView;
@synthesize profilePictureContainerView = _profilePictureContainerView;
@synthesize profilePictureBorderContainerView = _profilePictureBorderContainerView;
@synthesize emailLabel = _emailLabel;
@synthesize appNameLabel = _appNameLabel;
@synthesize teamButton = _teamButton;
@synthesize commitsButton = _commitsButton;
@synthesize settingsButton = _settingsButton;

@synthesize user = _user;
@synthesize selectedTeamIndex = _selectedTeamIndex;
@synthesize selectedTeammates = _selectedTeammates;
@synthesize repoURLs = _repoURLs;

@synthesize loginButton = _loginButton;
@synthesize logoutButton = _logoutButton;
@synthesize loggedInView = _loggedInView;
@synthesize appImageView = _appImageView;

@synthesize loaded = _loaded;
@synthesize allTeammates = _allTeammates;
@synthesize teamNames = _teamNames;
@synthesize appImageURLs = _appImageURLs;


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
    self.profilePictureContainerView.layer.borderWidth = 2.5;
    self.profilePictureContainerView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profilePictureContainerView.layer.cornerRadius = 5;
    self.profilePictureContainerView.clipsToBounds = YES;
    
    self.profilePictureBorderContainerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.profilePictureBorderContainerView.layer.shadowOpacity = 0.95;
    self.profilePictureBorderContainerView.layer.shadowRadius = 2.0;
    self.profilePictureBorderContainerView.layer.shadowOffset = CGSizeMake(0, 1.0);
    
}

- (void)setupUserInterface {
    self.loggedInView.hidden = NO;
	self.emailLabel.text = self.user.email;
//    self.appNameLabel.text = self.user.app;
    [self pullTeamsFromServer];

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
    if (self.user) {
        [self pullTeamsFromServer];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Set the logo on the navigation bar
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VandyMobileTextNeue"]];
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
	[self setLoginButton:nil];
	[self setEmailLabel:nil];
    [self setAppNameLabel:nil];
    [self setCommitsButton:nil];
    [self setProfilePictureContainerView:nil];
    [self setProfilePictureBorderContainerView:nil];
    [self setTeamButton:nil];
    [self setSettingsButton:nil];
    [self setAppImageView:nil];
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

- (void)downloadPhotoForURL:(NSString *)urlString andImageView:(UIImageView *)imageView {
    // Download photo
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loading startAnimating];
    UIBarButtonItem * temp = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loading];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSData *imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:[UIImage imageWithData:imgUrl]];
            [loading stopAnimating];
            self.navigationItem.leftBarButtonItem = temp;
        });
    });
    dispatch_release(downloadQueue);
    
}

/* By default, use the team at index 0 */
- (void)setupDefaultTeam {
    int buttonIndex = 0;
    self.selectedTeamIndex = buttonIndex;
    self.appNameLabel.text = [self.teamNames objectAtIndex:buttonIndex];
    self.selectedTeammates = [self.allTeammates objectAtIndex:buttonIndex];
    NSString *currentAppImageURL = [self.appImageURLs objectAtIndex:buttonIndex];
    [self downloadPhotoForURL:currentAppImageURL andImageView:self.appImageView];
}

#pragma mark - myVMButton Methods

- (void)setupMyVMButtons {
    [self.commitsButton addTarget:self action:@selector(commitsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.teamButton addTarget:self action:@selector(teamButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)settingsButtonTapped {
    if (self.teamNames.count > 0) {
        UIActionSheet *as = [[UIActionSheet alloc] init];
        for (NSString *teamName in self.teamNames) {
            [as addButtonWithTitle:teamName];
        }
        [as addButtonWithTitle:@"Cancel"];
        [as setDelegate:self];
        [as setCancelButtonIndex:self.teamNames.count];
        [as showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)commitsButtonTapped {
    GithubRepoTableViewController *repoTVC = [[GithubRepoTableViewController alloc] initWithNibName:@"GithubRepoTableViewController" bundle:nil];
    repoTVC.title = @"Commits";
    repoTVC.repoURL = [self.repoURLs objectAtIndex:self.selectedTeamIndex];
    [self.navigationController pushViewController:repoTVC animated:YES];
}

- (void)teamButtonTapped {
    TeamTableViewController * teamTVC = [[TeamTableViewController alloc] initWithNibName:@"TeamTableViewController" bundle:nil];
    teamTVC.title = @"Team";
    teamTVC.teamNames = self.teamNames;
    teamTVC.teammates = self.allTeammates;
    [self.navigationController pushViewController:teamTVC animated:YES];
}

- (IBAction)devTeamButtonPressed {
    [self createMailComposer];
}

#pragma mark - ActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < self.teamNames.count) {
        self.selectedTeamIndex = buttonIndex;
        self.appNameLabel.text = [self.teamNames objectAtIndex:buttonIndex];
        self.selectedTeammates = [self.allTeammates objectAtIndex:buttonIndex];
        NSString *currentAppImageURL = [self.appImageURLs objectAtIndex:buttonIndex];
        [self downloadPhotoForURL:currentAppImageURL andImageView:self.appImageView];
    }
}

#pragma mark - Email Team Methods
- (void)createMailComposer {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        //        [mailer setSubject:[NSString stringWithFormat:@"[VandyMobile] [%@]", self.user.app]];
        
        NSMutableArray *recipientStrings = [NSMutableArray arrayWithCapacity:[self.selectedTeammates count]];
        for (NSDictionary *dict in self.selectedTeammates) {
            [recipientStrings addObject:[dict objectForKey:@"email"]];
        }
        [mailer setToRecipients:recipientStrings];
        
        //UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        
        NSString *emailBody = @"\n\n\nSent from the VandyMobile App";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - APIClient Methods

- (void)pullTeamsFromServer {
        NSString *path = @"teams.json";
        [[MeetingsAPIClient sharedInstance] getPath:path parameters:nil
                                            success:^(AFHTTPRequestOperation *operation, id response) {
                                                NSLog(@"Response: %@", response);
                                                NSMutableArray *resultsTeamNames = [NSMutableArray array];
                                                NSMutableArray *resultsTeammates = [NSMutableArray array];
                                                NSMutableArray *resultsRepoURLs = [NSMutableArray array];
                                                NSMutableArray *resultsImageURLs = [NSMutableArray array];

                                                for (int i=0; i < [response count]; i++) {
                                                    NSNumber *teamId = [[response objectAtIndex:i] objectForKey:ID_KEY];
                                                    if ([self.user.teamIds containsObject:teamId]) {
                                                        NSString *teamName = [[response objectAtIndex:i] objectForKey:NAME_KEY];
                                                        NSArray *teammates = [[response objectAtIndex:i] objectForKey:USERS_KEY];
                                                        NSArray *repoURL = [[[response objectAtIndex:i] objectForKey:APP_KEY ] objectForKey:REPO_KEY];
                                                        NSArray *imageURL = [[[response objectAtIndex:i] objectForKey:APP_KEY ] objectForKey:IMAGE_KEY];

                                                        [resultsTeamNames addObject:teamName];
                                                        [resultsTeammates addObject:teammates];
                                                        [resultsRepoURLs addObject:repoURL];
                                                        [resultsImageURLs addObject:imageURL];
                                                    }
                                                }
                                                self.teamNames = resultsTeamNames;
                                                self.allTeammates = resultsTeammates;
                                                self.repoURLs = resultsRepoURLs;
                                                self.appImageURLs = resultsImageURLs;
                                                [self setupDefaultTeam];


                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                NSLog(@"%@",error);
                                            }];
        
    }

@end
