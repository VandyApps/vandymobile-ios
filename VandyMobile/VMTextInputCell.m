//
//  VMTextInputCell.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMTextInputCell.h"

@implementation VMTextInputCell

@synthesize titleLabel = _titleLabel;
@synthesize textField = _textField;

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
        
        
        self.textField                  = [[UITextField alloc] initWithFrame:CGRectMake(115, 17, 180, 35)];
		self.textField.text				= @"";
        [self addSubview:self.textField];
        
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

- (void)onTap:(UIGestureRecognizer *)recognizer {
    [self.textField becomeFirstResponder];
}

+ (VMTextInputCell *)textFieldCellWithTitle:(NSString *)title forDelegate:(id)target {
    VMTextInputCell *cell   = [[VMTextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text    = title;
    cell.textField.delegate = target;
    return cell;
}


@end
