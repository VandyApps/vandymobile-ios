//
//  NewsViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@end
