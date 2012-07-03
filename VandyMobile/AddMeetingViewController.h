//
//  AddMeetingViewController.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMTextInputCell.h"
#import "VMCheckboxCell.h"
#import "VMDatePickerCell.h"

@interface AddMeetingViewController : UITableViewController <UITextFieldDelegate, VMDatePickerCellDelegate>

@property (nonatomic, strong) VMDatePickerCell *dateCell;
@property (nonatomic, strong) VMCheckboxCell  *hasFoodCell;
@property (nonatomic, strong) VMTextInputCell *speakerCell;
@property (nonatomic, strong) VMTextInputCell *topicCell;
@property (nonatomic, strong) VMTextInputCell *descriptionCell;


@property (nonatomic, strong) UIDatePicker *datePickerView;
@property (nonatomic) BOOL datePickerOpen;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIBarButtonItem *addMeetingButton;



@end
