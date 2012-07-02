//
//  AddMeetingViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMTextInputCell.h"

@interface AddMeetingViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) VMTextInputCell *dayCell;
@property (nonatomic, strong) VMTextInputCell *dateCell;
@property (nonatomic, strong) VMTextInputCell *speakerCell;
@property (nonatomic, strong) VMTextInputCell *topicCell;
@property (nonatomic, strong) VMTextInputCell *descriptionCell;


@end
