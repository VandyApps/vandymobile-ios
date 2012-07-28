//
//  GithubRepoTableViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/26/12.
//
//

#import <UIKit/UIKit.h>
#import "VMTableView.h"

@interface GithubRepoTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *results;


@end