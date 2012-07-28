//
//  VMCheckboxCell.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMFormCell.h"

/* Usage: This subclass utilizes the selected propery of the table cell.  Consumers must call setChecked: in order to 
 toggle the state of the checkbox.
 */

@protocol VMCheckboxCellDelegate;

@interface VMCheckboxCell : VMFormCell

/* optional delegate:  use this if you need to be notified when the checked status changes */
//@property (nonatomic, strong) id<VMCheckboxCellDelegate> delegate;

/* set the state of the checkbox */
//@property (nonatomic) BOOL checked;

@property (nonatomic, strong) UISwitch *checkBox;

@end

@protocol DRCheckboxCellDelegate <NSObject>

//- (void)checkboxCell:(VMCheckboxCell *)cell wasSelected:(BOOL)selected;

@end
