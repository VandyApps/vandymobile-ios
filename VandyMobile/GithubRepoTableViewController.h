//
//  GithubRepoTableViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/28/12.
//
//

#import <UIKit/UIKit.h>
#import "App.h"

@interface GithubRepoTableViewController : UITableViewController

@property (strong, nonatomic) App *app;
@property (strong, nonatomic) NSArray *results;


@end
