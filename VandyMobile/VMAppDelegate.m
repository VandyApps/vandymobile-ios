//
//  VMAppDelegate.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMAppDelegate.h"
#import "MeetingsTableViewController.h"
#import "NewsViewController.h"
#import "MyVMViewController.h"
#import "AppsTableViewController.h"
#import "SDURLCache.h"

#define USER_KEY @"user"

@implementation VMAppDelegate

@synthesize window = _window;
@synthesize root = _root;

- (void)prepareCache {
    SDURLCache *cache = [[SDURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                      diskCapacity:20 * 1024 * 1024
                                                          diskPath:[SDURLCache defaultCachePath]];
    cache.minCacheInterval = 0;
    [NSURLCache setSharedURLCache:cache];
    NSLog(@"Cache is being logged to: %@", [SDURLCache defaultCachePath]);
}

- (void)setupUserDefaults {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_KEY];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self prepareCache];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	// Create TabBarController
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	

    // Set the background image for *all* UINavigationItems
    UIImage *buttonBack30 = [[UIImage imageNamed:@"NewBackButton"] 
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *button30 = [[UIImage imageNamed:@"NewBarButton"] 
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    

    //[[UI appearance] setBackgroundColor:[UIColor colorWithRed:0.969 green:0.831 blue:0.224 alpha:1] /*#f7d439*/];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"NewTabBarV3"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"NewTabBarSelected"]];
//    [[UITabBarItem appearance] setBackgroundColor:[UIColor colorWithRed:0.188 green:0.188 blue:0.188 alpha:1] /*#303030*/ ];
     
	// Set rootViewController
	self.window.rootViewController = tabBarController;
    self.root = (UITabBarController *)self.window.rootViewController;
    [self.window makeKeyAndVisible];
    
    // Create view controllers with tabBarItems
	MeetingsTableViewController *VMMeetingsTVC = [[MeetingsTableViewController alloc] initWithNibName:@"MeetingsTableViewController" bundle:nil];
	UITabBarItem* meetingItem = [[UITabBarItem alloc] initWithTitle:@"Meetings" image:[UIImage imageNamed:@"08-chat"] tag:0];
	VMMeetingsTVC.tabBarItem = meetingItem;
    
    MyVMViewController *myVMViewController = [[MyVMViewController alloc] initWithNibName:@"MyVMViewController" bundle:nil];
//	MyVMViewController *myVMViewController = [MyVMViewController sharedInstance];
    UITabBarItem* myVMItem = [[UITabBarItem alloc] initWithTitle:@"myVM" image:[UIImage imageNamed:@"17-bar-chart"] tag:0];
    myVMViewController.tabBarItem = myVMItem;
    
    AppsTableViewController	*appsTVC = [[AppsTableViewController alloc] initWithNibName:@"AppsTableViewController" bundle:nil];
    UITabBarItem* appsItem = [[UITabBarItem alloc] initWithTitle:@"Apps" image:[UIImage imageNamed:@"112-group"] tag:0];
    appsTVC.tabBarItem = appsItem;
    
    NewsViewController *newsViewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    UITabBarItem* newsItem = [[UITabBarItem alloc] initWithTitle:@"News" image:[UIImage imageNamed:@"66-microphone"] tag:0];
    newsViewController.tabBarItem = newsItem;
    
	
    // Create Meeting NavigationControllers
    UINavigationController *meetingsNavigationController = [[UINavigationController alloc] initWithRootViewController:VMMeetingsTVC];
    UINavigationController *newsNavigationController = [[UINavigationController alloc] initWithRootViewController:newsViewController];
	UINavigationController *appsNavigationController = [[UINavigationController alloc] initWithRootViewController:appsTVC];
    
    
    // Add view controllers to an array
	NSArray *viewControllers = [NSArray arrayWithObjects:meetingsNavigationController, newsNavigationController, appsNavigationController, myVMViewController, nil];
	
	// Add view controllers array to tabBar
	self.root.viewControllers = viewControllers;
    
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
