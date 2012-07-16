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
@synthesize loginButton = _loginButton;
@synthesize logoutButton = _logoutButton;
@synthesize loggedInLabel = _loggedInLabel;
@synthesize tileController = _tileController;


#pragma mark - View Life Cycle

+ (id)sharedInstance {
	static MyVMViewController *__sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[MyVMViewController alloc] initWithNibName:@"MyVMViewController" bundle:nil];
	});
	return __sharedInstance;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)setupNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateCredentials) 
                                                 name:@"LoggedIn"
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateCredentials) 
                                                 name:@"LoggedOut"
                                               object:nil];
}

- (void)presentLoginScreen {
	LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:loginViewController animated:YES];
}

- (void)setupUserInterface {
	[self.loginButton addTarget:self action:@selector(presentLoginScreen) forControlEvents:UIControlEventTouchUpInside];
	[self.logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setupTapGestures {
	// Set up recognizers.
	UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	doubleTapRecognizer.numberOfTapsRequired = 2;
	doubleTapRecognizer.delegate = self;
	[self.view addGestureRecognizer:doubleTapRecognizer];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	tapRecognizer.delegate = self;
	[self.view addGestureRecognizer:tapRecognizer];
}

- (void)setupLogin {
	if ([User loggedIn]) {
		self.user = [[User alloc] initWithDictionaryFromUser:[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY]];
		[self.loginButton setHidden:YES];
		[self.logoutButton setHidden:NO];
		NSLog(@"User is logged in");
		self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@", self.user.email];
	} else {
		[self presentLoginScreen];
		[self.loggedInLabel setText:@"Not Logged In"];
		[self.loginButton setHidden:NO];
		[self.logoutButton setHidden:YES];
	}
}

- (void)logout {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_KEY];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedOut" object:self];

}

- (void)updateCredentials {
	[self setupLogin];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupNotifications];
	[self setupLogin];
	[self setupTapGestures];
	[self setupUserInterface];

}

- (void)viewDidUnload {
	[self setLoginButton:nil];
	[self setLoggedInLabel:nil];
	[self setLogoutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 9;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *images = [NSArray arrayWithObjects:
					   @"twitter", 
					   @"key", 
					   @"speech", 
					   @"magnifier", 
					   @"scissors", 
					   @"actions", 
					   @"Text", 
					   @"heart", 
					   @"gear", 
					   nil];
	if (tileNumber >= 0 && tileNumber < images.count) {
		return [UIImage imageNamed:[images objectAtIndex:tileNumber]];
	}
	
	return [UIImage imageNamed:@"Text"];
}


- (NSString *)labelForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *labels = [NSArray arrayWithObjects:
					   @"Twitter", 
					   @"Key", 
					   @"Speech balloon", 
					   @"Magnifying glass", 
					   @"Scissors", 
					   @"Actions", 
					   @"Text", 
					   @"Heart", 
					   @"Settings", 
					   nil];
	if (tileNumber >= 0 && tileNumber < labels.count) {
		return [labels objectAtIndex:tileNumber];
	}
	
	return @"Tile";
}


- (NSString *)descriptionForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *hints = [NSArray arrayWithObjects:
					  @"Sends a tweet", 
					  @"Unlock something", 
					  @"Sends a message", 
					  @"Zooms in", 
					  @"Cuts something", 
					  @"Shows export options", 
					  @"Adds some text", 
					  @"Marks something as a favourite", 
					  @"Shows some settings", 
					  nil];
	if (tileNumber >= 0 && tileNumber < hints.count) {
		return [hints objectAtIndex:tileNumber];
	}
	
	return @"It's a tile button!";
}


- (UIImage *)backgroundImageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 1) {
		return [UIImage imageNamed:@"purple_gradient"];
	} else if (tileNumber == 4) {
		return [UIImage imageNamed:@"orange_gradient"];
	} else if (tileNumber == 7) {
		return [UIImage imageNamed:@"red_gradient"];
	} else if (tileNumber == 5) {
		return [UIImage imageNamed:@"yellow_gradient"];
	} else if (tileNumber == 8) {
		return [UIImage imageNamed:@"green_gradient"];
	} else if (tileNumber == -1) {
		return [UIImage imageNamed:@"grey_gradient"];
	}
	
	return [UIImage imageNamed:@"blue_gradient"];
}


- (BOOL)isTileEnabled:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 2 || tileNumber == 6) {
		return NO;
	}
	
	return YES;
}


- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:_tileController]);
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	_tileController = nil;
}


#pragma mark - Gesture handling


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	// Ensure that only touches on our own view are sent to the gesture recognisers.
	if (touch.view == self.view) {
		return YES;
	}
	
	return NO;
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
	// Find out where the gesture took place.
	CGPoint loc = [gestureRecognizer locationInView:self.view];
	if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]] && ((UITapGestureRecognizer *)gestureRecognizer).numberOfTapsRequired == 2) {
		// This was a double-tap.
		// If there isn't already a visible TileMenu, we should create one if necessary, and show it.
		if (!_tileController || _tileController.isVisible == NO) {
			if (!_tileController) {
				// Create a tileController.
				_tileController = [[MGTileMenuController alloc] initWithDelegate:self];
				_tileController.dismissAfterTileActivated = NO; // to make it easier to play with in the demo app.
			}
			// Display the TileMenu.
			[_tileController displayMenuCenteredOnPoint:loc inView:self.view];
		}
		
	} else {
		// This wasn't a double-tap, so we should hide the TileMenu if it exists and is visible.
		if (_tileController && _tileController.isVisible == YES) {
			// Only dismiss if the tap wasn't inside the tile menu itself.
			if (!CGRectContainsPoint(_tileController.view.frame, loc)) {
				[_tileController dismissMenu];
			}
		}
	}
}



@end
