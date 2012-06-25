//
//  AddMeetingViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMeetingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> 

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *formFields;
@property (strong, nonatomic) UIToolbar *keyboardTools;
@property (nonatomic) NSInteger currentTextFieldTag;

@end
