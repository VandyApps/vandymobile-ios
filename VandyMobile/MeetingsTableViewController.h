//
//  VMMeetingsTableViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "Meeting.h"

@interface MeetingsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextMeetingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nextMeetingTopic;
@property (weak, nonatomic) IBOutlet UILabel *nextMeetingTime;

@property (strong, nonatomic) Meeting *nextMeeting;
@property (strong, nonatomic) NSArray *results;
@end
