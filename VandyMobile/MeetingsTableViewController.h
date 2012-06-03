//
//  VMMeetingsTableViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface MeetingsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextMeetingImageView;
@property (strong, nonatomic) NSArray *results;
@end
