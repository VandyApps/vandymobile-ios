//
//  VMDatePickerCell.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMDatePickerCell.h"

@implementation VMDatePickerCell


@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize delegate = _delegate;
@synthesize formattedDate = _formattedDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor			= [UIColor colorWithWhite:.4 alpha:.3];
		
        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 90, 15)];
        self.titleLabel.textColor       = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font            = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self addSubview:self.titleLabel];
        
        
        self.dateLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(115, 8, 180, 35)];
		self.dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dateLabel];
        
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

- (void)onTap:(UIGestureRecognizer *)recognizer {
    [self.dateLabel becomeFirstResponder];
	[self.superview endEditing:YES];
	[self.delegate openDatePicker];
}

+ (VMDatePickerCell *)textFieldCellWithTitle:(NSString *)title {
    VMDatePickerCell *cell   = [[VMDatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle     = UITableViewCellSelectionStyleBlue;;
    cell.titleLabel.text    = title;
    return cell;
}


@end
