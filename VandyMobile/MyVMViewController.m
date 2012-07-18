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
@synthesize tileController = _tileController;


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


#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 9;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	
	// Set up recognizers.
	UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	doubleTapRecognizer.numberOfTapsRequired = 2;
	doubleTapRecognizer.delegate = self;
	[self.view addGestureRecognizer:doubleTapRecognizer];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	tapRecognizer.delegate = self;
	[self.view addGestureRecognizer:tapRecognizer];
    
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

- (void)viewDidAppear:(BOOL)animated {
    
    // If the user isn't logged in yet, log them in
    if (!self.flag) {
        [self setupLogin];
        self.flag = YES;
    }
    
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
