//
//  VMCheckboxCell.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMCheckboxCell.h"

@interface VMCheckboxCell()
//- (void)toggleChecked;
//- (void)updateCheckboxStatus;
@end

@implementation VMCheckboxCell

//@synthesize delegate = _delegate;
//@synthesize checked = _checked;
@synthesize checkBox = _checkBox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellStyleDefault;
        self.backgroundColor = [UIColor colorWithWhite:.4 alpha:.3];
        
        self.textLabel.backgroundColor  = [UIColor clearColor];
        self.textLabel.font             = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        self.textLabel.textColor        = [UIColor whiteColor];         
        
        self.detailTextLabel.backgroundColor    = [UIColor clearColor];
        
        self.checkBox = [[UISwitch alloc] initWithFrame:CGRectMake(230, 10, 250, 20)];
		[self addSubview:self.checkBox];
		
		UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)onTap:(UIGestureRecognizer *)recognizer {
    [self toggleChecked];
	[self.superview endEditing:YES];
}

- (void)toggleChecked {
    if ([self.checkBox isOn]) {
		[self.checkBox setOn:NO];
	} else {
		[self.checkBox setOn:YES];
	}
     
}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    [self updateCheckboxStatus];
//    
//    CGRect rect = self.imageView.frame;
//    rect.origin.x += 10;
//    self.imageView.frame = rect;
//    
//    rect = self.textLabel.frame;
//    rect.origin.x += 10;
//    self.textLabel.frame = rect;
//    
//    self.detailTextLabel.frame = CGRectMake(55, 20, 250, 20);
//}
//
//- (void)updateCheckboxStatus {
//    NSString *imageName = self.checked ? @"check-active.png" : @"check.png";
//    self.imageView.image = [UIImage imageNamed:imageName];
//    
//    // we want to prevent this row from also being decorated with the checkmark accessory
//    self.accessoryType = UITableViewCellAccessoryNone;
//}
//
//- (void)setChecked:(BOOL)isChecked {
//    self.checked = isChecked;
//    [self updateCheckboxStatus];
//}

@end
