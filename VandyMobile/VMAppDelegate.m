//
//  VMAppDelegate.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMAppDelegate.h"
#import "MeetingsTableViewController.h"

@implementation VMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	// Create TabBarController
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
	// Create view controllers with tabBarItems
	MeetingsTableViewController *VMMeetingsTVC = [[MeetingsTableViewController alloc] initWithNibName:@"MeetingsTableViewController" bundle:nil];
	UITabBarItem* meetingItem = [[UITabBarItem alloc] initWithTitle:@"Meetings" image:[UIImage imageNamed:@"112-group.png"] tag:0];
	VMMeetingsTVC.tabBarItem = meetingItem;
	
    // Create Meeting NavigationController
    UINavigationController *meetingsNavigationController = [[UINavigationController alloc] initWithRootViewController:VMMeetingsTVC];
    
    // Set the background image for *all* UINavigationItems
    UIImage *buttonBack30 = [[UIImage imageNamed:@"NewBackButton"] 
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *button30 = [[UIImage imageNamed:@"NewBarButton"] 
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     
	// Add view controllers to an array
	NSArray *viewControllers = [NSArray arrayWithObject:meetingsNavigationController];
	
	// Add view controllers array to tabBar
	tabBarController.viewControllers = viewControllers;
	
	// Set rootViewController
	self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
