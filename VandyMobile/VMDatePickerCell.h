//
//  VMDatePickerCell.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMFormCell.h"

@protocol VMDatePickerCellDelegate;

@interface VMDatePickerCell : VMFormCell

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel	*dateLabel;
@property (nonatomic, strong) NSString  *formattedDate;
@property (nonatomic, strong) id<VMDatePickerCellDelegate> delegate;

+ (VMDatePickerCell *)textFieldCellWithTitle:(NSString *)title;

@end

@protocol VMDatePickerCellDelegate <NSObject>

- (void)openDatePicker;
- (void)dismissDatePicker;
- (void)pickerChanged:(id)sender;

@end
